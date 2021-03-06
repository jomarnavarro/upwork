require_relative './page_object'
##
# Describes the Upwork Candidate Profile Page
class UWCandidateProfilePage < PageObject
  FREELANCERS_TYPE = 'freelancers'.freeze
  # object repository section
  define :result_tiles, xpath: '//article'
  define :candidate_name_lbl, xpath: './/*[@id="optimizely-header-container-default"]//*[@itemprop="name"]'
  define :title_lbl, xpath: './/*[@id="optimizely-header-container-default"]//*[contains(@data-ng-bind-html,"getProfileTitle")]'
  define :hourly_rate_lbl, xpath:'.//cfe-profile-rate//*[@itemprop="pricerange"]'
  define :earnings_lbl, xpath: './/*[contains(@eo-tooltip, "Amount earned")]//*[@itemprop="pricerange"]'
  define :badge_img, xpath: './/*[contains(@class, "badge-top-rated")]'
  define :success_rate_lbl, xpath: './/cfe-job-success//h3[contains(text(), "%")]'
  define :location_lbl, xpath: './/*[@id="optimizely-header-container-default"]//*[@itemprop="country-name"]'
  define :desc_lbl, xpath: './/o-profile-overview[@words = 80]//*[@itemprop="description"]'
  define :skill_list_lbl, xpath: './/*[contains(@class, "o-profile-skills")]//a'

  ##
  # Returns a hash containing a candidate's profile information.
  def profile_info
    info = candidate_info(select(xpath: '//body'))
    end_section if info
    info
  end

  ##
  # Validates candidate;s profile information matches that captured in the search results page.
  # It outputs global results to console, stopping the script unless all validations are succesful.
  # Params:
  # - profile_info:  Hash containing candidate's profile information
  # - search_info:  Hash containing candidate's search results page information.
  def validate_candidate_data(profile_info, search_info)
    validation_result = [
      validate_string(profile_info, search_info,:name),
      validate_string(profile_info, search_info,:title),
      validate_string(profile_info, search_info,:hourly_rate),
      validate_string(profile_info, search_info,:earnings),
      validate_string(profile_info, search_info,:has_badge),
      validate_string(profile_info, search_info,:success_rate),
      validate_string(profile_info, search_info,:location),
      validate_description(profile_info, search_info, :description),
      validate_empty(profile_info, search_info,:skill_list)
    ].all?
    raise('Validation failed.') unless validation_result
    puts 'Random profile validation passed.' if validation_result
    end_section
  end

  ##
  # Validates description strings match by stripping both strings of anything other than
  # alphabetic characters.
  # Params:
  # - profile_info:  Hash containing candidate's profile information
  # - search_info:  Hash containing candidate's search results page information.
  # - field: field to compare, +:description+ in this case.
  def validate_description(profile_info, search_info, field)
    stripped_prof_info = profile_info[field].downcase.delete('^a-z')
    stripped_search_info = search_info[field].downcase.delete('^a-z')
    validation = stripped_prof_info.include?(stripped_search_info)
    puts "#{field} validation passed " if validation
    puts "#{field} validation failed " unless validation
    validation
  end

  ##
  # Validates general purpose data by matching strings exactly.
  # - profile_info:  Hash containing candidate's profile information
  # - search_info:  Hash containing candidate's search results page information.
  # - field: field to compare.
  def validate_string(profile_info, search_info, field)
    validation = profile_info[field] == search_info[field]
    puts "#{field} validation passed " if validation
    puts "#{field} validation failed " unless validation
    validation
  end

  ##
  # Validates skill list found in skills is a superset of those found during candidate search.
  # - profile_info:  Hash containing candidate's profile information
  # - search_info:  Hash containing candidate's search results page information.
  # - field: field to compare, skill list in this case.
  def validate_empty(profile_info, search_info, field)
    validation = (search_info[field] - profile_info[field]).empty?
    puts "#{field} validation passed " if validation
    puts "#{field} validation failed " unless validation
    validation
  end
end
