require_relative '../utils/object_libs.rb'
##
# Class to represent a PageObject
class PageObject
  include ObjectLibs

  TAIL = ' ...'.freeze

  class << self
    attr_accessor :definitions, :driver

    def define(name, selector)
      @definitions = {} unless defined?(@definitions)
      raise("Selector already defined: #{name}") if @definitions[name]
      @definitions[name.to_s] = selector
    end
  end

  def initialize(driver, config)
    @driver = driver
    @config = config
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

  ##
  # Returns a hash containing a candidate freelancer's info.  It also outputs said info into stdout
  # Params:
  # - elem: a container +WebElement+ for all candidate information +WebElement+s.
  def candidate_info(elem)
    puts "\nCandidate Information: "
    candidate_info = {
      name: info(elem, :candidate_name_lbl),
      title: info(elem, :title_lbl),
      hourly_rate: info(elem, :hourly_rate_lbl),
      earnings: info(elem, :earnings_lbl),
      has_badge: child_exists?(elem, :badge_img),
      success_rate: success_rate(elem, :success_rate_lbl),
      location: info(elem, :location_lbl),
      description: description(elem),
      skill_list: skill_list_info(elem, :skill_list_lbl)
    }
    candidate_info.each { |k, v| puts "#{k.to_s}: #{v.to_s}" }
    candidate_info
  end

  ##
  # Returns a candidate's success rate for both the +UWSearchResultsPage+ and the
  # +UWHomePage+.  It takes into account that for the later, there are two +WebElement+s
  # that carry the information, but one is blank.
  # Params:
  # elem: Container +WebElement+ for the Success Rate +WebElement+
  # lbl: +Hash+ containing the Success Rate locator.
  def success_rate(parent_elem, locator)
    raw_success_rate = info_success_rate(parent_elem, locator)
    # raw_success_rate contains a list of strings, hopefully with one element,
    # with the format ["XX% success"]
    return raw_success_rate.first.split.first unless raw_success_rate.empty?
    success_rate = raw_success_rate.empty? ? '' : raw_success_rate.first.split.first
    success_rate
  end

  ##
  # Returns a list of strings (hopefully with one element) in the format ["XX% success"]
  # Params:
  # elem: Container +WebElement+ for the Success Rate +WebElement+
  # lbl: +Hash+ containing the Success Rate locator.
  def info_success_rate(elem, lbl)
    succ_rate_elems = select_children(elem, lbl)
    succ_rate_elems.map(&:text).uniq - ['']
  end

  ##
  # Returns a candidate's description for both the +UWSearchResultsPage+ and the
  # +UWHomePage+.
  # Params:
  # elem: Container +WebElement+ for the description +WebElement+
  def description(elem)
    raw_desc = info(elem, :desc_lbl)
    description = raw_desc.end_with?(TAIL) ? raw_desc.slice(0, raw_desc.size - TAIL.length) : raw_desc
    description.gsub("\n", "")
  end

  ##
  # Returns an element's text information, used for most candidate info, except its
  # success rate, description and skill list.
  # Params:
  # p_elem: Container +WebElement+ for most +WebElement+s, unless mentioned above).
  # c_desc: +Hash+ containing the Success Rate locator.
  def info(p_elem, c_desc)
    c_elem = select_child(p_elem, c_desc) if child_exists?(p_elem, c_desc)
    return c_elem.text if c_elem
    ''
  end

  ##
  # Returns an candidate's skill list as an +Array+ of +Strings+
  # Params:
  # p_elem: Container +WebElement+ for the Skill List +WebElement+
  # c_desc: +Hash+ containing the Success Rate locator.
  def skill_list_info(p_elem, c_desc)
    elem_list = select_children(p_elem, c_desc)
    text_list = elem_list.map(&:text).reverse
    last_element = text_list.find_index('')
    return text_list.slice(0, last_element).uniq.reverse if last_element
    text_list.reverse
  end

  ##
  # Outputs a series of Pound Signs to separate steps in stdout.
  def end_section
    puts '#####################################################################'
  end
end
