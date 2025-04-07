Sequel.migration do
  up do
    create_table(:contenido) do
      primary_key :id
      String :tipo
      String :autor
      String :titulo
      String :duracion
      Date :fecha_lanzamiento
      Date :created_on
      Date :updated_on
    end
  end

  down do
    drop_table(:contenido)
  end
end
