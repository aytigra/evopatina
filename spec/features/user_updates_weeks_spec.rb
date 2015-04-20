require 'rails_helper'
RSpec.configure do |config|
  config.include WeeksHelper
end
feature "user updates week", type: :feature do
  describe "navigating weeks" do

    let!(:user) { create(:user) }
    let!(:current_week) { create(:current_week, user: user) }
    let!(:prev_week) { create(:old_week, user: user) }
    let!(:prev_prev_week) { create(:older_week, user: user) }
    let(:main_page) { MainPage.new }
    let(:hash) { hash = {}; Sector.keys.each {|i| hash[i] = 8}; hash }


    before do
      login_as( user, scope: :user )
    end

    it "navigates to prev week by prev-link button", js: true do
      main_page.load
      #save_screenshot('/vagrant/screenshot.png')
      main_page.content.current.prev_link.click
      expect( main_page.content.current.week_dates.text ).to eq week_begin_end_text(prev_week)
    end

    it "navigates to prev week by weeks list", js: true do
      main_page.load
      main_page.weeks_tabs.show_list.click

      expect( main_page.content.list.week_links[1].text ).to eq week_begin_end_text(prev_week)

      main_page.content.list.week_links[1].click

      expect( main_page.content.current.week_dates.text ).to eq week_begin_end_text(prev_week)
    end

    it "updates week lapa of previous week", js: true do
      main_page.load
      main_page.content.current.tap do |cr|
        cr.prev_link.click
        cr.lapa_form_btn.click
        cr.lapa_form.inputs.each do |input|
          input.set 8
        end
        cr.lapa_form.submit.click
      end
      prev_week.reload

      expect( prev_week.lapa ).to eq hash
      expect( main_page.content.current.progress[3].text ).to eq "4/8"
    end
  end
end
