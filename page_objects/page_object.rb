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
      description: description(elem, :desc_lbl),
      skill_list: skill_list_info(elem, :skill_list_lbl)
    }
    candidate_info.each { |k, v| puts "#{k.to_s}: #{v.to_s}" }
    candidate_info
  end

  def success_rate(elem, lbl)
    raw_success_rate = info_success_rate(elem, lbl) #info(elem, lbl)
    return raw_success_rate.first.split.first unless raw_success_rate.empty?
    success_rate = raw_success_rate.empty? ? '' : raw_success_rate.first.split.first
    success_rate
  end

  def info_success_rate(elem, lbl)
    succ_rate_elems = select_children(elem, lbl)
    succ_rate_elems.map(&:text).uniq - ['']
  end

  def description(elem, lbl)
    raw_desc = info(elem, :desc_lbl)
    description = raw_desc.end_with?(TAIL) ? raw_desc.slice(0, raw_desc.size - TAIL.length) : raw_desc
    description.gsub("\n", "")
  end

  def info(p_elem, c_desc)
    c_elem = select_child(p_elem, c_desc) if child_exists?(p_elem, c_desc)
    return c_elem.text if c_elem
    ''
  end

  def skill_list_info(p_elem, c_desc)
    elem_list = select_children(p_elem, c_desc)
    text_list = elem_list.map(&:text).reverse
    last_element = text_list.find_index('')
    return text_list.slice(0, last_element).uniq.reverse if last_element
    text_list.reverse
  end

  def end_section
    puts '#####################################################################'
  end
end
