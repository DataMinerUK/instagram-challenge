require 'rails_helper'

feature 'Comments' do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:image) { FactoryGirl.create(:image, user_id: user.id) }

  context 'user not logged in' do
    scenario 'cannot add a comment to an image' do
      visit "/images/#{image.id}"
      click_link 'Add Comment'
      expect(current_url).to have_content '/users/sign_in'
    end
  end

  context 'user logged in' do
    scenario 'sees a form to add a comment to an image' do
      login_as(user, :scope => :user)
      visit "/images/#{image.id}"
      click_link 'Add Comment'
      expect(page).to have_selector 'form'
    end

    scenario 'after adding a comment can see it on the image page' do
      login_as(user, :scope => :user)
      visit "/images/#{image.id}"
      click_link 'Add Comment'
      fill_in 'comment[content]', with: 'So cute!'
      click_button 'Create Comment'
      expect(current_url).to have_content "/images/#{image.id}"
      expect(page).to have_content 'So cute!'
    end

  end

end
