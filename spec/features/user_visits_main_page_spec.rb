require 'rails_helper'

feature "user visits main page", type: :feature do
  let!(:user) { create(:user) }
  let(:main_page) { MainPage.new }
  let(:login_page) { LoginPage.new }


  context "when user not authorised" do
    before do
      main_page.load
    end

    it "redirects to log in page" do
      expect(login_page).to be_displayed
    end

    it "redirects to main page after log in" do
      login_page.tap do |lp|
        lp.email.set user.email
        lp.password.set user.password
        lp.button.click
      end

      expect(main_page).to be_displayed
      expect(main_page.flash.msg.text).to eq I18n.translate("devise.sessions.signed_in")
      expect(main_page.navbar.user_name.text).to eq user.email
    end
  end

  context "when user authorised" do
    before do
      login_as( user, scope: :user )
      main_page.load
    end

    it "shows main page with authorised user" do
      expect(main_page).to be_displayed
      expect(main_page.navbar.user_name.text).to eq user.email
    end

    it "shows sectors header" do
      expect(main_page.sectors.names.map {|name| name.text}[2]).to eq I18n.translate("sector.id_3.name")
    end
  end
end
