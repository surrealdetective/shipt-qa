class LoginPage
  include Capybara::DSL
  attr_reader :page, :view

  def initialize(page, view='desktop')
    @page = page
    @view = view
  end

  def add_email(email)
    page.find_field('Email').set(email)
  end

  def add_password(password)
    page.find_field('Password').set(password)
  end

  def submit_form
    find_button('Log In').click
  end

  def self.visit
    Capybara.current_session.visit 'https://shop.shipt.com/login'
  end
end