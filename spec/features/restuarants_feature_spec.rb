feature 'restaurants' do

  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restuarant' do
      visit restaurants_path
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'viewing restaurants' do
    let!(:kfc){ Restaurant.create name: 'KFC', description: "Finger lickin' good"}

    scenario 'lets a user view a restaurant' do
      visit restaurants_path
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(page).to have_content "Finger lickin' good"
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'when a user is not signed in' do
    let!(:kfc){ Restaurant.create name: 'KFC', description: "Finger lickin' good"}

    scenario 'can not create a restaurant' do
      visit restaurants_path
      click_link 'Add a restaurant'
      expect(page).not_to have_content "Name"
      expect(page).not_to have_content "Description"
      expect(page).to have_content "Log in"
    end

    scenario 'can not edit a restaurant' do
      visit restaurants_path
      expect(page).not_to have_content "Edit KFC"
    end

    scenario 'can not delete a restaurant' do
      visit restaurants_path
      expect(page).not_to have_content "Delete KFC"
    end
  end

  context 'when signed in' do
    before do
      sign_up
    end

    context 'creating restaurants' do
      scenario 'prompt user to fill out a form, then displays the new restaurant' do
        create_restaurant
        expect(page).to have_content 'KFC'
        expect(page).to have_content "OK"
        expect(current_path).to eq restaurants_path
      end

      context 'an invalid restaurant' do
        it 'does not let you submit a name that is too short' do
          visit restaurants_path
          create_restaurant name: 'kf'
          expect(page).not_to have_css 'h2', text: 'kf'
          expect(page).to have_content 'error'
        end
      end
    end


    context 'editing restaurants' do

      scenario 'let a user edit a restaurant they created' do
        create_restaurant
        visit restaurants_path
        click_link 'Edit KFC'
        fill_in :Name, with: 'Ken Fry Chuck'
        click_button 'Update Restaurant'
        expect(page).to have_content 'Ken Fry Chuck'
        expect(page).to have_content "OK"
        expect(current_path).to eq restaurants_path
      end
    end

    context 'deleting restaurants' do
      scenario 'let a user delete a restaurant they created' do
        create_restaurant
        visit restaurants_path
        click_link 'Delete KFC'
        expect(page).not_to have_content "Finger lickin' good"
        expect(page).to have_content "KFC no longer exists"
        expect(current_path).to eq '/restaurants'
      end
    end

    context "someone else's restaurant" do

      let(:user) {User.create(email: "bob@ross.com", password: '12345678',
                              password_confirmation: '12345678')}
      let!(:gbk) {user.restaurants.create(name: 'GBK')}


      scenario 'can not be edited' do
        visit restaurants_path
        click_link 'Edit GBK'
        expect(page).to have_content "User can not edit another user's Restaurant"
      end

      scenario 'can not be deleted' do
        visit restaurants_path
        click_link 'Delete GBK'
        expect(current_path).to eq restaurants_path
        expect(page).not_to have_content "GBK no longer exists"
        expect(page).to have_content "User can not delete another user's Restaurant"
      end
    end

  end
end
