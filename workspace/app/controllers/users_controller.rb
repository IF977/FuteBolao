class UsersController < ApplicationController

  def profile
    @profile = User.find(params[:id]).decorate
  end

  def history
    @history = current_user.decorate
  end

end