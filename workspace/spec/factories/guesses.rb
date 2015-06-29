FactoryGirl.define do
  
  factory :guess do
    user
    match
    goals_a 1
    goals_b 2
  end
  
end