require 'rails_helper'

RSpec.describe WeeksController, type: :controller do

  describe "anonymous user" do
    before :each do
      # This simulates an anonymous user
      login_with nil
    end

    it "redirected to signin" do
      get :index
      expect( response ).to redirect_to( new_user_session_path )
    end
  end

  describe "GET #index" do
    let!(:user) { create(:user) }
    let!(:current_week) { create(:current_week, user: user) }
    let!(:prev_week) { create(:old_week, user: user) }
    let!(:prev_prev_week) { create(:older_week, user: user) }

    before :each do
      login_with user
      get :index
    end

    it "set latest week to @current_week" do
      expect( assigns(:current_week) ).to eq current_week
    end

    it "load 10 latest weeks to @weeks" do
      expect( assigns(:weeks) ).to eq Week.where(user: user).by_date.limit(10)
    end

    it "set nil to @next_week" do
      expect( assigns(:next_week) ).to eq nil
    end

    it "set previous week to @prev_week" do
      expect( assigns(:prev_week) ).to eq prev_week
    end 
  end

  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:current_week) { create(:current_week, user: user) }
    let!(:prev_week) { create(:old_week, user: user) }
    let!(:prev_prev_week) { create(:older_week, user: user) }

    context "not last week" do
      before :each do
        login_with user
        get :show, :id => prev_week.id
      end

      it "set showed week to @current_week" do
        expect( assigns(:current_week) ).to eq prev_week
      end

      it "load 10 latest weeks to @weeks" do
        expect( assigns(:weeks) ).to eq Week.where(user: user).by_date.limit(10)
      end

      it "set next week to @next_week" do
        expect( assigns(:next_week) ).to eq current_week
      end

      it "set previous week to @prev_week" do
        expect( assigns(:prev_week) ).to eq prev_prev_week
      end
    end

    context "last week" do
      before :each do
        login_with user
        get :show, :id => prev_prev_week.id
      end

      it "set showed week to @current_week" do
        expect( assigns(:current_week) ).to eq prev_prev_week
      end

      it "load 10 latest weeks to @weeks" do
        expect( assigns(:weeks) ).to eq Week.where(user: user).by_date.limit(10)
      end

      it "set next week to @next_week" do
        expect( assigns(:next_week) ).to eq prev_week
      end

      it "set nil to @prev_week" do
        expect( assigns(:prev_week) ).to eq nil
      end
    end

    context "nonexistent week" do
      before :each do
        login_with user
        get :show, :id => 9999
      end

      it "redirects to root with notice" do
        expect( flash[:notice] ).to eq "wrong week"
        expect( response ).to redirect_to( root_path )
      end
    end
  end

  describe "patch#update" do
    let!(:user) { create(:user) }
    let!(:current_week) { create(:current_week, user: user) }
    let!(:prev_week) { create(:old_week, user: user) }
    let(:hash) { hash = {}; Sector::KEYS.each {|i| hash[i] = 1}; hash }

    context "existing week" do
      before :each do
        login_with user
        request.env["HTTP_REFERER"] = "/weeks/#{prev_week.id}"
        patch :update, :id => prev_week.id, :week => {:lapa => hash}
        prev_week.reload
      end


      it "updates week lapa" do
        expect( prev_week.lapa ).to eq hash
      end

      it "redirects to full url" do
        expect( response ).to redirect_to( prev_week )
      end
    end

    context "nonexistent week" do
      before :each do
        login_with user
        request.env["HTTP_REFERER"] = "/weeks/9999"
        patch :update, :id => 9999, :week => {:lapa => hash}
        prev_week.reload
      end

      it "redirects to root with notice" do
        expect( flash[:notice] ).to eq "wrong lapa"
        expect( response ).to redirect_to( root_path )
      end
    end

  end
end
