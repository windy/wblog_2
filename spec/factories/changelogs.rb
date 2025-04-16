FactoryBot.define do
  factory :changelog do
    date { Date.today }
    category { "Feature Enhancements" }
    content { "* Added new feature\n* Improved existing functionality" }
  end
end
