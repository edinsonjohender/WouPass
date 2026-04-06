<script lang="ts">
  import { invoke } from "@tauri-apps/api/core";
  import { listen } from "@tauri-apps/api/event";
  import { getCurrentWindow } from "@tauri-apps/api/window";
  import { onMount } from "svelte";
  import QRCode from "qrcode";

  // ---- Types ----
  type View = 'qr' | 'ready' | 'received' | 'settings';

  interface PairedDevice {
    device_id: string;
    device_name: string;
    paired_at: string;
  }

  interface ReceivedCredential {
    title: string;
    username: string;
    password: string;
    uri: string;
    auto_clear_seconds: number;
  }

  // ---- State ----
  let view = $state<View>('qr');
  let qrDataUrl = $state("");
  let qrError = $state("");
  let serverReady = $state(false);
  let pairedDevices = $state<PairedDevice[]>([]);
  let credential = $state<ReceivedCredential | null>(null);
  let countdown = $state(30);
  let countdownInterval = $state<ReturnType<typeof setInterval> | null>(null);
  let copiedField = $state<string | null>(null);

  // Toast
  let toast = $state<{ msg: string; type: 'success' | 'info' } | null>(null);

  onMount(async () => {
    // Load paired devices
    try {
      pairedDevices = await invoke("get_paired_devices") as PairedDevice[];
    } catch (_) {}

    // Decide initial view
    if (pairedDevices.length > 0) {
      view = 'ready';
    } else {
      view = 'qr';
    }

    // Generate QR code
    try {
      const qrData: any = await invoke("get_qr_data");
      const qrString = JSON.stringify(qrData);
      qrDataUrl = await QRCode.toDataURL(qrString, {
        width: 200,
        margin: 2,
        color: { dark: "#EDEDED", light: "#1C1C1C" },
        errorCorrectionLevel: "M",
      });
      serverReady = true;
    } catch (e) {
      qrError = `Failed to generate QR: ${e}`;
    }

    // Listen for events
    await listen("server-started", () => {
      serverReady = true;
    });

    await listen("pairing-complete", async (e: any) => {
      const deviceId = e.payload?.device_id ?? "";
      const deviceName = e.payload?.device_name ?? "Phone";

      // Refresh paired devices list
      try {
        pairedDevices = await invoke("get_paired_devices") as PairedDevice[];
      } catch (_) {}

      view = 'ready';
      showToast("Paired successfully!");
    });

    await listen("pairing-failed", (e: any) => {
      showToast(e.payload?.reason ?? "Pairing failed", "info");
    });

    await listen("credential-received", (e: any) => {
      const p = e.payload;
      credential = {
        title: p?.title ?? "Unknown",
        username: p?.username ?? "",
        password: p?.password ?? "",
        uri: p?.uri ?? "",
        auto_clear_seconds: p?.auto_clear_seconds ?? 30,
      };
      countdown = credential.auto_clear_seconds;
      view = 'received';

      // Start countdown
      if (countdownInterval) clearInterval(countdownInterval);
      countdownInterval = setInterval(() => {
        countdown -= 1;
        if (countdown <= 0) {
          if (countdownInterval) clearInterval(countdownInterval);
          countdownInterval = null;
          credential = null;
          view = 'ready';
        }
      }, 1000);
    });

    await listen("clipboard-cleared", () => {
      // Clipboard auto-cleared
    });

    await listen("device-disconnected", () => {
      // Device disconnected
    });

    await listen("connection-status", () => {
      // Just log, no UI change needed for push model
    });
  });

  function showToast(msg: string, type: 'success' | 'info' = 'success') {
    toast = { msg, type };
    setTimeout(() => { toast = null; }, 2500);
  }

  async function copyText(text: string, field: string) {
    await invoke("copy_to_clipboard", { text });
    copiedField = field;
    showToast(`${field} copied — clears in 30s`);
    setTimeout(() => { copiedField = null; }, 2000);
  }

  async function removeDevice(deviceId: string) {
    await invoke("remove_paired_device", { deviceId });
    pairedDevices = pairedDevices.filter(d => d.device_id !== deviceId);
    if (pairedDevices.length === 0) {
      view = 'qr';
    }
  }

  function goToQr() {
    view = 'qr';
  }

  function goToReady() {
    if (pairedDevices.length > 0) {
      view = 'ready';
    } else {
      view = 'qr';
    }
  }

  async function minimizeWindow(e: MouseEvent) {
    e.stopPropagation(); e.preventDefault();
    await getCurrentWindow().hide();
  }

  async function closeWindow(e: MouseEvent) {
    e.stopPropagation(); e.preventDefault();
    await getCurrentWindow().hide();
  }
