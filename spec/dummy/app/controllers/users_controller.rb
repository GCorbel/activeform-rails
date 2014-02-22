class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET /users/new
  def new
    @form = UserForm.new(user: User.new, category: Category.new)
  end

  # GET /users/1/edit
  def edit
    @category = @user.category
    @form = UserForm.new(user: @user, category: @category)
  end

  # POST /users
  def create
    @user = User.new
    @form = UserForm.new(user: @user, category: @category)
    @form.fill_attributes(user_params)

    if @form.valid?
      @form.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /users/1
  def update
    @category = @user.category
    @form = UserForm.new(user: @user, category: @category)
    @form.fill_attributes(user_params)

    if @form.valid?
      @form.save
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :title)
    end
end
