class UsuariosClavesApi < ActiveRecord::Base
	def self.usuarios_claves
		UsuariosClavesApi.where(grupo:'grupo4').first_or_create(grupo:'grupo4', password:'Wl1L9jdnzS8BHQtmVEkcw5khkfc=')
		UsuariosClavesApi.where(grupo:'grupo8').first_or_create(grupo:'grupo8', password:'kJujcLg9FUp02lFkZfKvVnyxHUk=')
		UsuariosClavesApi.where(grupo:'grupo5').first_or_create(grupo:'grupo5', password:'YeJK0np5sDWaW51ywOsOAzWpLZ4=')
		UsuariosClavesApi.where(grupo:'grupo3').first_or_create(grupo:'grupo3', password:'kakQAo46rtCeQSIU96HKmQxUKQU=')
	end
end
