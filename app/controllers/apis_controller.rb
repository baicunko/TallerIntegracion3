class ApisController < ApplicationController
  skip_before_action :verify_authenticity_token

  
  def despachar_producto_fuera

    require 'openssl'
    require "base64"

    #Verificamos parámetros correctos
    if params["usuario"].nil? or params["password"].nil? or params["almacen_id"].nil? or params["SKU"].nil? or params["cantidad"].nil?
      render :json => [:error => "Faltan parametros."].to_json and return
    elsif params["cantidad"].to_i <= 0
      render :json => [:error => "Imposible realizar despacho requerido. Cantidad incorrecta."].to_json and return
    end

    user = params["usuario"]
    pass_recibida = params["password"]
    almacen = params["almacen_id"]
    sku = params["SKU"]
    cant = params["cantidad"].to_i


    #Verificar grupo y clave
    sql = "Select * from usuarios_claves_apis WHERE grupo = '#{user}';"
    records_array = UsuariosClavesApi.connection.execute(sql)
    if records_array.count == 0
      render :json => [:error => "Grupo no existe."].to_json and return
    else
      autorizacion = UsuariosClavesApi.find_by_grupo(user)
      sql1 = "Select password from usuarios_claves_apis WHERE grupo = '#{user}';"
      records_array = UsuariosClavesApi.connection.execute(sql1)
      clave = records_array[0][0]
      #clave = clave.delete! '\\n'
      
      #pass_nueva = clave
      hash  = OpenSSL::HMAC.digest('sha1', "HOLA", pass_recibida.to_s)
      pass_nueva=Base64.encode64(hash)
      pass_nueva = pass_nueva.delete! "\n"
      #render :json => [:error => pass_nueva, :error2 => clave, :passcod => pass_recibida ].to_json and return
      #pass_nueva = Base64.encode64(Digest::HMAC.digest(clave, ENV["WAREHOUSE_PRIVATE_KEY"], Digest::SHA1))
      if clave.to_s != pass_nueva.to_s
        render :json => [:error => "Contraseña incorrecta."].to_json and return
      end
    end

    s = StockManagementController.new
    stock_sku = s.getcantidadtotal(sku)

    if stock_sku == 0
      render :json => [:SKU => sku.to_s, :cantidad => 0].to_json and return
    end

    stock_reservado = Reserva.stockReservadoTodo(sku)

    if stock_reservado.nil?
      stock_reservado = 0
    end
    stock_efectivo = stock_sku - stock_reservado

    if stock_efectivo > cant
        s.mover_a_despacho_sku(sku,cant)
        s.despachar_sku_para_grupos(sku,cant,almacen)
      render :json => [:SKU => sku.to_s, :cantidad => cant.to_i].to_json and return
    else
      render :json => [:error => "No hay stock suficiente."].to_json and return
    end
  end

  # GET /apis
  # GET /apis.json
  def index
    @apis = Api.all
  end

  # GET /apis/1
  # GET /apis/1.json
  def show
  end

  # GET /apis/new
  def new
    @api = Api.new
  end

  # GET /apis/1/edit
  def edit
  end

  # POST /apis
  # POST /apis.json
  def create
    @api = Api.new(api_params)

    respond_to do |format|
      if @api.save
        format.html { redirect_to @api, notice: 'Api was successfully created.' }
        format.json { render action: 'show', status: :created, location: @api }
      else
        format.html { render action: 'new' }
        format.json { render json: @api.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /apis/1
  # PATCH/PUT /apis/1.json
  def update
    respond_to do |format|
      if @api.update(api_params)
        format.html { redirect_to @api, notice: 'Api was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @api.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /apis/1
  # DELETE /apis/1.json
  def destroy
    @api.destroy
    respond_to do |format|
      format.html { redirect_to apis_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api
      @api = Api.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_params
      params[:api]
    end
end
