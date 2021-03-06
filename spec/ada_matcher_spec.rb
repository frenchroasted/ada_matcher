require 'rubygems'
require 'ada_matcher'
require 'watir-webdriver'
require 'headless'

describe "AdaMatcher" do
  before(:all) do
    @project_base_path = File.expand_path File.dirname(__FILE__) << "../"
    @headless = Headless.new
    @headless.start
    # @browser = Watir::Browser.new
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
    @browser.should meet_ada_requirements
    # can also say:
    # @browser.should meet_ada_requirements(:all)
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

  it "should fail if H(1-6) tags appear out of sequence" do
    @browser.goto "file://#{@project_base_path}/../resources/bad_page.html"
    @browser.should_not meet_ada_requirements(:htag_hierarchy)
  end

  it "should fail if a Form field exists without a corresponding Label" do
    @browser.goto "file://#{@project_base_path}/../resources/bad_page.html"
    @browser.should_not meet_ada_requirements(:label_for)
  end

end
