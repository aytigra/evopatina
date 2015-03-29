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
      login_page.email.set user.email
      login_page.password.set user.password
      login_page.button.click

      expect(main_page).to be_displayed
      expect(main_page.flash.msg.text).to eq "Signed in successfully."
      expect(main_page.header.user_name.text).to eq user.email
    end
  end

  context "when user authorised" do
    before do
      login_as( user, scope: :user )
      main_page.load
    end

    it "shows main page with user" do
      expect(main_page).to be_displayed
      expect(main_page.header.user_name.text).to eq user.email
    end
  end
end
