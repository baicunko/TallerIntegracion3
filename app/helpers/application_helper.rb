module ApplicationHelper
  APP_KEY="ic0hidmnoxyvp9q"
  APP_SECRET="n80ou9i5e4u9iix"
  require 'dropbox_sdk'

  def self.connect
    code = "wsWFRrcC0rkAAAAAAAAAC925LJBoi7yUZFXn2NyLtuqLapTzJqvoPCav4Pm4sIys"
    client = DropboxClient.new(code)
    puts "linked account:", client.account_info().inspect
    contents, metadata = client.get_file_and_metadata('/Grupo3/DBPrecios.accdb')

    destination_file_full_path = Rails.root.to_s + "/" + "DBPrecios.accdb"


      open(destination_file_full_path, 'wb') do |file|
        file << open(contents).read
      end
    puts destination_file_full_path
    open('DBPrecios.accdb', 'w') {|f| f.puts contents }
  end
end
