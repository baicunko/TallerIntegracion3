require 'test_helper'

class ProductosJsonsControllerTest < ActionController::TestCase
  setup do
    @productos_json = productos_jsons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:productos_jsons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create productos_json" do
    assert_difference('ProductosJson.count') do
      post :create, productos_json: { Categoria1: @productos_json.Categoria1, Categoria2: @productos_json.Categoria2, Categoria3: @productos_json.Categoria3, Categoria4: @productos_json.Categoria4, Categoria5: @productos_json.Categoria5, Categoria6: @productos_json.Categoria6, Categoria7: @productos_json.Categoria7, Categoria8: @productos_json.Categoria8, Descripcion: @productos_json.Descripcion, Imagen: @productos_json.Imagen, Marca: @productos_json.Marca, Modelo: @productos_json.Modelo, PrecioInternet: @productos_json.PrecioInternet, PrecioNormal: @productos_json.PrecioNormal, SKU: @productos_json.SKU }
    end

    assert_redirected_to productos_json_path(assigns(:productos_json))
  end

  test "should show productos_json" do
    get :show, id: @productos_json
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @productos_json
    assert_response :success
  end

  test "should update productos_json" do
    patch :update, id: @productos_json, productos_json: { Categoria1: @productos_json.Categoria1, Categoria2: @productos_json.Categoria2, Categoria3: @productos_json.Categoria3, Categoria4: @productos_json.Categoria4, Categoria5: @productos_json.Categoria5, Categoria6: @productos_json.Categoria6, Categoria7: @productos_json.Categoria7, Categoria8: @productos_json.Categoria8, Descripcion: @productos_json.Descripcion, Imagen: @productos_json.Imagen, Marca: @productos_json.Marca, Modelo: @productos_json.Modelo, PrecioInternet: @productos_json.PrecioInternet, PrecioNormal: @productos_json.PrecioNormal, SKU: @productos_json.SKU }
    assert_redirected_to productos_json_path(assigns(:productos_json))
  end

  test "should destroy productos_json" do
    assert_difference('ProductosJson.count', -1) do
      delete :destroy, id: @productos_json
    end

    assert_redirected_to productos_jsons_path
  end
end
