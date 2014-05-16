class Contact < ActiveRecord::Base
	
 require 'rest_client'
 require 'json'
 require 'uri'

belongs_to :client

#Variables de la clase Crm
@@user_name = 'grupo3'
@@vturl = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation='
@@login = false
def self.getchallenge
   
	gcurl = @@vturl + 'getchallenge&username=' +@@user_name
	#Get request al getchallenge
    getc = RestClient.get 	gcurl
	#token variable de instancia
	@token = JSON.parse(getc.body)['result']['token']

    urlogin = @@vturl + 'login'	
    @md5 = Digest::MD5.hexdigest(@token+'0GQ1snGfCFvIHpcT')
	#Post request de login
    log = RestClient.post urlogin, 
         'operation' => 'login',
         'username' => @@user_name,
         'accessKey' => @md5
	 
	#p JSON.parse(log.body)['result']
	@sessionId = JSON.parse(log.body)['result']['sessionName']
	@@login = true
	return @sessionId
end

def self.listypes(element)
	urlisttypes =  @@vturl +'listtypes&sessionName='+@sessionId	
	lista = RestClient.get urlisttypes
	deco = JSON.parse(lista.body)['result']['types']
	if(element.is_a?(String))
	descurl = @@vturl+'describe&sessionName='+@sessionId+'&elementType=' +element
	else
	descurl = @@vturl+'describe&sessionName='+@sessionId+'&elementType=Contacts'	
	#descurl = @@vturl+'describe&sessionName='+@sessionId+'&elementType=Accounts'
	end
	describe = RestClient.get 	descurl
	@idprefix = JSON.parse(describe.body)['result']['idPrefix']
end

def self.retrieve
	urlretrieve = @@vturl+ 'retrieve&sessionName=' +@sessionId+ '&id=' +@idprefix+ 'x3308'	
	ret = JSON.parse((RestClient.get urlretrieve).body)['result']
	#urlretrieve = @@vturl+ 'retrieve&sessionName=' +@sessionId+ '&id=' +12x3308'
	return ret
end
  
 #cf_707 
 # Contact.query('75644') 
 # Crm.query('10839440-4')
 # Crm.query('3307253-8')
 # Crm.query('4362743-0')
 #23093md
def self.query(rut)
unless (@@login)
 self.getchallenge()
end
 queryString = "select firstname, lastname, otherstreet, othercity, otherstate from Contacts where cf_707 = '#{rut}';"
 queryParams = URI.encode(queryString)
 urlquery = @@vturl+ 'query&sessionName='+@sessionId+'&query='+queryParams
 result = JSON.parse((RestClient.get urlquery).body)['result'] 
 o = result[0]
 info = 'Pedido por '+ o['firstname'] + ' ' + o['lastname'] + ' a la direccion: ' + o['otherstreet'] + ', ' +o['othercity'] + ', ' + o['otherstate']  
return info
 end
 
 def self.extendsesion
 	# extendurl = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=extendsession'	
	# ext = RestClient.post extendurl	
	# @sessionId = JSON.
 end
end
