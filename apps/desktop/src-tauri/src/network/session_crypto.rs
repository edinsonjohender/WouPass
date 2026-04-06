use aes_gcm::{
    aead::{Aead, KeyInit, OsRng},
    Aes256Gcm, Nonce,
};
use base64::{engine::general_purpose::STANDARD as BASE64, Engine};
use hkdf::Hkdf;
use hmac::{Hmac, Mac};
use rand::RngCore;
use sha2::Sha256;
use x25519_dalek::{EphemeralSecret, PublicKey};

type HmacSha256 = Hmac<Sha256>;

pub struct SessionCrypto {
    secret: Option<EphemeralSecret>,
    public_key: Option<PublicKey>,
    session_key: Option<[u8; 32]>,
    nonce_prefix: [u8; 4],
    send_seq: i64,
    last_received_seq: i64,
}

impl SessionCrypto {
    pub fn new() -> Self {
        let mut nonce_prefix = [0u8; 4];
        OsRng.fill_bytes(&mut nonce_prefix);

        Self {
            secret: None,
            public_key: None,
            session_key: None,
            nonce_prefix,
            send_seq: 0,
            last_received_seq: -1,
        }
    }

    /// Generate ephemeral X25519 keypair, returns public key bytes
    pub fn generate_keypair(&mut self) -> [u8; 32] {
        let secret = EphemeralSecret::random_from_rng(OsRng);
        let public = PublicKey::from(&secret);
        let pub_bytes = public.to_bytes();
        self.secret = Some(secret);
        self.public_key = Some(public);
        pub_bytes
    }

    /// Derive session key from ECDH + pairing code
    pub fn derive_session_key(
        &mut self,
        remote_public_bytes: &[u8; 32],
        pairing_code: &str,
    ) -> Result<(), String> {
        let secret = self.secret.take().ok_or("No keypair generated")?;
        let remote_public = PublicKey::from(*remote_public_bytes);
        let shared_secret = secret.diffie_hellman(&remote_public);

        // salt = SHA256("woupass" || code)
        use sha2::Digest;
        let mut hasher = sha2::Sha256::new();
        hasher.update(format!("woupass{}", pairing_code).as_bytes());
        let salt = hasher.finalize();

        // HKDF
        let hk = Hkdf::<Sha256>::new(Some(&salt), shared_secret.as_bytes());
        let mut key = [0u8; 32];
        hk.expand(b"woupass-session-v1", &mut key)
            .map_err(|e| format!("HKDF error: {}", e))?;

        self.session_key = Some(key);
        self.send_seq = 0;
        self.last_received_seq = -1;

        // Derive nonce prefix from session key so both sides have the same one
        let mut prefix_data = Vec::with_capacity(64);
        prefix_data.extend_from_slice(&key);
        prefix_data.extend_from_slice(b"nonce-prefix");
        let hash = <Sha256 as sha2::Digest>::digest(&prefix_data);
        self.nonce_prefix.copy_from_slice(&hash[..4]);

        Ok(())
    }

    /// Create HMAC-SHA256 for pairing verification
    pub fn create_verification(&self, label: &str) -> Result<String, String> {
        let key = self.session_key.ok_or("Session key not derived")?;
        let mut mac = <HmacSha256 as Mac>::new_from_slice(&key)
            .map_err(|e| format!("HMAC error: {}", e))?;
        mac.update(label.as_bytes());
        let result = mac.finalize();
        Ok(BASE64.encode(result.into_bytes()))
    }

    /// Verify HMAC from remote side
    pub fn verify_hmac(&self, label: &str, received: &str) -> Result<bool, String> {
        let expected = self.create_verification(label)?;
        Ok(expected == received)
    }

    /// Encrypt a message string
    pub fn encrypt_message(&mut self, plaintext: &str) -> Result<String, String> {
        let key = self.session_key.ok_or("Session not established")?;
        let seq = self.send_seq;
        self.send_seq += 1;

        // nonce = seq (8 bytes BE) + prefix (4 bytes) = 12 bytes
        let mut nonce_bytes = [0u8; 12];
        nonce_bytes[..8].copy_from_slice(&seq.to_be_bytes());
        nonce_bytes[8..12].copy_from_slice(&self.nonce_prefix);
        let nonce = Nonce::from_slice(&nonce_bytes);

        let cipher = Aes256Gcm::new_from_slice(&key).map_err(|e| format!("AES error: {}", e))?;
        let ciphertext = cipher
            .encrypt(nonce, plaintext.as_bytes())
            .map_err(|e| format!("Encrypt error: {}", e))?;

        // seq (8 bytes) + ciphertext (includes appended tag)
        let mut result = Vec::with_capacity(8 + ciphertext.len());
        result.extend_from_slice(&seq.to_be_bytes());
        result.extend_from_slice(&ciphertext);

        Ok(BASE64.encode(&result))
    }

    /// Decrypt a message string
    pub fn decrypt_message(&mut self, encrypted: &str) -> Result<String, String> {
        let key = self.session_key.ok_or("Session not established")?;
        let data = BASE64
            .decode(encrypted)
            .map_err(|e| format!("Base64 error: {}", e))?;

        if data.len() < 24 {
            return Err("Data too short".into());
        }

        let seq = i64::from_be_bytes(data[..8].try_into().unwrap());

        // Replay protection
        if seq <= self.last_received_seq {
            return Err("Replay detected".into());
        }
        self.last_received_seq = seq;

        // Reconstruct nonce
        let mut nonce_bytes = [0u8; 12];
        nonce_bytes[..8].copy_from_slice(&data[..8]);
        nonce_bytes[8..12].copy_from_slice(&self.nonce_prefix);
        let nonce = Nonce::from_slice(&nonce_bytes);

        let cipher = Aes256Gcm::new_from_slice(&key).map_err(|e| format!("AES error: {}", e))?;
        let plaintext = cipher
            .decrypt(nonce, &data[8..])
            .map_err(|_| "Decryption failed (wrong key or tampered)".to_string())?;

        String::from_utf8(plaintext).map_err(|e| format!("UTF-8 error: {}", e))
    }

    /// Set a pre-shared key derived from a pairing secret.
    /// Used to encrypt the ECDH key exchange during reconnect.
    pub fn set_pre_shared_key(&mut self, secret: &str) {
        use sha2::Digest as _;
        let hash = Sha256::digest(secret.as_bytes());
        let mut key = [0u8; 32];
        key.copy_from_slice(&hash);
        self.session_key = Some(key);

        // Derive nonce prefix same way as normal session key derivation
        let mut prefix_data = Vec::with_capacity(64);
        prefix_data.extend_from_slice(&key);
        prefix_data.extend_from_slice(b"nonce-prefix");
        let prefix_hash = Sha256::digest(&prefix_data);
        self.nonce_prefix.copy_from_slice(&prefix_hash[..4]);

        self.send_seq = 0;
        self.last_received_seq = -1;
    }

    pub fn is_established(&self) -> bool {
        self.session_key.is_some()
    }
}
