class UsersController < ApplicationController
  skip_before_action :authenticate, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy, :post_list]
  before_action :check_user_params, only: [:create, :update]

  def index
    @users = User.all

    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: {errors: @user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def check_user_params
    param! :email, String, required: true if action_create?
    param! :email, String, blank: false, message: 'Email is blank' if action_create?
    param! :email, String, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
                          message: 'Email must match format yourname@example.com'
    if User.find_by_email(params[:email]) && action_create?
      return render json: {"message": 'That email address is already taken. Try another one'}, status: :bad_request
    end
    param! :password, String, required: true if action_create?
    param! :password, String, blank: false, message: 'Password is blank' if action_create?
    param! :password, String, min_length: 8, message: 'Please enter a valid password that consists of a minimum of 6 characters'
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      head :no_content
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def post_list
    @posts = @user.posts.order(created_at: :desc)

    render json: @posts, each_serializer: PostListSerializer, status: :ok
  end

  private
    def set_user
      @user = params[:id] ? User.find(params[:id]) : User.find(params[:user_id])
      render json: {"message": 'User not found'}, status: 422 unless @user
    end

    def user_params
      params.require(:user).permit(:name, :email, :token, :password, :password_digest)
    end
end
