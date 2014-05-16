class ProductosJsonsController < ApplicationController
  before_action :set_productos_json, only: [:show, :edit, :update, :destroy]

  # GET /productos_jsons
  # GET /productos_jsons.json
  def index
    @productos_jsons = ProductosJson.all
  end

  # GET /productos_jsons/1
  # GET /productos_jsons/1.json
  def show
  end

  # GET /productos_jsons/new
  def new
    @productos_json = ProductosJson.new
  end

  # GET /productos_jsons/1/edit
  def edit
  end

  # POST /productos_jsons
  # POST /productos_jsons.json
  def create
    @productos_json = ProductosJson.new(productos_json_params)

    respond_to do |format|
      if @productos_json.save
        format.html { redirect_to @productos_json, notice: 'Productos json was successfully created.' }
        format.json { render action: 'show', status: :created, location: @productos_json }
      else
        format.html { render action: 'new' }
        format.json { render json: @productos_json.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /productos_jsons/1
  # PATCH/PUT /productos_jsons/1.json
  def update
    respond_to do |format|
      if @productos_json.update(productos_json_params)
        format.html { redirect_to @productos_json, notice: 'Productos json was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @productos_json.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /productos_jsons/1
  # DELETE /productos_jsons/1.json
  def destroy
    @productos_json.destroy
    respond_to do |format|
      format.html { redirect_to productos_jsons_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_productos_json
      @productos_json = ProductosJson.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def productos_json_params
      params.require(:productos_json).permit(:SKU, :Marca, :Modelo, :PrecioNormal, :PrecioInternet, :Descripcion, :Imagen, :Categoria1, :Categoria2, :Categoria3, :Categoria4, :Categoria5, :Categoria6, :Categoria7, :Categoria8)
    end
end
