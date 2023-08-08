Sequel.migration do
  up do
    create_table(:usuarios) do
      String :usuario_telegram
      String :nombre
      String :direccion
      String :telefono
      primary_key [:usuario_telegram]
    end
  end

  down do
    drop_table(:usuarios)
  end
end
