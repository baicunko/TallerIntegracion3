class PreciosTemporalsController < ApplicationController
  before_action :set_precios_temporal, only: [:show, :edit, :update, :destroy]

  # GET /precios_temporals
  # GET /precios_temporals.json
  def index
    @precios_temporals = PreciosTemporal.all
  end

  # GET /precios_temporals/1
  # GET /precios_temporals/1.json
  def show
  end

  # GET /precios_temporals/new
  def new
    @precios_temporal = PreciosTemporal.new
  end

  # GET /precios_temporals/1/edit
  def edit
  end

  # POST /precios_temporals
  # POST /precios_temporals.json
  def create
    @precios_temporal = PreciosTemporal.new(precios_temporal_params)


    respond_to do |format|
      if @precios_temporal.save
        format.html { redirect_to @precios_temporal, notice: 'Precios temporal was successfully created.' }
        format.json { render action: 'show', status: :created, location: @precios_temporal }
      else
        format.html { render action: 'new' }
        format.json { render json: @precios_temporal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /precios_temporals/1
  # PATCH/PUT /precios_temporals/1.json
  def update
    respond_to do |format|
      if @precios_temporal.update(precios_temporal_params)
        format.html { redirect_to @precios_temporal, notice: 'Precios temporal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @precios_temporal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /precios_temporals/1
  # DELETE /precios_temporals/1.json
  def destroy
    @precios_temporal.destroy
    respond_to do |format|
      format.html { redirect_to precios_temporals_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_precios_temporal
      @precios_temporal = PreciosTemporal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def precios_temporal_params
      params.require(:precios_temporal).permit(:SKU, :precio)
    end
end
