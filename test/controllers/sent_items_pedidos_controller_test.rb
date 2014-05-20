require 'test_helper'

class SentItemsPedidosControllerTest < ActionController::TestCase
  setup do
    @sent_items_pedido = sent_items_pedidos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sent_items_pedidos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sent_items_pedido" do
    assert_difference('SentItemsPedido.count') do
      post :create, sent_items_pedido: { cantidad: @sent_items_pedido.cantidad, direccion: @sent_items_pedido.direccion, pedidoid: @sent_items_pedido.pedidoid, precio: @sent_items_pedido.precio, respuesta: @sent_items_pedido.respuesta, sku: @sent_items_pedido.sku }
    end

    assert_redirected_to sent_items_pedido_path(assigns(:sent_items_pedido))
  end

  test "should show sent_items_pedido" do
    get :show, id: @sent_items_pedido
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sent_items_pedido
    assert_response :success
  end

  test "should update sent_items_pedido" do
    patch :update, id: @sent_items_pedido, sent_items_pedido: { cantidad: @sent_items_pedido.cantidad, direccion: @sent_items_pedido.direccion, pedidoid: @sent_items_pedido.pedidoid, precio: @sent_items_pedido.precio, respuesta: @sent_items_pedido.respuesta, sku: @sent_items_pedido.sku }
    assert_redirected_to sent_items_pedido_path(assigns(:sent_items_pedido))
  end

  test "should destroy sent_items_pedido" do
    assert_difference('SentItemsPedido.count', -1) do
      delete :destroy, id: @sent_items_pedido
    end

    assert_redirected_to sent_items_pedidos_path
  end
end
