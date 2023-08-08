Sequel.migration do
  up do
    add_column :pedidos, :clima, String
  end

  down do
    drop_column :pedidos, :clima
  end
end
