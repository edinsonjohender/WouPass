mod network;

use std::sync::Arc;

use tauri::{
    menu::{Menu, MenuItem},
    tray::{MouseButton, MouseButtonState, TrayIconBuilder, TrayIconEvent},
    Manager,
};

use network::protocol::PORT;
use network::server;
use network::state::AppState;

// ── Helpers ────────────────────────────────────────────────────────────────

fn get_local_ip() -> String {
    use std::net::UdpSocket;
    let socket = UdpSocket::bind("0.0.0.0:0").unwrap();
    socket.connect("8.8.8.8:80").unwrap();
    socket.local_addr().unwrap().ip().to_string()
}

// ── Tauri Commands ──────────────────────────────────────────────────────────

#[tauri::command]
fn copy_to_clipboard(text: String, app: tauri::AppHandle) -> Result<(), String> {
    use tauri_plugin_clipboard_manager::ClipboardExt;
    app.clipboard()
        .write_text(&text)
        .map_err(|e| e.to_string())?;

    let app_clone = app.clone();
    std::thread::spawn(move || {
        std::thread::sleep(std::time::Duration::from_secs(30));
        let _ = app_clone.clipboard().write_text("");
    });

    Ok(())
}

/// Start the TCP server (called once on app startup).
#[tauri::command]
async fn start_server(app: tauri::AppHandle) -> Result<(), String> {
    server::start_server(app).await
}

/// Return QR data as JSON: { ip, port, desktop_id, desktop_name }
#[tauri::command]
async fn get_qr_data(app: tauri::AppHandle) -> Result<serde_json::Value, String> {
    let state = app.state::<Arc<AppState>>();
    let ip = get_local_ip();
    Ok(serde_json::json!({
        "ip": ip,
        "port": PORT,
        "desktop_id": state.desktop_id,
        "desktop_name": state.desktop_name,
    }))
}

/// Get the current connection and pairing status.
#[tauri::command]
async fn get_connection_status(app: tauri::AppHandle) -> Result<serde_json::Value, String> {
    let state = app.state::<Arc<AppState>>();
    let connected = *state.connected.lock().await;
    let paired = *state.paired.lock().await;
    Ok(serde_json::json!({
        "connected": connected,
        "paired": paired,
        "desktop_id": state.desktop_id,
        "desktop_name": state.desktop_name,
    }))
}

/// Returns list of paired devices.
#[tauri::command]
async fn get_paired_devices(app: tauri::AppHandle) -> Result<Vec<network::state::PairedDevice>, String> {
    let state = app.state::<Arc<AppState>>();
    let devices = state.paired_devices.lock().await;
    Ok(devices.clone())
}

/// Removes a paired device by ID.
#[tauri::command]
async fn remove_paired_device(device_id: String, app: tauri::AppHandle) -> Result<(), String> {
    let state = app.state::<Arc<AppState>>();
    let mut devices = state.paired_devices.lock().await;
    devices.retain(|d| d.device_id != device_id);
    Ok(())
}

/// Returns true if there are any paired devices.
#[tauri::command]
async fn has_paired_devices(app: tauri::AppHandle) -> Result<bool, String> {
    let state = app.state::<Arc<AppState>>();
    let devices = state.paired_devices.lock().await;
    Ok(!devices.is_empty())
}

// ── App Setup ───────────────────────────────────────────────────────────────

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .plugin(tauri_plugin_clipboard_manager::init())
        .setup(|app| {
            // Initialize shared state
            let state = Arc::new(AppState::new());
            app.manage(state);

            // Start TCP server on app launch
            let handle = app.handle().clone();
            tauri::async_runtime::spawn(async move {
                let _ = server::start_server(handle).await;
            });

            // Tray icon
            let show_i = MenuItem::with_id(app, "show", "Show WouPass", true, None::<&str>)?;
            let quit_i = MenuItem::with_id(app, "quit", "Quit", true, None::<&str>)?;
            let menu = Menu::with_items(app, &[&show_i, &quit_i])?;

            TrayIconBuilder::new()
                .icon(app.default_window_icon().unwrap().clone())
                .menu(&menu)
                .tooltip("WouPass")
                .on_menu_event(|app, event| match event.id.as_ref() {
                    "show" => {
                        if let Some(window) = app.get_webview_window("main") {
                            let _ = window.show();
                            let _ = window.set_focus();
                        }
                    }
                    "quit" => {
                        app.exit(0);
                    }
                    _ => {}
                })
                .on_tray_icon_event(|tray, event| {
                    if let TrayIconEvent::Click {
                        button: MouseButton::Left,
                        button_state: MouseButtonState::Up,
                        ..
                    } = event
                    {
                        let app = tray.app_handle();
                        if let Some(window) = app.get_webview_window("main") {
                            let _ = window.show();
                            let _ = window.set_focus();
                        }
                    }
                })
                .build(app)?;

            Ok(())
        })
        .invoke_handler(tauri::generate_handler![
            copy_to_clipboard,
            start_server,
            get_qr_data,
            get_connection_status,
            get_paired_devices,
            remove_paired_device,
            has_paired_devices,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
