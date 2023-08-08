Sequel.migration do
  up do
    add_column :users, :failed_attempts, Integer, default: 0
  end

  down do
    drop_column :users, :failed_attempts
  end
end
