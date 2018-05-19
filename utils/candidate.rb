require_relative '../utils/object_libs.rb'
##
# Class to represent a PageObject
class Candidate
  def initialize(driver, config)
    @driver = driver
    @config = config
    @window_handles = @driver.window_handles
  end

  def long_wait
    @wait ||= Selenium::WebDriver::Wait.new(timeout: @config[:timeouts][:long])
  end

  def wait
    @wait ||= Selenium::WebDriver::Wait.new(timeout: @config[:timeouts][:medium])
  end

  def short_wait
    @short_wait ||= Selenium::WebDriver::Wait.new(timeout: @config[:timeouts][:short])
  end
end
