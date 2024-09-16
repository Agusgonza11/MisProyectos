Sequel.migration do
  up do
    create_table(:repartidores) do
      primary_key :id
      String :nombre_usuario, unique: true
      String :nombre
    end
  end

  down do
    drop_table(:repartidores)
  end
end
