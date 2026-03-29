class RegistrationsController < ApplicationController
  def new
  end

  def create
    if params[:website].present?
      redirect_to root_path and return
    end

    # Attach credentials to the current anonymous player; if already registered, start fresh.
    player = authenticated? ? Player.new : current_player

    player.name = params[:name]
    player.email_address = params[:email_address]
    player.password = params[:password]

    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = "Passwords do not match."
      return render :new, status: :unprocessable_entity
    end

    if player.save
      start_new_session_for(player)
      redirect_to root_path
    else
      flash.now[:alert] = player.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end
end
