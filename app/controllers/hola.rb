class Hola
	def self.holear
		hash  = OpenSSL::HMAC.digest('sha1', "HOLA", "grupo1")
      	pass_nueva=Base64.encode64(hash)
      	pass_nueva = pass_nueva.delete! "\n"
      	puts pass_nueva
    end
end