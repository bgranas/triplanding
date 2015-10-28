require 'rails_helper'

feature "visiting the homepage" do
  scenario "the visitor sees TripHappy logo"
    visit home_path
    expect(page).to have_text
  end
end
