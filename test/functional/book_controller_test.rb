require File.dirname(__FILE__) + '/../test_helper'
require 'book_controller'

# Re-raise errors caught by the controller.
class BookController; def rescue_action(e) raise e end; end

class BookControllerTest < Test::Unit::TestCase
  fixtures :users, :books
  def setup
    @controller = BookController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_req_login
    get :index
    assert_response :redirect
    assert_redirected_to :controller=>'user', :action=>'login'
  end

  def test_index
    @request.session[:user]=users(:bob)
    get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:books)
  end

  def test_new
    @request.session[:user]=users(:bob)
    post :new, "book"=>{"title"=>"foo","author"=>"bar", "isbn"=>"abcd", "description"=>"description"}
    assert_response :success
    assert assigns(:book)
    assert assigns(:success)
    assert_template 'new'
    b= Book.find_by_title('foo')
    assert_not_nil b
    assert_equal users(:bob), assigns(:book).user
  end

  def test_bad_new
    @request.session[:user]=users(:bob)
    post :new, "book"=>{:title=>'', :author=>'', :isbn=>'', :description=>''}
    assert_response :success
    assert assigns(:success)==false
    assert assigns(:book)
    assert_equal "can't be blank", assigns(:book).errors.on(:title)
    assert_equal "can't be blank", assigns(:book).errors.on(:author)
    assert_equal "can't be blank", assigns(:book).errors.on(:isbn)
    assert_equal "can't be blank", assigns(:book).errors.on(:description)
  end

  def test_add
    @request.session[:user]=users(:bob)
    post :add
    assert_response :success
    assert_template 'add'
  end

  def test_hide_form
    @request.session[:user]=users(:bob)
    post :hide_form
    assert_response :success
    assert_template 'hide_form'
  end

  def test_delete_book
    @request.session[:user]=users(:bob)
    post :delete, "id"=>books(:first).id
    assert_response :success
    assert_template 'delete'
  end

end