</script>

<div class="app">
  <!-- Title Bar -->
  <header class="titlebar" data-tauri-drag-region>
    <div class="tb-left" data-tauri-drag-region>
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#3ECF8E" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
      </svg>
      <span class="tb-title">WouPass</span>
    </div>
    <div class="tb-right">
      {#if view === 'ready'}
        <button class="tb-btn" onmousedown={(e) => e.stopPropagation()} onclick={() => view = 'settings'} title="Settings">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/>
          </svg>
        </button>
      {/if}
      <button class="tb-btn" onmousedown={(e) => e.stopPropagation()} onclick={minimizeWindow}>
        <svg width="10" height="10" viewBox="0 0 10 10"><path d="M0 5h10" stroke="currentColor" stroke-width="1.2"/></svg>
      </button>
      <button class="tb-btn tb-close" onmousedown={(e) => e.stopPropagation()} onclick={closeWindow}>
        <svg width="10" height="10" viewBox="0 0 10 10"><path d="M0 0l10 10M10 0L0 10" stroke="currentColor" stroke-width="1.2"/></svg>
      </button>
    </div>
  </header>

  <!-- Toast -->
  {#if toast}
    <div class="toast" class:toast-info={toast.type === 'info'}>
      <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
      <span>{toast.msg}</span>
    </div>
  {/if}

  <!-- ============ QR VIEW ============ -->
  {#if view === 'qr'}
    <div class="view-center">
      {#if qrDataUrl}
        <div class="qr-container">
          <img src={qrDataUrl} alt="QR Code" class="qr-image" />
        </div>
      {:else if qrError}
        <div class="qr-error">{qrError}</div>
      {:else}
        <div class="qr-placeholder">
          <div class="spinner"></div>
        </div>
      {/if}
      <p class="pair-desc">Scan from your phone to connect</p>
      <div class="pair-loading">
        <div class="status-dot-pulse"></div>
        <span>Waiting...</span>
      </div>
      {#if pairedDevices.length > 0}
        <button class="link-btn" onclick={goToReady}>Back to ready</button>
      {/if}
    </div>

  <!-- ============ READY VIEW ============ -->
  {:else if view === 'ready'}
    <div class="view-center">
      <div class="ready-icon">
        <svg width="56" height="56" viewBox="0 0 24 24" fill="none" stroke="#3ECF8E" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
          <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
        </svg>
      </div>
      <h2 class="ready-title">Ready</h2>
      <p class="ready-desc">Send passwords from your phone</p>
      <p class="ready-sub">Paired with {pairedDevices.length} device{pairedDevices.length !== 1 ? 's' : ''}</p>
    </div>

  <!-- ============ RECEIVED VIEW ============ -->
  {:else if view === 'received' && credential}
    <div class="view-center received-view">
      <div class="received-check">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#4ade80" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
          <polyline points="22 4 12 14.01 9 11.01"/>
        </svg>
      </div>
      <h2 class="received-title">{credential.title}</h2>
      {#if credential.username}
        <p class="received-username">{credential.username}</p>
      {/if}
      <p class="received-copied">Password copied to clipboard!</p>
      <p class="received-countdown">Clears in {countdown}s</p>
      <div class="received-actions">
        {#if credential.username}
          <button class="action-btn" onclick={() => copyText(credential!.username, 'Username')}>
            {#if copiedField === 'Username'}
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#4ade80" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
            {:else}
              <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
            {/if}
            Copy username
          </button>
        {/if}
        <button class="action-btn" onclick={() => copyText(credential!.password, 'Password')}>
          {#if copiedField === 'Password'}
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#4ade80" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
          {:else}
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>
          {/if}
          Copy password
        </button>
      </div>
    </div>

  <!-- ============ SETTINGS VIEW ============ -->
  {:else if view === 'settings'}
    <div class="settings">
      <button class="back-btn" onclick={goToReady}>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>
        Back
      </button>
      <h3 class="section-title">Paired Devices</h3>
      {#if pairedDevices.length === 0}
        <div class="settings-card">
          <div class="sc-row">
            <span class="sc-about">No paired devices</span>
          </div>
        </div>
      {:else}
        {#each pairedDevices as device (device.device_id)}
          <div class="settings-card">
            <div class="sc-row">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#4ade80" stroke-width="2"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></svg>
              <div class="sc-info">
                <span class="sc-name">{device.device_name}</span>
                <span class="sc-status">Paired</span>
              </div>
              <button class="btn-remove" onclick={() => removeDevice(device.device_id)} title="Remove device">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
              </button>
            </div>
          </div>
        {/each}
      {/if}

      <button class="add-device-btn" onclick={goToQr}>
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
        Add new device
      </button>

      <h3 class="section-title">About</h3>
      <div class="settings-card">
        <div class="sc-row">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#666" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
          <span class="sc-about">WouPass Desktop v0.2.0</span>
        </div>
        <div class="sc-row">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#666" stroke-width="2"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
          <span class="sc-about">AES-256-GCM + X25519 ECDH</span>
        </div>
        <div class="sc-row">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#666" stroke-width="2"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
          <span class="sc-about">No data stored on desktop</span>
        </div>
      </div>
    </div>
  {/if}

  <!-- Footer -->
  <footer class="footer">
    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
    <span>Zero-knowledge · Push-only receiver</span>
  </footer>
</div>

<style>
  :global(*) { margin:0; padding:0; box-sizing:border-box; }
  :global(body) {
    font-family: 'Inter','Segoe UI',system-ui,-apple-system,sans-serif;
    font-size:13px; background:#0D0D0D; color:#EDEDED; overflow:hidden; user-select:none;
  }
  .app { height:100vh; display:flex; flex-direction:column; background:#171717; }

  /* Titlebar */
  .titlebar { display:flex; align-items:center; justify-content:space-between; height:38px; padding:0 4px 0 14px; background:#0D0D0D; flex-shrink:0; border-bottom:1px solid #2A2A2A; }
  .tb-left { display:flex; align-items:center; gap:8px; }
  .tb-title { color:#A1A1A1; font-size:12px; font-weight:600; letter-spacing:.3px; }
  .tb-right { display:flex; }
  .tb-btn { width:34px; height:30px; border:none; background:transparent; color:#666; cursor:pointer; display:flex; align-items:center; justify-content:center; border-radius:6px; transition:all .1s; }
  .tb-btn:hover { background:#1C1C1C; color:#EDEDED; }
  .tb-close:hover { background:#EF4444; color:#fff; }

  /* Toast */
  .toast { position:absolute; top:42px; left:10px; right:10px; padding:10px 14px; background:#1C1C1C; border:1px solid #3ECF8E33; border-radius:12px; display:flex; align-items:center; gap:8px; font-size:11px; color:#3ECF8E; z-index:100; animation:slideIn .2s ease; }
  .toast-info { border-color:#F59E0B33; color:#F59E0B; }
  @keyframes slideIn { from{opacity:0;transform:translateY(-8px)} to{opacity:1;transform:translateY(0)} }

  /* Footer */
  .footer { display:flex; align-items:center; justify-content:center; gap:6px; padding:8px; border-top:1px solid #2A2A2A; color:#666; font-size:10px; flex-shrink:0; }

  /* Back button */
  .back-btn { display:flex; align-items:center; gap:4px; border:none; background:transparent; color:#A1A1A1; cursor:pointer; font-size:12px; padding:10px 14px; font-family:inherit; border-radius:8px; }
  .back-btn:hover { color:#EDEDED; background:#1C1C1C; }

  /* ---- QR / Pairing ---- */
  .view-center { flex:1; display:flex; flex-direction:column; align-items:center; justify-content:center; padding:24px; }
  .qr-container { padding:16px; background:#1C1C1C; border:1px solid #2A2A2A; border-radius:12px; margin-bottom:20px; }
  .qr-image { display:block; width:200px; height:200px; image-rendering:pixelated; }
  .qr-error { color:#EF4444; font-size:12px; margin-bottom:16px; }
  .qr-placeholder { width:200px; height:200px; display:flex; align-items:center; justify-content:center; border:1px solid #2A2A2A; border-radius:12px; margin-bottom:20px; }
  .pair-desc { font-size:12px; color:#A1A1A1; text-align:center; margin-bottom:16px; }
  .pair-loading { display:flex; align-items:center; gap:8px; color:#666; font-size:11px; }
  .status-dot-pulse { width:8px; height:8px; border-radius:50%; background:#3ECF8E; animation:pulse-dot 1.5s ease-in-out infinite; }
  @keyframes pulse-dot { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.4;transform:scale(.8)} }
  .spinner { width:14px; height:14px; border:2px solid #2A2A2A; border-top-color:#3ECF8E; border-radius:50%; animation:spin .8s linear infinite; }
  @keyframes spin { to{transform:rotate(360deg)} }
  .link-btn { margin-top:20px; border:none; background:transparent; color:#3ECF8E; cursor:pointer; font-size:11px; font-family:inherit; text-decoration:underline; }
  .link-btn:hover { color:#5EDBA5; }

  /* ---- Ready View ---- */
  .ready-icon { margin-bottom:16px; opacity:.8; }
  .ready-title { font-size:20px; font-weight:600; color:#EDEDED; margin-bottom:6px; }
  .ready-desc { font-size:13px; color:#A1A1A1; margin-bottom:8px; }
  .ready-sub { font-size:11px; color:#666; }

  /* ---- Received View ---- */
  .received-view { gap:4px; }
  .received-check { margin-bottom:12px; animation:popIn .3s ease; }
  @keyframes popIn { from{transform:scale(0.5);opacity:0} to{transform:scale(1);opacity:1} }
  .received-title { font-size:18px; font-weight:600; color:#EDEDED; margin-bottom:2px; }
  .received-username { font-size:12px; color:#A1A1A1; margin-bottom:8px; }
  .received-copied { font-size:13px; color:#3ECF8E; font-weight:500; margin-bottom:4px; }
  .received-countdown { font-size:11px; color:#666; margin-bottom:16px; }
  .received-actions { display:flex; gap:8px; }
  .action-btn { display:flex; align-items:center; gap:6px; padding:8px 16px; border:1px solid #2A2A2A; background:#1C1C1C; color:#EDEDED; font-size:11px; cursor:pointer; font-family:inherit; border-radius:8px; transition:all .15s; }
  .action-btn:hover { background:#333; border-color:#3ECF8E; color:#fff; }

  /* ---- Settings ---- */
  .settings { flex:1; overflow-y:auto; padding-bottom:16px; }
  .section-title { font-size:10px; color:#666; text-transform:uppercase; letter-spacing:.8px; padding:12px 14px 6px; font-weight:600; }
  .settings-card { margin:0 10px 8px; background:#1C1C1C; border:1px solid #2A2A2A; border-radius:12px; overflow:hidden; }
  .sc-row { display:flex; align-items:center; gap:10px; padding:10px 12px; }
  .sc-info { display:flex; flex-direction:column; flex:1; }
  .sc-name { font-size:12px; font-weight:500; color:#EDEDED; }
  .sc-status { font-size:10px; color:#3ECF8E; }
  .sc-about { font-size:11px; color:#A1A1A1; }
  .btn-remove { width:28px; height:28px; border:1px solid #3a2020; background:#1C1C1C; color:#EF4444; cursor:pointer; display:flex; align-items:center; justify-content:center; flex-shrink:0; border-radius:6px; transition:all .1s; }
  .btn-remove:hover { background:#2a1515; border-color:#EF4444; }
  .add-device-btn { display:flex; align-items:center; justify-content:center; gap:8px; width:calc(100% - 20px); margin:12px 10px; padding:10px; background:#0D0D0D; border:1px solid #2A2A2A; color:#3ECF8E; font-size:12px; font-weight:500; cursor:pointer; font-family:inherit; border-radius:12px; transition:all .15s; }
  .add-device-btn:hover { border-color:#3ECF8E; background:#171717; }
</style>
