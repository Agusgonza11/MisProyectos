Sequel.migration do
  up do
    add_column :users, :preferences, String
  end

  down do
    drop_column :users, :preferences
  end
end
