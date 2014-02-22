class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    @form = CategoryForm.new(category: @category)
  end

  # GET /categories/1/edit
  def edit
    @form = CategoryForm.new(category: @category)
  end

  # POST /categories
  def create
    @category = Category.new(category_params)
    @form = CategoryForm.new(category: @category)

    if @form.save
      redirect_to @form, notice: 'Category was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /categories/1
  def update
    @form = CategoryForm.new(category: @category)
    @form.fill_attributes(category_params)
    if @form.save
      binding.pry
      redirect_to @form, notice: 'Category was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Category was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:title, user_ids: [])
    end
end
