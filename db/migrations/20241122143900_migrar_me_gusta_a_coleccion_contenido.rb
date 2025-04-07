Sequel.migration do
  up do
    from(:me_gusta).each do |row|
      from(:coleccion_contenidos).insert(
        id_usuario: row[:id_usuario], id_contenido: row[:id_contenido], created_on: row[:created_on],
        updated_on: row[:updated_on],
        nombre: 'favoritos'
      )
    end

    drop_table(:me_gusta)
  end

  down do
    create_table(:me_gusta) do
      primary_key :id
      String :id_usuario
      Integer :id_contenido
      Date :created_on
      Date :updated_on
    end

    from(:coleccion_contenidos).where(nombre: 'favoritos').each do |row|
      from(:me_gusta).insert(
        id_usuario: row[:id_usuario], id_contenido: row[:id_contenido], created_on: row[:created_on], updated_on: row[:updated_on]
      )
    end

    from(:coleccion_contenidos).where(nombre: 'favoritos').delete
  end
end
