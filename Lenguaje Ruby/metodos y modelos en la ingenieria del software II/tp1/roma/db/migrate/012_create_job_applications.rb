Sequel.migration do
  up do
    create_table(:job_applications) do
      primary_key %i[job_offer_id email]
      Integer :job_offer_id
      String :email
    end
  end

  down do
    drop_table(:job_applications)
  end
end
