Sequel.migration do
  up do
    add_column :pedidos, :precio, Float
  end

  down do
    drop_column :pedidos, :precio
  end
end
