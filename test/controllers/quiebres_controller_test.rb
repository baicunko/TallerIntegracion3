require 'test_helper'

class QuiebresControllerTest < ActionController::TestCase
  setup do
    @quiebre = quiebres(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:quiebres)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create quiebre" do
    assert_difference('Quiebre.count') do
      post :create, quiebre: { fechaquiebre: @quiebre.fechaquiebre, nombrecliente: @quiebre.nombrecliente, pedido: @quiebre.pedido }
    end

    assert_redirected_to quiebre_path(assigns(:quiebre))
  end

  test "should show quiebre" do
    get :show, id: @quiebre
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @quiebre
    assert_response :success
  end

  test "should update quiebre" do
    patch :update, id: @quiebre, quiebre: { fechaquiebre: @quiebre.fechaquiebre, nombrecliente: @quiebre.nombrecliente, pedido: @quiebre.pedido }
    assert_redirected_to quiebre_path(assigns(:quiebre))
  end

  test "should destroy quiebre" do
    assert_difference('Quiebre.count', -1) do
      delete :destroy, id: @quiebre
    end

    assert_redirected_to quiebres_path
  end
end
