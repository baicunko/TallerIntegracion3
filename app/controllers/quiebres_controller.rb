class QuiebresController < ApplicationController
  before_action :set_quiebre, only: [:show, :edit, :update, :destroy]

  # GET /quiebres
  # GET /quiebres.json
  def index
    @quiebres = Quiebre.all
    @array=[]
    # fecha=@quiebres.first.created_at
    # while(fecha<Date.today)
    #   num=@quiebres.where(created_at:fecha).count
    #   @array << [fecha.to_datetime.to_i*100, num]
    #   fecha=fecha+1.day
    # end
    @array= [
              [(Date.today-10.day).to_datetime.to_i*1000, 29.9], 
              [(Date.today-5.day).to_datetime.to_i*1000, 71.5], 
              [Date.today.to_datetime.to_i*1000, 106.4]
            ]
  end

  # GET /quiebres/1
  # GET /quiebres/1.json
  def show
  end

  # GET /quiebres/new
  def new
    @quiebre = Quiebre.new
  end

  # GET /quiebres/1/edit
  def edit
  end

  # POST /quiebres
  # POST /quiebres.json
  def create
    @quiebre = Quiebre.new(quiebre_params)

    respond_to do |format|
      if @quiebre.save
        format.html { redirect_to @quiebre, notice: 'Quiebre was successfully created.' }
        format.json { render action: 'show', status: :created, location: @quiebre }
      else
        format.html { render action: 'new' }
        format.json { render json: @quiebre.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quiebres/1
  # PATCH/PUT /quiebres/1.json
  def update
    respond_to do |format|
      if @quiebre.update(quiebre_params)
        format.html { redirect_to @quiebre, notice: 'Quiebre was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @quiebre.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quiebres/1
  # DELETE /quiebres/1.json
  def destroy
    @quiebre.destroy
    respond_to do |format|
      format.html { redirect_to quiebres_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quiebre
      @quiebre = Quiebre.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quiebre_params
      params.require(:quiebre).permit(:pedido, :nombrecliente, :fechaquiebre)
    end
end
