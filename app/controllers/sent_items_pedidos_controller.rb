class SentItemsPedidosController < ApplicationController
  before_action :set_sent_items_pedido, only: [:show, :edit, :update, :destroy]

  # GET /sent_items_pedidos
  # GET /sent_items_pedidos.json
  def index
    @sent_items_pedidos = SentItemsPedido.all
  end

  # GET /sent_items_pedidos/1
  # GET /sent_items_pedidos/1.json
  def show
  end

  # GET /sent_items_pedidos/new
  def new
    @sent_items_pedido = SentItemsPedido.new
  end

  # GET /sent_items_pedidos/1/edit
  def edit
  end

  # POST /sent_items_pedidos
  # POST /sent_items_pedidos.json
  def create
    @sent_items_pedido = SentItemsPedido.new(sent_items_pedido_params)

    respond_to do |format|
      if @sent_items_pedido.save
        format.html { redirect_to @sent_items_pedido, notice: 'Sent items pedido was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sent_items_pedido }
      else
        format.html { render action: 'new' }
        format.json { render json: @sent_items_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sent_items_pedidos/1
  # PATCH/PUT /sent_items_pedidos/1.json
  def update
    respond_to do |format|
      if @sent_items_pedido.update(sent_items_pedido_params)
        format.html { redirect_to @sent_items_pedido, notice: 'Sent items pedido was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sent_items_pedido.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sent_items_pedidos/1
  # DELETE /sent_items_pedidos/1.json
  def destroy
    @sent_items_pedido.destroy
    respond_to do |format|
      format.html { redirect_to sent_items_pedidos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sent_items_pedido
      @sent_items_pedido = SentItemsPedido.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sent_items_pedido_params
      params.require(:sent_items_pedido).permit(:sku, :cantidad, :precio, :direccion, :pedidoid, :respuesta)
    end
end
