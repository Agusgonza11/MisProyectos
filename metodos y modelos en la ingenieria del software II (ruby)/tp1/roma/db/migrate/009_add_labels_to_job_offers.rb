Sequel.migration do
  up do
    add_column :job_offers, :labels, String
  end

  down do
    drop_column :job_offers, :labels
  end
end
