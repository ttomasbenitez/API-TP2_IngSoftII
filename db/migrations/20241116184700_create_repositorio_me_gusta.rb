Sequel.migration do
  up do
    create_table(:me_gusta) do
      primary_key :id
      String :id_usuario
      Integer :id_contenido
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:me_gusta)
  end
end
