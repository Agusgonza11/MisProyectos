use libclient::DbConnection;
use std::net::SocketAddr;
use std::collections::HashMap;

fn invalid_usage() {
    eprintln!("Incorrect usage. Correct usage: cargo run (path/to/config.json) (get/set/del) (key) [value]");
    std::process::exit(1);
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error + Send + Sync>> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        invalid_usage();
    }

    let config_file = std::fs::read_to_string(&args[1]).expect("Config file not found");
    let config: HashMap<u64, SocketAddr> = serde_json::from_str(&config_file)?;
    let mut dbc = DbConnection::new(config).await?;
    match args[2].as_str() {
        "get" => {
            let val = dbc.get_key(&args[3]).await?;
            println!("{}", val.unwrap_or("".to_owned()));
        },
        "set" => {
            dbc.set_key(&args[3], &args[4]).await?;
        },
        "del" => {
            dbc.del_key(&args[3]).await?;
        },
        _ => invalid_usage()
    };
    Ok(())
}
