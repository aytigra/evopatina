require 'rails_helper'

RSpec.describe Week, type: :model do
  let!(:user) { create(:user) }
  let (:hash) { hash = {}; Sector.keys.each {|i| hash[i] = 0}; hash }

  context "last week" do

    it "makes new empty current week" do
      last_week = Week.last_week(user)
      expect( last_week.date ).to eq Date.today.at_beginning_of_week
    end

    it "sets empty sectors hash to progress" do
      last_week = Week.last_week(user)
      expect( last_week.progress ).to eq hash
    end

    it "sets empty sectors hash to lapa" do
      last_week = Week.last_week(user)
      expect( last_week.lapa ).to eq hash
    end

    it "gets existing current week" do
      current_week = create(:current_week, user: user)

      last_week = Week.last_week(user)

      expect( last_week ).to eq current_week
    end

    it "makes new week when existing last week not current" do
      old_week = create(:old_week, user: user)

      last_week = Week.last_week(user)

      expect( last_week ).not_to eq old_week
    end

    it "copy lapa from existing last week to current" do
      old_week = create(:old_week, user: user)
      older_week = create(:older_week, user: user)

      last_week = Week.last_week(user)

      expect( last_week.lapa ).to eq old_week.lapa
    end
  end

  context "lapa" do
    before do
      @week = Week.last_week(user)
    end

    it "is unset" do
      @week.lapa = hash
      expect( @week.lapa_unset? ).to eq true
    end

    it "is set" do
      @week.lapa = hash.map {|k,v| v = 1 }
      expect( @week.lapa_unset? ).to eq false
    end
  end

  context "progress ratio" do
    before do
      @week = Week.last_week(user)
    end

    it "handles division by zero" do
      @week.progress[3] = 1
      @week.lapa[3] = 0

      expect( @week.ratio(3) ).to eq 0
    end

    it "calculates ratio percentage" do
      @week.progress[3] = 3.5
      @week.lapa[3] = 7

      expect( @week.ratio(3) ).to eq 50
    end
  end

end
