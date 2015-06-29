require 'spec_helper'

describe RulesController do

  describe 'GET index' do
    it "renders index template" do
      get :index
      response.should be_true
    end
  end

end