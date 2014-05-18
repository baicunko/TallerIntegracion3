module ApplicationHelper
  APP_KEY="ic0hidmnoxyvp9q"
  APP_SECRET="n80ou9i5e4u9iix"
  require 'dropbox_sdk'

  def self.connect
    code = "wsWFRrcC0rkAAAAAAAAAC925LJBoi7yUZFXn2NyLtuqLapTzJqvoPCav4Pm4sIys"
    client = DropboxClient.new(code)
    puts "linked account:", client.account_info().inspect
    contents, metadata = client.get_file_and_metadata('/Grupo3/DBPrecios.accdb')

    destination_file_full_path = Rails.root.to_s + "/app/" + "products.accdb"
    open(destination_file_full_path, 'wb') do |file|
      file << contents
    end

    #ya tenemos cargado entonces el Access, ahora pasemoslo a csv
    access2csv=Rails.root.to_s + "/app/"
    comando="/usr/bin/java -jar "+access2csv+"access2csv.jar "+access2csv+"products.accdb";
    system(comando);
    LoadingHelper.import;
    LoadingHelper.importProductosJson;
    PreciosTemporalsHelper.crear_tabla;



  end

  def self.ProcesarPedidos
    #Cada 10 minutos este metodo se debe llamar
    FtpPedido.verPedidos;
    sql = "SELECT * from ftp_pedidos WHERE entrega >= DATE ('now') AND envio IS NULL GROUP BY id ORDER BY entrega DESC"
    records_array = FtpPedido.connection.execute(sql)
    records_array.each do |tupla|
      p tupla
    end




  end

end
