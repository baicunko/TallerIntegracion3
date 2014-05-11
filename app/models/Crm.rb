class Crm < ActiveRecord::Base
 require 'rest_client'
 require 'json'
 
def self.getchallenge

    user_name = 'grupo3'
    resp1 = RestClient.get 	'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=getchallenge',:username => user_name
	token = JSON.parse(resp1.body)['result']['token']

    urlogin = 'http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation=login'
	
    @md5 = Digest::MD5.hexdigest(token+'0GQ1snGfCFvIHpcT')
    post = RestClient.post urlogin, {:params => {
         'operation' => 'login',
         'username' => user_name,
         'accessKey' => @md5 }}
	resp = JSON.parse(post.body)['success']
	return resp
  end
end