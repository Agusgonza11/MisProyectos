use rayon::prelude::*;
use serde_json::json;
use std::collections::HashMap;

/// Calcula la distancia entre el asesino y la víctima basándose en las posiciones proporcionadas.
///
/// Argumentos:
/// record - Un vector de cadenas que contiene los datos de una línea del CSV.
///
/// Retorna:
/// Un Result que contiene la distancia calculada si el proceso es exitoso, o un error si alguna columna está vacía.
pub fn calculate_distance_weapon(record: Vec<&str>) -> Result<f64, String> {
    let is_empty = |s: &str| s.trim().is_empty();

    let killer_position_x = record
        .get(3)
        .ok_or_else(|| "Falta la posición X del asesino".to_string())?;
    let killer_position_y = record
        .get(4)
        .ok_or_else(|| "Falta la posición Y del asesino".to_string())?;
    let victim_position_x = record
        .get(10)
        .ok_or_else(|| "Falta la posición X de la víctima".to_string())?;
    let victim_position_y = record
        .get(11)
        .ok_or_else(|| "Falta la posición Y de la víctima".to_string())?;

    if is_empty(killer_position_x)
        || is_empty(killer_position_y)
        || is_empty(victim_position_x)
        || is_empty(victim_position_y)
    {
        return Err("Una de las columnas está vacía".to_string());
    }

    let killer_position_x: f64 = killer_position_x
        .parse()
        .map_err(|_| "Error al convertir killer_position_x".to_string())?;
    let killer_position_y: f64 = killer_position_y
        .parse()
        .map_err(|_| "Error al convertir killer_position_y".to_string())?;
    let victim_position_x: f64 = victim_position_x
        .parse()
        .map_err(|_| "Error al convertir victim_position_x".to_string())?;
    let victim_position_y: f64 = victim_position_y
        .parse()
        .map_err(|_| "Error al convertir victim_position_y".to_string())?;

    Ok(((killer_position_x - victim_position_x).powi(2)
        + (killer_position_y - victim_position_y).powi(2))
    .sqrt())
}

/// Procesa las estadísticas de las armas para calcular el porcentaje de muertes y la distancia promedio.
///
/// Argumentos:
/// all_weapons - Un HashMap que contiene estadísticas de las armas.
///
/// Retorna:
/// Un serde_json::Value que contiene un JSON con las estadísticas de armas procesadas.
fn process_weapons(all_weapons: HashMap<String, (f64, f64, f64)>) -> serde_json::Value {
    // Calcular el total de muertes
    let total_deaths: f64 = all_weapons.par_iter().map(|(_, (count, _, _))| count).sum();

    // Procesar las armas para calcular el porcentaje de muertes y la distancia promedio
    let top_weapons: HashMap<String, serde_json::Value> = all_weapons
        .into_par_iter()
        .map(|(weapon, (count, total_distance, count_empty))| {
            let deaths_percentage = if total_deaths > 0.0 {
                (((count / total_deaths) * 100.0) * 100.0).round() / 100.0
            } else {
                0.0
            };
            let average_distance = if count > 0.0 && count > count_empty {
                ((total_distance / (count - count_empty)) * 100.0).round() / 100.0
            } else {
                0.0
            };
            (
                weapon,
                json!({
                    "deaths_percentage": deaths_percentage,
                    "average_distance": average_distance
                }),
            )
        })
        .collect();

    // Ordeno las armas por el porcentaje de muertes en orden descendente
    let mut sorted_weapons: Vec<_> = top_weapons.into_par_iter().collect();
    sorted_weapons.par_sort_by(|a, b| {
        //Aca tuve que dejar el unwrap_or porque era lo que me pedia clippy
        let percentage_a = a.1["deaths_percentage"].as_f64().unwrap_or(0.0);
        let percentage_b = b.1["deaths_percentage"].as_f64().unwrap_or(0.0);
        match percentage_b.partial_cmp(&percentage_a) {
            Some(ordering) => ordering,
            None => std::cmp::Ordering::Equal,
        }
        .then_with(|| a.0.cmp(&b.0))
    });

    // Tomo las 10 armas principales
    let top_weapons = sorted_weapons
        .into_iter()
        .take(10)
        .collect::<HashMap<_, _>>();
    json!(top_weapons)
}

