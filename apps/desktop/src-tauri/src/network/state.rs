use std::sync::Arc;
use tokio::sync::{mpsc, Mutex};

use super::session_crypto::SessionCrypto;

#[derive(Clone, serde::Serialize, serde::Deserialize)]
pub struct PairedDevice {
    pub device_id: String,
    pub device_name: String,
    pub paired_at: String,
    pub pairing_secret: String,
}

/// Shared application state managed by Tauri.
pub struct AppState {
    pub crypto: Arc<Mutex<SessionCrypto>>,
    pub connected: Arc<Mutex<bool>>,
    pub paired: Arc<Mutex<bool>>,
    pub desktop_id: String,
    pub desktop_name: String,
    pub writer_tx: Arc<Mutex<Option<mpsc::Sender<Vec<u8>>>>>,
    pub seq_counter: Arc<Mutex<i64>>,
    pub paired_devices: Arc<Mutex<Vec<PairedDevice>>>,
}

impl AppState {
    pub fn new() -> Self {
        Self {
            crypto: Arc::new(Mutex::new(SessionCrypto::new())),
            connected: Arc::new(Mutex::new(false)),
            paired: Arc::new(Mutex::new(false)),
            desktop_id: uuid::Uuid::new_v4().to_string(),
            desktop_name: whoami::devicename(),
            writer_tx: Arc::new(Mutex::new(None)),
            seq_counter: Arc::new(Mutex::new(0)),
            paired_devices: Arc::new(Mutex::new(Vec::new())),
        }
    }

    pub async fn next_seq(&self) -> i64 {
        let mut seq = self.seq_counter.lock().await;
        let val = *seq;
        *seq += 1;
        val
    }

    /// Send raw bytes over the TCP connection.
    pub async fn send_raw(&self, data: Vec<u8>) -> Result<(), String> {
        let tx = self.writer_tx.lock().await;
        if let Some(ref sender) = *tx {
            sender
                .send(data)
                .await
                .map_err(|e| format!("Send failed: {}", e))
        } else {
            Err("Not connected".into())
        }
    }

    /// Send a plaintext (unencrypted) length-prefixed message.
    pub async fn send_plaintext_message(
        &self,
        msg: &super::protocol::ProtocolMessage,
    ) -> Result<(), String> {
        self.send_raw(msg.to_bytes()).await
    }

    /// Send an encrypted length-prefixed message.
    pub async fn send_encrypted_message(
        &self,
        msg: &super::protocol::ProtocolMessage,
    ) -> Result<(), String> {
        let json = msg.to_json_string();
        let mut crypto = self.crypto.lock().await;
        let encrypted = crypto.encrypt_message(&json)?;
        drop(crypto);

        let bytes = encrypted.as_bytes();
        let len = bytes.len() as u32;
        let mut data = Vec::with_capacity(4 + bytes.len());
        data.extend_from_slice(&len.to_be_bytes());
        data.extend_from_slice(bytes);
        self.send_raw(data).await
    }

}
