use serde::Deserialize;
use std::fs;
use std::path::Path;

#[derive(Deserialize)]
pub struct Config {
    pub start: (u64, u64),
    pub end: (u64, u64),
    pub payment: u64,
}

impl Config {
    pub fn load_default() -> Result<Self, Box<dyn std::error::Error>> {
        let path = Path::new("config.json");
        let config_content = fs::read_to_string(path)?;
        let config: Config = serde_json::from_str(&config_content)?;
        Ok(config)
    }
}