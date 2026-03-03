class LoginsController < ApplicationController
  def new
  end

  def create
    player = Player.authenticate_by(email_address: params[:email_address], password: params[:password])
    if player
      start_new_session_for(player)
      redirect_to root_path
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path
  end
end
