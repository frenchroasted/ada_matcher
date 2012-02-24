require 'rubygems'
require 'ada_matcher'
require 'watir-webdriver'
require 'headless'

describe "AdaMatcher" do
  before(:all) do
    @project_base_path = File.expand_path File.dirname(__FILE__) << "../"
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

  it "should pass ADA compliant page" do
    @browser.goto "file://#{@project_base_path}/../resources/good_page.html"
    @browser.should meet_ada_requirements(:all)
  end

  it "should fail with bad image tags" do
    @browser.goto "file://#{@project_base_path}/../resources/bad_page.html"
    @browser.should_not meet_ada_requirements(:image_alt)
  end

  it "should fail with bad link tags" do
    @browser.goto "file://#{@project_base_path}/../resources/bad_page.html"
    @browser.should_not meet_ada_requirements(:link_title)
  end

  it "should fail with new window links without warnings" do
    @browser.goto "file://#{@project_base_path}/../resources/bad_page.html"
    @browser.should_not meet_ada_requirements(:link_window_warning)
  end

end
