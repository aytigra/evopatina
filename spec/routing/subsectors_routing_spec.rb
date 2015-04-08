require "rails_helper"

RSpec.describe SubsectorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/subsectors").to route_to("subsectors#index")
    end

    it "routes to #new" do
      expect(:get => "/subsectors/new").to route_to("subsectors#new")
    end

    it "routes to #show" do
      expect(:get => "/subsectors/1").to route_to("subsectors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/subsectors/1/edit").to route_to("subsectors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/subsectors").to route_to("subsectors#create")
    end

    it "routes to #update" do
      expect(:put => "/subsectors/1").to route_to("subsectors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/subsectors/1").to route_to("subsectors#destroy", :id => "1")
    end

  end
end
