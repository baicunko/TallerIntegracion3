class AgregarDatosGrupos < ActiveRecord::Migration
  def change  	
  	UsuariosClavesApi.where(grupo: "grupo1").first_or_create(grupo: "grupo1", password: "bJPteJrKXNmzolna7qPWoCv4cQg=")
  	UsuariosClavesApi.where(grupo: "grupo2").first_or_create(grupo: "grupo2", password: "5Lg18yweW83HLoPqG3H7dNsly+M=")
  	UsuariosClavesApi.where(grupo: "grupo4").first_or_create(grupo: "grupo4", password: "Wl1L9jdnzS8BHQtmVEkcw5khkfc=")
  	UsuariosClavesApi.where(grupo: "grupo5").first_or_create(grupo: "grupo5", password: "YeJK0np5sDWaW51ywOsOAzWpLZ4=")
  	UsuariosClavesApi.where(grupo: "grupo6").first_or_create(grupo: "grupo6", password: "5zUX+icSea/0Mqot+qqT9XdJrsg=")
  	UsuariosClavesApi.where(grupo: "grupo7").first_or_create(grupo: "grupo7", password: "rzWk5ekjF78SE6MN9CNXDGB8t8c=")
  	UsuariosClavesApi.where(grupo: "grupo8").first_or_create(grupo: "grupo8", password: "kJujcLg9FUp02lFkZfKvVnyxHUk=")
  	UsuariosClavesApi.where(grupo: "grupo9").first_or_create(grupo: "grupo9", password: "5+poOzPufoM6WW0/31pB0UG7g7I=")
  end
end
