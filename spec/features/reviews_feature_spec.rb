feature 'reviewing' do
  before { Restaurant.create name: 'KFC'}

  scenario 'reviews can only be made by signed in users' do
    visit '/restaurants'
    expect(page).not_to have_content 'Review KFC'
  end

  context "when logged in" do
    before do
      visit '/'
      click_link 'Sign up'
      fill_in :Email, with: 'test@example.com'
      fill_in :Password, with: 'testtest'
      fill_in :'Password confirmation', with: 'testtest'
      click_button 'Sign up'
    end

    scenario 'allows users to leave a review using a form' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in :Thoughts, with: 'groooooose'
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(current_path).to eq '/restaurants'
      expect(page).to have_content('groooooose')
    end
  end
end
