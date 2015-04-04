FactoryGirl.define do
  factory :week do
    lapa { Hash[1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6] }
    progress { Hash[1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6] }

    factory :current_week do
      date { Date.today }
    end

    factory :old_week do
      date { Date.today - 1.week}
    end

    factory :older_week do
      lapa { Hash[1, 6, 2, 6, 3, 6, 4, 6, 5, 6, 6, 6] }
      date { Date.today - 2.week}
    end
  end
end
