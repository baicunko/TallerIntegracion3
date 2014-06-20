require 'test_helper'

class PruebanatsControllerTest < ActionController::TestCase
  setup do
    @pruebanat = pruebanats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pruebanats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pruebanat" do
    assert_difference('Pruebanat.count') do
      post :create, pruebanat: {  }
    end

    assert_redirected_to pruebanat_path(assigns(:pruebanat))
  end

  test "should show pruebanat" do
    get :show, id: @pruebanat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pruebanat
    assert_response :success
  end

  test "should update pruebanat" do
    patch :update, id: @pruebanat, pruebanat: {  }
    assert_redirected_to pruebanat_path(assigns(:pruebanat))
  end

  test "should destroy pruebanat" do
    assert_difference('Pruebanat.count', -1) do
      delete :destroy, id: @pruebanat
    end

    assert_redirected_to pruebanats_path
  end
end
