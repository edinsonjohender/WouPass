use std::sync::Arc;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::TcpListener;
use tokio::sync::{mpsc, Mutex};

use base64::{engine::general_purpose::STANDARD as BASE64, Engine};
use tauri::{AppHandle, Emitter, Manager};

use super::protocol::{MessageType, ProtocolMessage, PORT};
use super::session_crypto::SessionCrypto;
use super::state::{AppState, PairedDevice};

pub async fn start_server(app: AppHandle) -> Result<(), String> {
    let listener = TcpListener::bind(format!("0.0.0.0:{}", PORT))
        .await
        .map_err(|e| format!("Bind failed: {}", e))?;

    let _ = app.emit("server-started", serde_json::json!({"port": PORT}));

    let app_clone = app.clone();
    tokio::spawn(async move {
        loop {
            match listener.accept().await {
                Ok((stream, addr)) => {
                    let _ = app_clone.emit(
                        "client-connecting",
                        serde_json::json!({"addr": addr.to_string()}),
                    );
                    handle_connection(stream, app_clone.clone()).await;
                }
                Err(_) => {}
            }
        }
    });

    Ok(())
}

async fn handle_connection(stream: tokio::net::TcpStream, app: AppHandle) {
    let (read_half, write_half) = tokio::io::split(stream);
    let (tx, mut rx) = mpsc::channel::<Vec<u8>>(32);

    let state = app.state::<Arc<AppState>>();
    *state.writer_tx.lock().await = Some(tx);
    *state.connected.lock().await = true;
    *state.paired.lock().await = false;

    // Reset crypto for new connection
    *state.crypto.lock().await = SessionCrypto::new();
    *state.seq_counter.lock().await = 0;

    // Writer task
    let write_half = Arc::new(Mutex::new(write_half));
    let writer = write_half.clone();
    tokio::spawn(async move {
        while let Some(data) = rx.recv().await {
            let mut w = writer.lock().await;
            if w.write_all(&data).await.is_err() {
                break;
            }
            let _ = w.flush().await;
        }
    });

    // Reader loop
    let state_arc = state.inner().clone();
    let app_clone = app.clone();

    let mut read = read_half;
    let mut buf = Vec::new();

    loop {
        let mut chunk = [0u8; 4096];
        match read.read(&mut chunk).await {
            Ok(0) => break,
            Ok(n) => buf.extend_from_slice(&chunk[..n]),
            Err(_) => break,
        }

        while buf.len() >= 4 {
            let len = u32::from_be_bytes([buf[0], buf[1], buf[2], buf[3]]) as usize;
            if len > 10_000_000 || buf.len() < 4 + len {
                break;
            }

            let payload_raw = buf[4..4 + len].to_vec();
            buf.drain(..4 + len);

            let payload_str = String::from_utf8_lossy(&payload_raw).to_string();

            // Try to decrypt if session key exists (after ECDH exchange, before full pairing)
            let has_session_key = state_arc.crypto.lock().await.is_established();
            let json_str = if has_session_key {
                let mut crypto = state_arc.crypto.lock().await;
                match crypto.decrypt_message(&payload_str) {
                    Ok(d) => d,
                    Err(_) => {
                        // Maybe it's plaintext (PairRequest before key exchange)
                        payload_str
                    }
                }
            } else {
                payload_str
            };

            match ProtocolMessage::from_json(&json_str) {
                Ok(msg) => {

                    let should_close = handle_message(&msg, &app_clone, &state_arc).await;
                    if should_close {
    
                        *state_arc.writer_tx.lock().await = None;
                        return;
                    }
                }
                Err(e) => {

                }
            }
        }
    }

    *state_arc.connected.lock().await = false;
    *state_arc.paired.lock().await = false;
    *state_arc.writer_tx.lock().await = None;
    let _ = app.emit("device-disconnected", serde_json::json!({}));
    let _ = app.emit(
        "connection-status",
        serde_json::json!({"connected": false}),
    );
}

/// Returns true if the connection should be closed after this message.
async fn handle_message(msg: &ProtocolMessage, app: &AppHandle, state: &Arc<AppState>) -> bool {
    match msg.msg_type {
        MessageType::PairRequest => {
            handle_pair_request(msg, app, state).await;
            false
        }
        MessageType::PairConfirm => {
            handle_pair_confirm(msg, app, state).await;
            false
        }
        MessageType::Reconnect => {
            handle_reconnect(msg, app, state).await;
            false
        }
        MessageType::ReconnectAuth => {
            handle_reconnect_auth(msg, app, state).await;
            false
        }
        MessageType::PushCredential => {
            handle_push_credential(msg, app, state).await;
            true // close connection after push
        }
        _ => false,
    }
}

