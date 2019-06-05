require 'capybara/rspec'
require 'pages/home_page'
require 'pages/login_page'

describe 'Log in with email', :type => :feature, js: true do
  describe 'in desktop view' do
    scenario 'when successful' do
      HomePage.visit
      homepage = HomePage.new(page)
      homepage.view_login

      login_page = LoginPage.new(page)
      login_page.add_email('thefifth@gmail.com')
      login_page.add_password("Y]'G#E)\"4d|FB~XS8n")
      login_page.submit_form
      
      expect(page).to have_text "Account"
    end

    scenario 'when not successful' do
      LoginPage.visit
      login_page = LoginPage.new(page)

      # with blank form
      login_page.submit_form
      expect(page).to have_text "Email is required"
      expect(page).to have_text "Password is required"

      # with improper email
      login_page.add_email('@@@')
      login_page.submit_form
      expect(page).to have_button "Log In"      

      # with no password
      login_page.add_email('thefifth@gmail.com')
      login_page.submit_form
      expect(page).to have_text "Password is required"

      # with wrong password
      login_page.add_password('ddd')
      login_page.submit_form
      expect(page).to have_text "Invalid Username or Password"
    end
  end

  describe 'in mobile view' do
    xscenario 'when successful' do
    end

    xscenario 'when not successful' do
    end
  end

  describe 'from view sign up then view log in flow' do
    xscenario 'when successful' do
    end

    xscenario 'when not successful' do
    end
  end
end
