mod utils;
use std::env;
use std::fs::File;
use std::io::{self, Write};
use utils::files_reader::FilesReader;

fn read_args() -> Result<(String, usize, String), &'static str> {
    let args: Vec<String> = env::args().collect();
    if args.len() != 4 {
        return Err(
            "La ejecución correcta es: cargo run <input-path> <num-threads> <output-file-name>",
        );
    }

    let input_path = args[1].clone();
    let num_threads = match args[2].parse::<usize>() {
        Ok(n) => n,
        Err(_) => return Err("El segundo argumento debe ser un numero valido."),
    };
    let output_file_name = args[3].clone();

    Ok((input_path, num_threads, output_file_name))
}

fn process_files(input_path: &str, num_threads: usize) -> io::Result<String> {
    let reader = FilesReader::new(input_path, num_threads);
    reader.process()
}

fn main() {
    match read_args() {
        Ok((input_path, num_threads, output_file_name)) => {
            match process_files(&input_path, num_threads) {
                Ok(processed_content) => {
                    if let Err(e) = File::create(output_file_name)
                        .and_then(|mut file| file.write_all(processed_content.as_bytes()))
                    {
                        eprintln!("Error al escribir en el archivo: {}", e);
                    }
                }
                Err(e) => {
                    eprintln!("Error al procesar la entrada: {}", e);
                }
            }
        }
        Err(e) => {
            eprintln!("{}", e);
        }
    }
}
