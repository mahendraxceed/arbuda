class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  # def index
  #   @users = User.all
  # end

  def index
    authorize! :index, User
    @datatable = UsersDatatable.new view_context
  end

  def search
    authorize! :index, User
    render json: UsersDatatable.new(view_context)
  end


  # GET /users/1
  # GET /users/1.json
  def show
    authorize! :show, @user
  end

  # GET /users/new
  def new
    authorize! :new, User
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    authorize! :create, User
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User is created successfully. '
    else
      flash.now[:alert] = @user.errors.full_messages.first
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @user
    if @user.update(user_params)
      flash.now[:notice] = '@user was successfully updated.'
    else
      flash.now[:alert] = @user.errors.full_messages.first
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize! :destroy, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :mobile, :name, :admin)
    end
end
