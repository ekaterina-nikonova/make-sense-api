FactoryBot.define do
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
        create_list(:component, evaluator.components_count, boards: [board])
      end
    end
  end
end