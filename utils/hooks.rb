##
# This is a minimal hooks file similar to that of Cucumber's hooks file.

##
# Initializes a page object.
def ensure_page(page_object_class)
  return if @page.is_a?(page_object_class)
  @page = page_object_class.new(@driver, @config)
end

##
# Runs a minimal configuration for test case.
def before(scenario_name)
  puts "Running #{scenario_name}"
  @driver = Selenium::WebDriver.for @config[:browser]
  @driver.navigate.to(@config[:url][:upwork])
end

##
# Quits the driver
def after
  @driver.quit
end
