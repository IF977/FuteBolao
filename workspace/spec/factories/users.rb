FactoryGirl.define do
  
  sequence :email do |n|
    "email#{n}@bolao.dom"
  end

  factory :user do
    name "User test"
    email
    password "foobarpass"
    password_confirmation "foobarpass"

    factory :admin do
      admin true
    end

  end
end