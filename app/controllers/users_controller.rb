class UsersController < ApplicationController
  require 'rest-client'

  def login
    @user = User.new
  end

  def create_session
    @user = User.new(login_params)
    if user = User.create_session(login_params)
      session[:user_id] =  user["id"]
      flash[:notice] = 'User logged in successfully.'
      redirect_to user_path
    else
      flash[:alert] = 'Invalid User'
      render :login
    end
  end

  def sign_up
    @user = User.new
  end

  def show
    if user_id = session[:user_id]
      @user = User.get_user_details(session[:user_id])
    else
      flash[:alert] = 'Session expired.'
      redirect_to home_path
    end
  end

  def create
    @user = User.new(user_params)
    if @user.create_user
      if @user.errors.any? 
        render :sign_up
      else
        flash[:notice] = 'User created successfully.'
        redirect_to home_path
      end
    else
      flash[:alert] = 'Please try again. something went wrong.'
      redirect_to home_path
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = 'Logout successfully'
    redirect_to home_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :mobile_number, :username, :email, :password, :password_confirmation)
  end

  def login_params
     params.require(:user).permit(:username, :password)
  end

end
