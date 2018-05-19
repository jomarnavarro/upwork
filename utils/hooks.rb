def ensure_page(page_object_class)
    return if @page.is_a?(page_object_class)
    @page = page_object_class.new(@driver, @config)
end

def before(scenario_name)
  @driver = Selenium::WebDriver.for @config[:browser]
  @driver.navigate.to(@config[:url][:upwork])
end

def after
  @driver.quit
end
