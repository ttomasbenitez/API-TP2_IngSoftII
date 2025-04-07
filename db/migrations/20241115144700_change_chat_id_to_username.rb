Sequel.migration do
  up do
    alter_table(:usuarios) do
      rename_column :chat_id, :username
    end
  end

  down do
    alter_table(:usuarios) do
      rename_column :username, :chat_id
    end
  end
end
