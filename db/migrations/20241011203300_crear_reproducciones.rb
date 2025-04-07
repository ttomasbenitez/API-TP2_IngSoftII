Sequel.migration do
  up do
    create_table(:reproducciones) do
      primary_key :id
      Integer :id_usuario
      Integer :id_contenido
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:reproducciones)
  end
end
