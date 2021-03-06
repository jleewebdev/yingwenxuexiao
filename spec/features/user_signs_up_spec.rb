require "spec_helper"

feature "User signs up" do
  before do
    Video.create(title: "How to take classes", url: "test")
    Video.create(title: "Sign Up", url: "test")
  end

  scenario "successful sign up" do
    sign_up
    expect(page).to have_content("您已成功註冊。您現在已經登錄。")
    # expect(page).to have_content("You have successfully registered. You are now logged in.")
  end

  scenario "user signs up with a free account with affiliate link and is associated with the link" do
    affiliate = Fabricate(:affiliate)
    affiliate_link = Fabricate(:affiliate_link, affiliate_id: affiliate.id, code: "SPECIAL")
    visit "/signup/" + affiliate_link.code
    fill_in "user_email", with: "Johnsmith@google.com"
    fill_in "user_name", with: "Dr. John Smith"
    fill_in "user_password", with: "neatpassword123"
    click_button "Sign Up"
    expect(User.last.affiliate_link_id).to eq(affiliate_link.id)
  end

  scenario "user signs up with a free account with affiliate link and is associated with the link, case insensitive " do
    affiliate = Fabricate(:affiliate)
    affiliate_link = Fabricate(:affiliate_link, affiliate_id: affiliate.id, code: "SPECIAL")
    visit "/signup/" + affiliate_link.code.downcase
    fill_in "user_email", with: "Johnsmith@google.com"
    fill_in "user_name", with: "Dr. John Smith"
    fill_in "user_password", with: "neatpassword123"
    click_button "Sign Up"
    expect(User.last.affiliate_link_id).to eq(affiliate_link.id)
  end

  scenario "user signs up with a free account with affiliate link and is associated with the link, case insensitive_2 " do
    affiliate = Fabricate(:affiliate)
    affiliate_link = Fabricate(:affiliate_link, affiliate_id: affiliate.id, code: "SPECIAL")
    visit "/signup/" + "speCIAL"
    fill_in "user_email", with: "Johnsmith@google.com"
    fill_in "user_name", with: "Dr. John Smith"
    fill_in "user_password", with: "neatpassword123"
    click_button "Sign Up"
    expect(User.last.affiliate_link_id).to eq(affiliate_link.id)
  end

  scenario "user signs up with a free account with affiliate link and is associated with the link" do
    affiliate = Fabricate(:affiliate)
    affiliate_link = Fabricate(:affiliate_link, affiliate_id: affiliate.id, code: "SPECIAL")
    visit "/signup/" + affiliate_link.code
    fill_in "user_email", with: "Johnsmith@google.com"
    fill_in "user_name", with: "Dr. John Smith"
    fill_in "user_password", with: "neatpassword123"
    click_button "Sign Up"
    expect(User.last.affiliate_link_id).to eq(affiliate_link.id)
  end

    scenario "user signs up with a free account with a non-active affiliate link is not associated with the link" do
    affiliate = Fabricate(:affiliate)
    affiliate_link = Fabricate(:affiliate_link, affiliate_id: affiliate.id, code: "SPECIAL", active: false)
    visit "/signup/" + affiliate_link.code
    fill_in "user_email", with: "Johnsmith@google.com"
    fill_in "user_name", with: "Dr. John Smith"
    fill_in "user_password", with: "neatpassword123"
    click_button "Sign Up"
    expect(User.last.affiliate_link_id).to eq(nil)
  end




  scenario "user tries to upgrade without having an account" do
    visit upgrade_path
    expect(page).to have_content("註冊")
  end

  scenario "unsuccessful sign up" do
    sign_up_unsuccessfuly
    expect(page).to have_content("您的帳戶未創建。")
    # expect(page).to have_content("Your account was not created.")
  end

end

def sign_up
  visit sign_out_path
  visit sign_up_path
  fill_in "user_email", with: "Johnsmith@google.com"
  fill_in "user_name", with: "Dr. John Smith"
  fill_in "user_password", with: "neatpassword123"
  click_button "Sign Up"
end

def sign_up_unsuccessfuly
  visit sign_out_path
  visit sign_up_path
  fill_in "user_email", with: "Johns@.com"
  fill_in "user_name", with: "D"
  click_button "Sign Up"
end


