# WouPass

A zero-knowledge password manager where your phone is the vault and your desktop is just a receiver.

No cloud. No servers. No data stored on desktop. Your passwords never leave your phone until you decide to send them.

---

## How it works

WouPass flips the password manager model: instead of syncing your vault everywhere, your phone holds everything and pushes credentials to your desktop only when you need them.

1. **Pair once** -- Open the desktop app, scan the QR code from your phone. Done.
2. **Send on demand** -- Select a password on your phone, tap "Send to", choose your desktop. The credential arrives encrypted and gets copied to your clipboard.
3. **Auto-fill** -- Click the browser extension icon to fill the login form. Clipboard clears automatically after 30 seconds.

The desktop app never stores passwords. It receives them, puts them in your clipboard, and forgets them.

---

## Architecture

```
Phone (Flutter)              Desktop (Tauri)           Browser Extension
+------------------+         +----------------+        +----------------+
|                  |  WiFi   |                |  Clip-  |                |
|  Encrypted vault | ------> |  TCP receiver  | board   |  Auto-fill     |
|  AES-256-GCM     | push    |  System tray   | ------> |  Login forms   |
|  Argon2id keys   | only    |  Zero storage  |         |  Zero storage  |
|                  |         |                |         |                |
+------------------+         +----------------+        +----------------+
     Source of truth            Ephemeral only            Reads clipboard
```

**Push-only model**: The phone connects to the desktop for a few seconds, sends the credential encrypted, and disconnects. No persistent connections, no heartbeats, no battery drain.

**Multiple devices**: Pair as many desktops as you want. Send specific passwords to specific devices. Each device only sees what you choose to send.

---

## Security

### Encryption
- **Vault encryption**: AES-256-GCM with per-field encryption. Each field (title, username, password, URL, notes) is encrypted individually with its own random nonce.
- **Key derivation**: Argon2id (64MB memory, 3 iterations, 4 parallelism) derives a 256-bit key from your master password.
- **Master password**: Never stored. Only a verification hash (encrypted constant) is kept to check correctness.

### Device communication
- **Pairing**: X25519 ECDH key exchange verified by physical QR code scan. No codes to type, no servers involved.
- **Reconnect**: Pre-shared key (derived during pairing) encrypts the ECDH exchange. Even the key negotiation is encrypted.
- **Credential transfer**: AES-256-GCM with ephemeral session key. New key exchange for every send (forward secrecy).
- **Nothing in plaintext**: Only the device UUID (not sensitive) travels unencrypted. All keys, credentials, and metadata are encrypted.

### Zero-knowledge guarantees
- The desktop never stores passwords to disk. Credentials exist only in clipboard memory for 30 seconds.
- The phone decides what to send and to whom. The desktop cannot request or browse your vault.
- No cloud, no servers, no accounts. Everything is local and peer-to-peer over your WiFi network.
- The browser extension reads the clipboard, fills the form, and clears it. No data persists.

---

## Components

### Mobile app (Flutter)
The vault. Stores all your encrypted passwords, categories, and TOTP 2FA codes.

- AES-256-GCM encryption with Argon2id key derivation
- Master password + biometric unlock + auto-lock
- Password CRUD with categories and search
- TOTP 2FA authenticator (SHA1/SHA256/SHA512)
- Password generator (cryptographically secure)
- Encrypted vault export/import (.vault files)
- QR code sharing for individual entries
- Push credentials to paired desktops
- Device management (pair, unpair, send to specific device)

### Desktop app (Tauri + Rust)
The receiver. A compact system tray widget that accepts credentials from your phone.

- TCP server with X25519 ECDH + AES-256-GCM encryption
- QR code pairing (one-time setup per device)
- Receives credentials and copies to clipboard with auto-clear
- System tray integration (minimize to tray, click to show)
- Multiple paired phones supported
- No database, no cache, no password storage

### Browser extension (Chrome)
The auto-filler. Reads the clipboard and fills login forms.

- Detects username and password fields on any page
- One-click fill from clipboard
- Clears clipboard after filling
- No data storage, no network requests

---

## Building from source

### Mobile (Flutter)

```
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build apk --debug
```

Requirements: Flutter 3.29+, Android SDK 35+, Dart 3.7+

### Desktop (Tauri)

```
cd apps/desktop
npm install
cargo tauri dev
```

Requirements: Rust 1.70+, Node.js 18+, Tauri CLI v2

### Browser extension

```
1. Open chrome://extensions
2. Enable Developer mode
3. Click "Load unpacked"
4. Select the apps/extension folder
```

---

## Project structure

```
woupass/
  apps/
    mobile/          Flutter app (Android/iOS)
    desktop/         Tauri app (Windows/macOS/Linux)
    extension/       Chrome extension (Manifest V3)
  docs/
    architecture.md  System architecture
    security.md      Security model details
    protocol.md      Communication protocol spec
```

---

## Protocol

The communication between phone and desktop uses a custom protocol over TCP:

**Pairing** (one-time, requires physical QR scan):
```
Phone -> Desktop: PAIR_REQUEST {phoneName, publicKey}
Desktop -> Phone: PAIR_RESPONSE {accepted, desktopName, publicKey}
  Both derive session key via ECDH
Phone -> Desktop: PAIR_CONFIRM {hmac} (encrypted)
Desktop -> Phone: PAIR_CONFIRMED {hmac} (encrypted)
  Both save pairing secret for future reconnects
```

**Sending a credential** (ephemeral connection):
```
Phone -> Desktop: RECONNECT {deviceId} (plaintext, just UUID)
  Desktop sets pre-shared key from pairing
Phone -> Desktop: RECONNECT_AUTH {publicKey} (PSK encrypted)
Desktop -> Phone: RECONNECT_OK {publicKey} (PSK encrypted)
  Both derive ephemeral session key via ECDH
Phone -> Desktop: PUSH_CREDENTIAL {title, username, password, uri} (encrypted)
  Desktop copies to clipboard, connection closes
```

Every credential send uses a fresh ECDH key exchange, providing forward secrecy.

---

## License

GPLv3. See [LICENSE](LICENSE) for details.
