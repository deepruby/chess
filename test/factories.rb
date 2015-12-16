FactoryGirl.define do
  factory :piece do
    x_position 1
    y_position 1
    color 'MyString'
    player_id 1
    game_id 1
    type ''
  end

  factory :game do
    name 'test'
    white_player_id '32'
  end

  factory :user do
    sequence :email do |n|
      "test#{n}@example.com"
    end
    sequence :username do |n|
      "grandmaster#{n}"
    end
    password 'supersecure'
    password_confirmation 'supersecure'
  end
end
