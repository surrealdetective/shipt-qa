class HomePage
  include Capybara::DSL
  attr_reader :page, :view

  def initialize(page, view='desktop')
    @page = page
    @view = view
  end

  def view_login
    within('nav .right') do
      click_on 'Log In'
    end
  end

  def self.visit
    Capybara.current_session.visit 'https://www.shipt.com/'
  end
  
end