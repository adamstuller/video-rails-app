class UsersController < ApplicationController

  before_action :set_user, only: [ :destroy ]

  skip_before_action :require_user, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to root_path, notice: 'You were successfully signed up!' }
      else
        format.html { render :new }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    # VideoWorker.perform_async(@video.id, "Hallloc")

  end

  def user_params
    params.require(:user).permit(:name, :email, :page, :password, :password_confirmation)
  end

end