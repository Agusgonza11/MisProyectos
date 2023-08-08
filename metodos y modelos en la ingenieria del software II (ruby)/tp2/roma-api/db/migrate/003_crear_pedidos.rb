Sequel.migration do
  up do
    create_table(:pedidos) do
      primary_key :id
      String :nombre_menu
      String :usuario_telegram
      foreign_key [:usuario_telegram], :usuarios, on_delete: :cascade
    end
  end

  down do
    drop_table(:pedidos)
  end
end
