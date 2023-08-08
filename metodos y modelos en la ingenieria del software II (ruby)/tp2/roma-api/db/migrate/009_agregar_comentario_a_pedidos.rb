Sequel.migration do
  up do
    add_column :pedidos, :comentario, String
  end

  down do
    drop_column :pedidos, :comentario
  end
end
