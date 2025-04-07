def crear_tabla_autores(db)
  db.create_table(:autores) do
    primary_key :id
    String :tipo
    String :nombre
    Date :created_on
    Date :updated_on
  end
end

def migrar_datos_autores(db)
  db[:contenido].distinct.select(:autor).each do |row|
    db[:autores].insert(
      tipo: 'artista',
      nombre: row[:autor],
      created_on: Date.today,
      updated_on: Date.today
    )
  end
end

def actualizar_referencias_contenido(db)
  db[:contenido].each do |contenido|
    autor = db[:autores].where(nombre: contenido[:autor]).first
    db[:contenido].where(id: contenido[:id]).update(autor_id: autor[:id])
  end
end

def restaurar_referencias_contenido(db)
  db[:contenido].each do |contenido|
    autor = db[:autores].where(id: contenido[:autor_id]).first
    db[:contenido].where(id: contenido[:id]).update(autor: autor[:nombre])
  end
end

Sequel.migration do
  up do
    crear_tabla_autores(self)
    migrar_datos_autores(self)

    alter_table(:contenido) do
      add_foreign_key :autor_id, :autores
    end

    actualizar_referencias_contenido(self)

    alter_table(:contenido) do
      drop_column :autor
    end
  end

  down do
    alter_table(:contenido) do
      add_column :autor, String
    end

    restaurar_referencias_contenido(self)

    alter_table(:contenido) do
      drop_foreign_key :autor_id
    end

    drop_table(:autores)
  end
end
