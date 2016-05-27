module ApplicationHelper

  def sign_up email: 'abc@abc.com', password: 'testtest', confirm: 'testtest'
    visit '/'
    click_link 'Sign up'
    fill_in :Email, with: email
    fill_in :Password, with: password
    fill_in :'Password confirmation', with: confirm
    click_button 'Sign up'

  end

  def create_restaurant name: 'KFC', description: 'OK'
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in :Name, with: name
    fill_in :Description, with: description
    click_button 'Create Restaurant'
  end
end
