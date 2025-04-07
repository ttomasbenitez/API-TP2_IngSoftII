Sequel.migration do
  up do
    rename_table :playlist, :coleccion_contenidos

    alter_table(:coleccion_contenidos) do
      add_column :nombre, String
    end

    from(:coleccion_contenidos).update(nombre: 'playlist')
  end

  down do
    alter_table(:coleccion_contenidos) do
      drop_column :nombre
    end

    rename_table :coleccion_contenidos, :playlist
  end
end
