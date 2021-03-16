class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :check_post_params, only: [:create, :update]

  def index
    @posts = Post.all.order(created_at: :desc)

    render json: @posts, each_serializer: PostListSerializer
  end

  def show
    render json: @post
  end

  def create
    @post = @current_user.posts.build(post_params)

    if @post.save
      render json: @post, status: :created, location: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def check_post_params
    param! :title, String, max_length: 100, message: 'Title should have no more than 100 characters'

    if action_create?
      param! :title, String, required: true
      param! :title, String, blank: false, message: 'Title is blank'
      param! :content, String, required: true
      param! :content, String, blank: false, message: 'Content is blank'
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      head :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
      render json: {"message": 'Post not found'}, status: 422 unless @post
    end

    def post_params
      params.require(:post).permit(:title, :content, :category_id, :author_id)
    end
end
