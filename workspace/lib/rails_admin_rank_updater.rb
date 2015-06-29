require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'

module RailsAdminRankUpdater
end

module RailsAdmin
  module Config
    module Actions
      class RankUpdater < RailsAdmin::Config::Actions::Base

        register_instance_option :link_icon do
          'icon-refresh'
        end

        register_instance_option :visible? do
          bindings[:abstract_model].to_s == "User"
        end

        register_instance_option :collection? do
          true
        end

        register_instance_option :controller do
          Proc.new do
            # In the future it would be better to use a queue
            Bolao::Rank.update_scores User.all
            Bolao::Rank.update_rank User.order(score: :desc)
            redirect_to back_or_index, notice: "Rank updated!"
          end
        end

      end
    end
  end
end