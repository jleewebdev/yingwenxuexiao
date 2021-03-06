require "spec_helper"

feature "User comments on article", js: true do

  scenario "successful comment"do
    skip
    user = Fabricate(:user, name: "John Smith")
    article = Fabricate(:article, published: true)
    sign_in(user)
    comment_on_article(article)
    page_should_have("This is a great article")
    page_should_have("John Smith says")
  end

  scenario "unsuccessful comment" do
    skip
    user = Fabricate(:user, name: "John Smith")
    article = Fabricate(:article, published: true)
    sign_in(user)
    visit article_path(article)
    click_button "Create Comment"
    expect(page).to not_have_content("This is a great article")
    expect(page).to not_have_content("John Smith says")
  end

  scenario "user not logged in" do
    skip
    article = Fabricate(:article, published: true)
    visit article_path(article)
    page_should_have("You need to be signed in to write a comment")
  end
end

def comment_on_article(article)
  visit article_path(article)
  fill_in "comment_body", with: "This is a great article"
  click_button "Create Comment"
end

