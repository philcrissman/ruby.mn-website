require File.dirname(__FILE__) + '/../test_helper'
require 'opening_controller'

# Re-raise errors caught by the controller.
class OpeningController; def rescue_action(e) raise e end; end

class OpeningControllerTest < Test::Unit::TestCase
  fixtures :users, :openings
  def setup
    @controller = OpeningController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_requires_login 
    get :index
    assert_response :redirect
    assert_redirected_to :controller=>'user', :action=>'login'
  end

  def test_index
    @request.session[:user] = users(:bob)
    get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:openings)
  end

  def test_create_no_id
    @request.session[:user] = users(:bob)
    get :create
    assert_response :success
    assert_template 'opening_form'
  end
end