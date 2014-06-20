class PruebanatsController < ApplicationController
  before_action :set_pruebanat, only: [:show, :edit, :update, :destroy]

  # GET /pruebanats
  # GET /pruebanats.json
  def index
    @pruebanats = Pruebanat.all
  end

  # GET /pruebanats/1
  # GET /pruebanats/1.json
  def show
  end

  # GET /pruebanats/new
  def new
    @pruebanat = Pruebanat.new
  end

  # GET /pruebanats/1/edit
  def edit
  end

  # POST /pruebanats
  # POST /pruebanats.json
  def create
    @pruebanat = Pruebanat.new(pruebanat_params)

    respond_to do |format|
      if @pruebanat.save
        format.html { redirect_to @pruebanat, notice: 'Pruebanat was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pruebanat }
      else
        format.html { render action: 'new' }
        format.json { render json: @pruebanat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pruebanats/1
  # PATCH/PUT /pruebanats/1.json
  def update
    respond_to do |format|
      if @pruebanat.update(pruebanat_params)
        format.html { redirect_to @pruebanat, notice: 'Pruebanat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pruebanat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pruebanats/1
  # DELETE /pruebanats/1.json
  def destroy
    @pruebanat.destroy
    respond_to do |format|
      format.html { redirect_to pruebanats_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pruebanat
      @pruebanat = Pruebanat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pruebanat_params
      params[:pruebanat]
    end
end
