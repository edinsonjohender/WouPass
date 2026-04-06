# Security Policy

## Reporting a vulnerability

If you find a security vulnerability in WouPass, please report it responsibly.

**Do not open a public GitHub issue for security vulnerabilities.**

Instead, contact via GitHub: https://github.com/edinsonjohender

Include:
- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

You will receive a response within 48 hours. Critical vulnerabilities will be patched and released as soon as possible.

## Scope

The following are in scope:
- Encryption implementation (AES-256-GCM, Argon2id, X25519 ECDH)
- Protocol vulnerabilities (pairing, reconnect, credential transfer)
- Data leaks (passwords persisting on desktop, clipboard not clearing)
- Authentication bypass (master password, biometric)

The following are out of scope:
- Denial of service on the TCP server
- Social engineering attacks
- Physical access to an unlocked phone