/// Procesa las estadísticas de los asesinos para calcular el número de muertes y el porcentaje de uso de armas.
/// Argumentos:
/// all_killers - Un HashMap que contiene estadísticas de los asesinos.
///
/// Retorna:
/// Un serde_json::Value que contiene un JSON con las estadísticas de los asesinos procesadas.
fn process_killers(
    all_killers: HashMap<String, (usize, HashMap<String, usize>)>,
) -> serde_json::Value {
    let (deaths_count, weapons_count): (
        HashMap<String, usize>,
        HashMap<String, HashMap<String, usize>>,
    ) = all_killers
        .into_par_iter()
        .fold(
            || (HashMap::new(), HashMap::new()),
            |(mut deaths_count, mut weapons_count), (killer_name, (count, weapon_counts))| {
                *deaths_count.entry(killer_name.clone()).or_insert(0) += count;
                let weapons_for_killer = weapons_count
                    .entry(killer_name)
                    .or_insert_with(HashMap::new);
                for (weapon, count) in weapon_counts {
                    *weapons_for_killer.entry(weapon).or_insert(0) += count;
                }
                (deaths_count, weapons_count)
            },
        )
        .reduce(
            || (HashMap::new(), HashMap::new()),
            |(mut acc_deaths, mut acc_weapons), (deaths_count, weapons_count)| {
                for (killer, count) in deaths_count {
                    *acc_deaths.entry(killer.clone()).or_insert(0) += count;
                }
                for (killer, weapons) in weapons_count {
                    let entry = acc_weapons
                        .entry(killer.clone())
                        .or_insert_with(HashMap::new);
                    for (weapon, count) in weapons {
                        *entry.entry(weapon.clone()).or_insert(0) += count;
                    }
                }
                (acc_deaths, acc_weapons)
            },
        );

    let mut players: Vec<(String, usize)> = deaths_count.into_par_iter().collect();
    players.par_sort_by(|a, b| b.1.cmp(&a.1).then_with(|| a.0.cmp(&b.0)));

    let top_10_players = players.into_iter().take(10);

    let mut result = HashMap::new();

    for (killer_name, total_deaths) in top_10_players {
        let weapons_for_killer = match weapons_count.get(&killer_name) {
            Some(weapons) => weapons.clone(),
            None => HashMap::new(),
        };
        let mut weapons_vec: Vec<(String, usize)> = weapons_for_killer.into_par_iter().collect();
        weapons_vec.par_sort_by(|a, b| b.1.cmp(&a.1).then_with(|| a.0.cmp(&b.0)));

        let top_3_weapons = weapons_vec.into_iter().take(3).collect::<Vec<_>>();
        let mut weapon_percentage = HashMap::new();

        for (weapon, count) in top_3_weapons {
            let percentage = (count as f64 / total_deaths as f64) * 100.0;
            weapon_percentage.insert(weapon, (percentage * 100.0).round() / 100.0);
        }

        result.insert(
            killer_name,
            json!({
                "deaths": total_deaths,
                "weapons_percentage": weapon_percentage
            }),
        );
    }

    serde_json::Value::Object(result.into_iter().collect())
}

