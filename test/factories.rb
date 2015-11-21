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
  end
end
