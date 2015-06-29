class GuessesController < ApplicationController

  def my_guesses
    # get all open matches including and associates the current user guesses to it
    @grouped_matches = Match.
                          open_to_guesses.
                          group_ordered.
                          order("datetime ASC").
                          decorate(context: {user: current_user}).
                          group_by(&:group)
  end

  def update
    Bolao::Guesses.save(params, current_user)
    flash[:success] = t("guesses_page.guesses_saved")
    redirect_to my_guesses_path
  end
end