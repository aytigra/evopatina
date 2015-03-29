FactoryGirl.define do
  factory :user do
    email 'test@example.com'
    password 'f4k3p455w0rd'
    password_confirmation 'f4k3p455w0rd'
    
    # if needed
    # is_active true

    before(:create) {|user| user.skip_confirmation! }
  end

end
