Sequel.migration do
  up do
    alter_table(:reproducciones) do
      set_column_type :id_usuario, String
    end
  end

  down do
    alter_table(:reproducciones) do
      set_column_type :id_usuario, Integer
    end
  end
end
