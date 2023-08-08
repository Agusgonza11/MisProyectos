Sequel.migration do
  up do
    add_column :job_offers, :applicant_count, Integer, default: 0
  end

  down do
    drop_column :job_offers, :applicant_count
  end
end
