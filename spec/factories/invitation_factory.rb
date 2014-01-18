FactoryGirl.define do
  factory :role do
    id  1
    name "admin"
    title "role for admin"
    description "this user can do anything"
    the_role JSON.parse("{\"system\":{\"administrator\":true}}")
  end

  factory :user do
    id 1
    first_name "Eli"
    last_name "Kopter"
    email "eli.kopter@email.com"
    role_id 1
    employee_number 1
  end

  factory :invitation do
    recipient "eli.kopter@email.com"
    sender "eli.kopter@email.com"
    employee_number 1
  end
end
