require 'test_helper'

class PreciosTemporalsControllerTest < ActionController::TestCase
  setup do
    @precios_temporal = precios_temporals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:precios_temporals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precios_temporal" do
    assert_difference('PreciosTemporal.count') do
      post :create, precios_temporal: { SKU: @precios_temporal.SKU, precio: @precios_temporal.precio }
    end

    assert_redirected_to precios_temporal_path(assigns(:precios_temporal))
  end

  test "should show precios_temporal" do
    get :show, id: @precios_temporal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @precios_temporal
    assert_response :success
  end

  test "should update precios_temporal" do
    patch :update, id: @precios_temporal, precios_temporal: { SKU: @precios_temporal.SKU, precio: @precios_temporal.precio }
    assert_redirected_to precios_temporal_path(assigns(:precios_temporal))
  end

  test "should destroy precios_temporal" do
    assert_difference('PreciosTemporal.count', -1) do
      delete :destroy, id: @precios_temporal
    end

    assert_redirected_to precios_temporals_path
  end
end