/// Procesa las estadísticas de los asesinos para calcular el número de muertes y el porcentaje de uso de armas.
///
/// Argumentos:
/// all_killers - Un HashMap que contiene estadísticas de los asesinos.
/// all_weapons - Un HashMap que contiene estadísticas de las armas.
///
/// Retorna:
/// Un serde_json::Value que contiene un JSON con las estadísticas procesadas.
pub fn process_deaths(
    all_killers: HashMap<String, (usize, HashMap<String, usize>)>,
    all_weapons: HashMap<String, (f64, f64, f64)>,
) -> (serde_json::Value, serde_json::Value) {
    let killers_result = process_killers(all_killers);
    let weapons_result = process_weapons(all_weapons);

    (killers_result, weapons_result)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::HashMap;

    #[test]
    fn test_calculate_distance_weapon_valid() {
        let record = vec!["", "", "", "0.0", "0.0", "", "", "", "", "", "3.0", "4.0"];
        let result = calculate_distance_weapon(record);
        assert_eq!(result.unwrap(), 5.0);
    }

    #[test]
    fn test_process_weapons_valid() {
        let mut all_weapons = HashMap::new();
        all_weapons.insert("weapon1".to_string(), (100.0, 500.0, 10.0));
        all_weapons.insert("weapon2".to_string(), (50.0, 200.0, 5.0));

        let result = process_weapons(all_weapons);

        let weapon1 = result.get("weapon1").unwrap();
        let weapon2 = result.get("weapon2").unwrap();

        assert_eq!(weapon1["deaths_percentage"].as_f64().unwrap(), 66.67);
        assert_eq!(weapon1["average_distance"].as_f64().unwrap(), 5.56);
        assert_eq!(weapon2["deaths_percentage"].as_f64().unwrap(), 33.33);
        assert_eq!(weapon2["average_distance"].as_f64().unwrap(), 4.44);
    }

    #[test]
    fn test_process_weapons_empty() {
        let all_weapons: HashMap<String, (f64, f64, f64)> = HashMap::new();
        let result = process_weapons(all_weapons);
        assert!(result.as_object().unwrap().is_empty());
    }

    #[test]
    fn test_process_killers_valid() {
        let mut all_killers = HashMap::new();
        let mut weapon_counts = HashMap::new();
        weapon_counts.insert("weapon1".to_string(), 50);
        weapon_counts.insert("weapon2".to_string(), 25);
        all_killers.insert("killer1".to_string(), (75, weapon_counts));

        let result = process_killers(all_killers);

        let killer1 = result.get("killer1").unwrap();
        assert_eq!(killer1["deaths"].as_u64().unwrap(), 75);
        assert_eq!(
            killer1["weapons_percentage"]["weapon1"].as_f64().unwrap(),
            66.67
        );
        assert_eq!(
            killer1["weapons_percentage"]["weapon2"].as_f64().unwrap(),
            33.33
        );
    }

    #[test]
    fn test_process_killers_empty() {
        let all_killers: HashMap<String, (usize, HashMap<String, usize>)> = HashMap::new();
        let result = process_killers(all_killers);
        assert!(result.as_object().unwrap().is_empty());
    }

    #[test]
    fn test_process_deaths_valid() {
        let mut all_killers = HashMap::new();
        let mut weapon_counts = HashMap::new();
        weapon_counts.insert("weapon1".to_string(), 50);
        all_killers.insert("killer1".to_string(), (50, weapon_counts));

        let mut all_weapons = HashMap::new();
        all_weapons.insert("weapon1".to_string(), (50.0, 100.0, 0.0));

        let (killers_result, weapons_result) = process_deaths(all_killers, all_weapons);

        assert!(!killers_result.as_object().unwrap().is_empty());
        assert!(!weapons_result.as_object().unwrap().is_empty());
    }

    #[test]
    fn test_process_deaths_empty() {
        let all_killers: HashMap<String, (usize, HashMap<String, usize>)> = HashMap::new();
        let all_weapons: HashMap<String, (f64, f64, f64)> = HashMap::new();

        let (killers_result, weapons_result) = process_deaths(all_killers, all_weapons);

        assert!(killers_result.as_object().unwrap().is_empty());
        assert!(weapons_result.as_object().unwrap().is_empty());
    }
}
