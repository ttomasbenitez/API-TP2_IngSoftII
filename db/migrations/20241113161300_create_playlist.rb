Sequel.migration do
  up do
    create_table(:playlist) do
      primary_key :id
      String :id_usuario
      Integer :id_contenido
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:playlist)
  end
end
