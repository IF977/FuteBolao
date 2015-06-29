class DashboardController < ApplicationController

  def index
    @grouped_matches = Match.
                          active.
                          group_ordered.
                          order("datetime ASC").                          
                          decorate(context: {user: current_user}).
                          group_by(&:group)
  end

end