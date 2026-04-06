use serde::{Deserialize, Serialize};

pub const PORT: u16 = 9847;

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq)]
#[serde(rename_all = "camelCase")]
pub enum MessageType {
    PairRequest,
    PairResponse,
    PairConfirm,
    PairConfirmed,
    PushCredential,
    Reconnect,
    ReconnectAuth,
    ReconnectOk,
    Error,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ProtocolMessage {
    #[serde(rename = "type")]
    pub msg_type: MessageType,
    pub id: String,
    pub seq: i64,
    pub timestamp: i64,
    pub payload: serde_json::Value,
}

impl ProtocolMessage {
    pub fn new(msg_type: MessageType, seq: i64, payload: serde_json::Value) -> Self {
        Self {
            msg_type,
            id: uuid::Uuid::new_v4().to_string(),
            seq,
            timestamp: chrono_timestamp(),
            payload,
        }
    }

    pub fn to_bytes(&self) -> Vec<u8> {
        let json = serde_json::to_string(self).unwrap();
        let payload = json.as_bytes();
        let len = payload.len() as u32;
        let mut buf = Vec::with_capacity(4 + payload.len());
        buf.extend_from_slice(&len.to_be_bytes());
        buf.extend_from_slice(payload);
        buf
    }

    pub fn to_json_string(&self) -> String {
        serde_json::to_string(self).unwrap()
    }

    pub fn from_json(json_str: &str) -> Result<Self, serde_json::Error> {
        serde_json::from_str(json_str)
    }
}

fn chrono_timestamp() -> i64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_millis() as i64
}
