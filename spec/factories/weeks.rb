FactoryGirl.define do
  factory :week do
    date { Time.zone.now - 3.weeks }
    lapa { Hash[1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6] }
    progress { Hash[1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6] }
  end

end
