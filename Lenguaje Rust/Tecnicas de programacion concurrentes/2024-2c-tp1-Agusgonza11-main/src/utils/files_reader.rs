use crate::utils::death_calculator::calculate_distance_weapon;
use crate::utils::death_calculator::process_deaths;
use rayon::prelude::*;
use rayon::ThreadPoolBuilder;
use serde_json::json;
use std::collections::HashMap;
use std::fs;
use std::io::{self, BufRead};
use std::path::PathBuf;

const PADRON: i32 = 106086;
type WeaponsHash = HashMap<String, (f64, f64, f64)>;
type KillersHash = HashMap<String, (usize, HashMap<String, usize>)>;

/// Estructura para leer y procesar archivos.
pub struct FilesReader {
    input_path: String,
    threads: usize,
}

impl FilesReader {
    /// Crea un nuevo `FilesReader` con la ruta de entrada y el número de hilos especificados.
    ///
    /// Argumentos:
    /// input_path - Una cadena que contiene la ruta al directorio de entrada que contiene los archivos CSV.
    /// threads - El número de hilos a utilizar.
    ///
    /// Retorna:
    /// Estructura FilesReader.
    pub fn new(input_path: &str, threads: usize) -> Self {
        Self {
            input_path: input_path.to_string(),
            threads,
        }
    }

    /// Procesa los archivos CSV en el directorio de entrada y genera un JSON con las estadísticas.
    ///
    /// Retorna:
    /// Un `Result` que contiene un `String` con el JSON formateado si el procesamiento es exitoso,
    /// o un error de entrada/salida si ocurre algún problema.
    pub fn process(&self) -> io::Result<String> {
        // Creo un ThreadPool con el número de threads pedido
        ThreadPoolBuilder::new()
            .num_threads(self.threads)
            .build_global()
            .expect("Failed to create thread pool");

        let entries = fs::read_dir(&self.input_path)?;
        let csv_paths: Vec<PathBuf> = entries
            .filter_map(Result::ok)
            .map(|entry| entry.path())
            .filter(|path| {
                path.is_file() && path.extension().and_then(|ext| ext.to_str()) == Some("csv")
            })
            .collect();

        let (all_killers, all_weapons): (KillersHash, WeaponsHash) = csv_paths
            .par_iter()
            .map(|path| {
                let mut local_killers: KillersHash = HashMap::new();
                let mut local_weapons: WeaponsHash = HashMap::new();

                let file = match fs::File::open(path) {
                    Ok(f) => f,
                    Err(_) => return (HashMap::new(), HashMap::new()),
                };
                let reader = io::BufReader::new(file);

                for line in reader.lines().skip(1) {
                    match line {
                        Ok(record) => {
                            let record_parts: Vec<&str> = record.split(',').collect();
                            if record_parts.len() < 12 {
                                continue;
                            }

                            let killer_name = record_parts[1].to_string();
                            let weapon_name = record_parts[0].to_string();

                            let distance = calculate_distance_weapon(record_parts);

                            // Actualizo estadisticas locales de weapons
                            let entry = local_weapons
                                .entry(weapon_name.clone())
                                .or_insert((0.0, 0.0, 0.0));
                            entry.0 += 1.0;
                            if let Ok(d) = distance {
                                entry.1 += d;
                            } else {
                                entry.2 += 1.0;
                            }

                            if killer_name.is_empty() {
                                continue;
                            }

                            // Actualizo estadisticas locales de killers
                            let (deaths_count, weapon_counts) = local_killers
                                .entry(killer_name.clone())
                                .or_insert((0, HashMap::new()));
                            *deaths_count += 1;
                            *weapon_counts.entry(weapon_name).or_insert(0) += 1;
                        }
                        Err(_) => continue,
                    }
                }

                (local_killers, local_weapons)
            })
            .reduce(
                || (HashMap::new(), HashMap::new()),
                |(mut acc_killers, mut acc_weapons), (local_killers, local_weapons)| {
                    for (killer_name, (deaths_count, weapon_counts)) in local_killers {
                        let (total_deaths, acc_weapon_counts) = acc_killers
                            .entry(killer_name.clone())
                            .or_insert((0, HashMap::new()));
                        *total_deaths += deaths_count;
                        let acc_weapon_counts = acc_weapon_counts;
                        for (weapon_name, count) in weapon_counts {
                            *acc_weapon_counts.entry(weapon_name).or_insert(0) += count;
                        }
                    }
                    for (weapon_name, (count, distance, count_empty)) in local_weapons {
                        let entry = acc_weapons.entry(weapon_name).or_insert((0.0, 0.0, 0.0));
                        entry.0 += count;
                        entry.1 += distance;
                        entry.2 += count_empty;
                    }
                    (acc_killers, acc_weapons)
                },
            );

        let (top_killers, top_weapons) = process_deaths(all_killers, all_weapons);

        let output = json!({
            "padron": PADRON,
            "top_killers": top_killers,
            "top_weapons": top_weapons,
        });

        Ok(serde_json::to_string_pretty(&output)?)
    }
}