async fn handle_pair_request(msg: &ProtocolMessage, app: &AppHandle, state: &Arc<AppState>) {
    let phone_pub_b64 = match msg.payload.get("ecdh_public_key").and_then(|v| v.as_str()) {
        Some(k) => k,
        None => return,
    };

    let phone_pub = match BASE64.decode(phone_pub_b64) {
        Ok(bytes) if bytes.len() == 32 => {
            let mut arr = [0u8; 32];
            arr.copy_from_slice(&bytes);
            arr
        }
        _ => return,
    };

    // Save phone info
    if let Some(name) = msg.payload.get("phone_name").and_then(|v| v.as_str()) {
        let _ = app.emit("phone-name", serde_json::json!({"name": name}));
    }

    // Generate our keypair and derive session key
    let our_pub = {
        let mut crypto = state.crypto.lock().await;
        let pub_key = crypto.generate_keypair();

        // Derive session key - QR is the verification channel
        if crypto.derive_session_key(&phone_pub, "qr_verified").is_err() {
            return;
        }
        pub_key
    };

    // Send PAIR_RESPONSE (plaintext, before encryption starts)
    let seq = state.next_seq().await;
    let response = ProtocolMessage::new(
        MessageType::PairResponse,
        seq,
        serde_json::json!({
            "accepted": true,
            "desktop_id": state.desktop_id,
            "desktop_name": state.desktop_name,
            "ecdh_public_key": BASE64.encode(our_pub),
        }),
    );

    let _ = state.send_plaintext_message(&response).await;
}

async fn handle_pair_confirm(msg: &ProtocolMessage, app: &AppHandle, state: &Arc<AppState>) {
    let verification = match msg.payload.get("verification").and_then(|v| v.as_str()) {
        Some(v) => v,
        None => return,
    };

    let is_valid = {
        let crypto = state.crypto.lock().await;
        crypto.verify_hmac("PAIR_CONFIRM", verification).unwrap_or(false)
    };

    if !is_valid {
        let _ = app.emit(
            "pairing-failed",
            serde_json::json!({"reason": "verification failed"}),
        );
        return;
    }

    // Send PAIR_CONFIRMED (encrypted)
    let our_verification = {
        let crypto = state.crypto.lock().await;
        crypto
            .create_verification("PAIR_CONFIRMED")
            .unwrap_or_default()
    };

    let seq = state.next_seq().await;
    let confirmed = ProtocolMessage::new(
        MessageType::PairConfirmed,
        seq,
        serde_json::json!({"verification": our_verification}),
    );

    let _ = state.send_encrypted_message(&confirmed).await;

    *state.paired.lock().await = true;

    // Save to paired_devices list
    let device_id = msg
        .payload
        .get("deviceId")
        .and_then(|v| v.as_str())
        .unwrap_or(&msg.id)
        .to_string();
    let device_name = msg
        .payload
        .get("deviceName")
        .and_then(|v| v.as_str())
        .unwrap_or("Phone")
        .to_string();

    // Derive pairing secret for PSK-encrypted reconnect
    let pairing_secret = {
        let crypto = state.crypto.lock().await;
        crypto
            .create_verification("pairing-secret-v1")
            .unwrap_or_default()
    };

    let new_device = PairedDevice {
        device_id: device_id.clone(),
        device_name: device_name.clone(),
        paired_at: {
            let dur = std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)
                .unwrap();
            format!("{}", dur.as_secs())
        },
        pairing_secret,
    };

    {
        let mut devices = state.paired_devices.lock().await;
        // Don't duplicate
        if !devices.iter().any(|d| d.device_id == device_id) {
            devices.push(new_device.clone());
        }
    }

    let _ = app.emit(
        "pairing-complete",
        serde_json::json!({
            "success": true,
            "device_id": device_id,
            "device_name": device_name,
        }),
    );
    let _ = app.emit(
        "connection-status",
        serde_json::json!({"connected": true}),
    );
}

