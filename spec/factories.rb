FactoryBot.define do
  factory :invitation do
    email { 'test@example.com' }
    expires_at { 1.week.from_now }
  end

  factory :user do
    email { "test@example.com" }
    username { "test" }
    password { "test1234" }
    password_confirmation { "test1234" }
  end

  factory :component do
    name { 'test component name' }
    description { 'test component description' }
  end

  factory :board do
    name { 'test board name' }
    description { 'test board description' }

    factory :board_with_components do
      transient do
        components_count { 15 }
      end

      after(:create) do |board, evaluator|
        create_list(:component, evaluator.components_count, boards: [board], user: board.user )
      end
    end

    trait :with_image do
      image { fixture_file_upload(
        Rails.root.join('spec', 'support', 'assets', 'test.png')
      )}
    end
  end
end
