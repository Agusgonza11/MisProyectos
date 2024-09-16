Sequel.migration do
  up do
    add_column :users, :subscription, String
  end

  down do
    drop_column :users, :subscription
  end
end
