require 'spec_helper'

feature "Signing in", :js => true do
  background do
    @admin = login_as_admin
  end

  scenario "Signing in with correct credentials" do

    visit root_path
    binding.pry

    expect(page).to have_content 'Hours Report'
  end
end
