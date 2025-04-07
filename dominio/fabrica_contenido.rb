class FabricaContenido
  def self.crear(tipo)
    return Cancion if tipo == 'cancion'

    return Episodio if tipo == 'episodio'

    nil
  end
end
