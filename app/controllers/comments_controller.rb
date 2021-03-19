class CommentsController < ApplicationController
  before_action :set_post, only: [:index, :create, :show, :update, :destroy]
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :check_comments_params, only: [:create, :update]

  def index
    @comments = @post.comments

    render json: @comments
  end

  def show
    render json: @comment
  end

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = @current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def check_comments_params
    param! :body, String, max_length: 1000, message: 'Body should have no more than 1000 characters'

    if action_create?
      param! :body, String, required: true
      param! :body, String, blank: false, message: 'Body is blank'
    end
  end

  def update
    authorize! :update, @comment
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @comment
    if @comment.destroy
      head :no_content
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private
    def set_comment
      @comment = @post.comments.find(params[:id])
      render json: {"message": 'Comment not found'}, status: 422 unless @comment
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(:body, :user_id, :post_id)
    end
end
