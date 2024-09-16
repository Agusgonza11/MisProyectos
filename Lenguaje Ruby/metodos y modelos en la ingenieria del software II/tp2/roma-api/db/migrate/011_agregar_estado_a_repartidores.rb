Sequel.migration do
  up do
    add_column :repartidores, :estado, String
  end

  down do
    drop_column :repartidores, :estado
  end
end
