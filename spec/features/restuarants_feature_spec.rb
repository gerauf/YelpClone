feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restuarant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'creating restaurants' do
    scenario 'prompt user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in :Name, with: 'KFC'
      fill_in :Description, with: "Finger lickin' good"
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(page).to have_content "Finger lickin' good"
      expect(current_path).to eq '/restaurants'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'

        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){ Restaurant.create name: 'KFC', description: "Finger lickin' good"}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content "Finger lickin' good"
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before {Restaurant.create name: 'KFC', description: "Finger lickin' good"}

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in :Name, with: 'Ken Fry Chuck'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Ken Fry Chuck'
      expect(page).to have_content "Finger lickin' good"
      expect(current_path).to eq '/restaurants'
    end
  end

  context 'deleting restaurants' do
    before {Restaurant.create name: 'KFC', description: "Finger lickin' good"}

    scenario 'user can destroy a restaurant' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content "Finger lickin' good"
      expect(page).to have_content "KFC no longer exists"
      expect(current_path).to eq '/restaurants'
    end
  end

end
