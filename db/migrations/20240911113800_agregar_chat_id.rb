Sequel.migration do
  up do
    add_column :usuarios, :chat_id, String
  end

  down do
    drop_column :usuarios, :chat_id, String
  end
end