async fn handle_reconnect(msg: &ProtocolMessage, _app: &AppHandle, state: &Arc<AppState>) {
    let device_id = match msg.payload.get("device_id")
        .or_else(|| msg.payload.get("deviceId"))
        .and_then(|v| v.as_str()) {
        Some(id) => id.to_string(),
        None => return,
    };

    // Check if it matches our own desktop_id first
    let is_self = device_id == state.desktop_id;

    let pairing_secret = if is_self {
        // The phone saved our desktop_id, look up by checking all paired devices
        let devices = state.paired_devices.lock().await;

        devices.first().map(|d| d.pairing_secret.clone())
    } else {
        let devices = state.paired_devices.lock().await;
        devices
            .iter()
            .find(|d| d.device_id == device_id)
            .map(|d| d.pairing_secret.clone())
    };

    let pairing_secret = match pairing_secret {
        Some(s) if !s.is_empty() => s,
        _ => {
            let seq = state.next_seq().await;
            let err = ProtocolMessage::new(
                MessageType::Error,
                seq,
                serde_json::json!({"reason": "unknown device"}),
            );
            let _ = state.send_plaintext_message(&err).await;
            return;
        }
    };

    // Set PSK on the crypto so all subsequent messages are encrypted/decrypted with it
    {
        let mut crypto = state.crypto.lock().await;
        crypto.set_pre_shared_key(&pairing_secret);
    }

    // The next message (ReconnectAuth) will be decrypted by the main loop using this PSK
}

async fn handle_reconnect_auth(msg: &ProtocolMessage, app: &AppHandle, state: &Arc<AppState>) {
    // Phase 2: PSK-encrypted RECONNECT_AUTH contains the ECDH public key
    let phone_pub_b64 = match msg.payload.get("ecdh_public_key")
        .or_else(|| msg.payload.get("publicKey"))
        .and_then(|v| v.as_str()) {
        Some(k) => k,
        None => return,
    };

    let phone_pub = match BASE64.decode(phone_pub_b64) {
        Ok(bytes) if bytes.len() == 32 => {
            let mut arr = [0u8; 32];
            arr.copy_from_slice(&bytes);
            arr
        }
        _ => return,
    };

    // Generate new ECDH keypair (need a fresh SessionCrypto for key generation)
    let mut ephemeral_crypto = SessionCrypto::new();
    let our_pub = ephemeral_crypto.generate_keypair();

    // Send RECONNECT_OK encrypted with PSK (contains our ECDH public key)
    let seq = state.next_seq().await;
    let response = ProtocolMessage::new(
        MessageType::ReconnectOk,
        seq,
        serde_json::json!({
            "desktop_id": state.desktop_id,
            "ecdh_public_key": BASE64.encode(our_pub),
        }),
    );

    // Encrypt with current PSK crypto and send
    let _ = state.send_encrypted_message(&response).await;

    // Now derive the ephemeral session key from ECDH and switch crypto to it
    if ephemeral_crypto
        .derive_session_key(&phone_pub, "qr_verified")
        .is_err()
    {
        return;
    }

    // Replace crypto with the new ephemeral session crypto
    *state.crypto.lock().await = ephemeral_crypto;
    *state.paired.lock().await = true;

    let _ = app.emit(
        "connection-status",
        serde_json::json!({"connected": true}),
    );
}

async fn handle_push_credential(msg: &ProtocolMessage, app: &AppHandle, _state: &Arc<AppState>) {
    let title = msg
        .payload
        .get("title")
        .and_then(|v| v.as_str())
        .unwrap_or("Unknown")
        .to_string();
    let username = msg
        .payload
        .get("username")
        .and_then(|v| v.as_str())
        .unwrap_or("")
        .to_string();
    let password = msg
        .payload
        .get("password")
        .and_then(|v| v.as_str())
        .unwrap_or("")
        .to_string();
    let uri = msg
        .payload
        .get("uri")
        .and_then(|v| v.as_str())
        .unwrap_or("")
        .to_string();
    let auto_clear = msg
        .payload
        .get("auto_clear_seconds")
        .and_then(|v| v.as_u64())
        .unwrap_or(30);

    // Copy password to clipboard
    if !password.is_empty() {
        copy_to_clipboard_with_clear(app, &password, auto_clear);
    }

    // Emit credential-received event to frontend
    let _ = app.emit(
        "credential-received",
        serde_json::json!({
            "title": title,
            "username": username,
            "password": password,
            "uri": uri,
            "auto_clear_seconds": auto_clear,
        }),
    );

}

fn copy_to_clipboard_with_clear(app: &AppHandle, text: &str, clear_secs: u64) {
    use tauri_plugin_clipboard_manager::ClipboardExt;
    let _ = app.clipboard().write_text(text);
    let _ = app.emit(
        "clipboard-copied",
        serde_json::json!({"clear_in_seconds": clear_secs}),
    );
    let app_clone = app.clone();
    tokio::spawn(async move {
        tokio::time::sleep(std::time::Duration::from_secs(clear_secs)).await;
        use tauri_plugin_clipboard_manager::ClipboardExt;
        let _ = app_clone.clipboard().write_text("");
        let _ = app_clone.emit("clipboard-cleared", serde_json::json!({}));
    });
}
