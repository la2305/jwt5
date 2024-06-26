class Users::CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes], status: :ok
  end

  def update_password
    if current_user.update_with_password(password_params)
      sign_in(current_user, bypass: true)
      render json: { message: "Password updated successfully" }, status: :ok
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_info
    if current_user.update(user_params)
      render json: { message: "Update succcessfully"}, status: :ok
    else
      render json: { errors: current_user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:username, :phone, :gender, :date_of_birth, :country)
  end
end
