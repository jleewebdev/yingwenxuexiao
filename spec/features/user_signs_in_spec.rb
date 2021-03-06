require "spec_helper"

feature "User signs in" do

  scenario "successful sign in" do
    sign_in
    expect(page).to have_content("您已登入")
    # expect(page).to have_content("You are signed in.")
  end

  scenario "unsuccessful sign in" do
    sign_in_unsuccessfuly
    expect(page).to have_content("您的電子郵件或密碼有問題。")
    # expect(page).to have_content("There was something wrong with your email or password.")
  end
end

