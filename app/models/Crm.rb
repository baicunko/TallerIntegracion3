class Crm < ActiveRecord::Base
 require 'rest_client'
 require 'json'
 
def self.getchallenge

    user_name = 'grupo3'
	vturl = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation='
	gcurl = vturl + 'getchallenge&username=grupo3'
    getc = RestClient.get 	gcurl
	token = JSON.parse(getc.body)['result']['token']

    urlogin = vturl + 'login'	
    @md5 = Digest::MD5.hexdigest(token+'0GQ1snGfCFvIHpcT')
    log = RestClient.post urlogin, 
         'operation' => 'login',
         'username' => user_name,
         'accessKey' => @md5
	 
	sessionId = JSON.parse(post.body)['result']['sessionName']
	
	urlisttypes =  vturl 'listtypes&sessionName='+sessionId
	
	lista = RestClient.get urlisttypes
	deco = JSON.parse(lista.body)['result']['types']
	
	describe = RestClient.get vturl+'describe&sessionName='+sessionId+'&elementType=Accounts'	
	idprefix = JSON.parse(describe.body)['result']['idPrefix']
		
	urlretrieve = vturl+'retrieve&sessionName='+sessionId+'&id='+idprefix+'x3167'	
	ret = RestClient.get urlretrieve
	
	retr = JSON.parse(ret.body)['result']
	
	#extendurl = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=extendsession'	
	#ext = RestClient.post extendurl
	
	
	return retr
  end
end