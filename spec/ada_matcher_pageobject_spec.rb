require 'rubygems'
require 'ada_matcher'
require 'page-object'
require 'watir-webdriver'
require 'headless'

PROJECT_BASE_PATH = File.expand_path File.dirname(__FILE__)

class GoodPage
  include PageObject
end

class BadPage
  include PageObject
end


describe "PageObjectAdaMatcher" do
  before(:all) do
    @headless = Headless.new
    @headless.start
    @browser = Watir::Browser.new
  end

  after(:all) do
    @browser.close
    @headless.destroy
  end

  before(:each) do
  end

  after(:each) do
  end

  it "should pass ADA compliant page using page-object" do
    @browser.goto "file://#{PROJECT_BASE_PATH}/../resources/good_page.html"
    good_page = GoodPage.new(@browser)
    good_page.should meet_ada_requirements

    # can also say:
    # good_page.should meet_ada_requirements(:all)
  end

  it "should fail with bad image tags using page-object" do
    @browser.goto "file://#{PROJECT_BASE_PATH}/../resources/bad_page.html"
    bad_page = BadPage.new(@browser)
    bad_page.should_not meet_ada_requirements(:image_alt)
  end

  it "should fail with bad link tags using page-object" do
    @browser.goto "file://#{PROJECT_BASE_PATH}/../resources/bad_page.html"
    bad_page = BadPage.new(@browser)
    bad_page.should_not meet_ada_requirements(:link_title)
  end

  it "should fail with new window links without warnings using page-object" do
    @browser.goto "file://#{PROJECT_BASE_PATH}/../resources/bad_page.html"
    bad_page = BadPage.new(@browser)
    bad_page.should_not meet_ada_requirements(:link_window_warning)
  end

  it "should fail if H(1-6) tags appear out of sequence using page-object" do
    @browser.goto "file://#{PROJECT_BASE_PATH}/../resources/bad_page.html"
    bad_page = BadPage.new(@browser)
    bad_page.should_not meet_ada_requirements(:htag_hierarchy)
  end

  it "should fail if a Form field exists without a corresponding Label using page-object" do
    @browser.goto "file://#{PROJECT_BASE_PATH}/../resources/bad_page.html"
    bad_page = BadPage.new(@browser)
    bad_page.should_not meet_ada_requirements(:label_for)
  end

end
