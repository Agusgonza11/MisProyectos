Sequel.migration do
  up do
    drop_column :job_offers, :applicant_count
  end

  down do
    add_column :job_offers, :applicant_count, Integer, default: 0
  end
end
