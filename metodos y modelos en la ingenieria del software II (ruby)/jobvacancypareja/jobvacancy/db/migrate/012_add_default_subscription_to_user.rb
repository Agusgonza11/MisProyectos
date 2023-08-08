Sequel.migration do
  up do
    alter_table(:users) do
      set_column_default :subscription, 'on-demand'
    end
  end

  down do
    alter_table(:users) do
      set_column_default :subscription, nil
    end
  end
end
