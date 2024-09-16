Sequel.migration do
  up do
    add_column :job_offers, :experience_required, Integer, default: 0
  end

  down do
    drop_column :job_offers, :experience_required
  end
end
