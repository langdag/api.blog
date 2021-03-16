class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy, :post_list]

  def index
    @categories = Category.all

    render json: @categories
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      head :no_content
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def post_list
    @posts = @category.posts.order(created_at: :desc)

    render json: @posts, each_serializer: PostListSerializer, status: :ok
  end

  private
    def set_category
      @category = params[:id] ? Category.find(params[:id]) : Category.find(params[:category_id])
      render json: {"message": 'Category not found'}, status: 422 unless @category
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
