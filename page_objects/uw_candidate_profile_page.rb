require_relative './page_object'
# Takes care of google search steps and validations
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

  def profile_info
    info = candidate_info(select(xpath: '//body'))
    end_section if info
    info
  end

  def validate_candidate_data(candidate_profile_info, candidate_search_info)
    validation_result = [
      validate_string(candidate_profile_info, candidate_search_info,:name),
      validate_string(candidate_profile_info, candidate_search_info,:title),
      validate_string(candidate_profile_info, candidate_search_info,:hourly_rate),
      validate_string(candidate_profile_info, candidate_search_info,:earnings),
      validate_string(candidate_profile_info, candidate_search_info,:has_badge),
      validate_string(candidate_profile_info, candidate_search_info,:location),
      validate_empty(candidate_profile_info, candidate_search_info,:skill_list)
    ].all?
    raise('Validation failed.') unless validation_result
    puts 'Random profile validation passed.' if validation_result
    end_section
  end

  def validate_string(candidate_profile_info, candidate_search_info, field)
    validation = candidate_profile_info[field] == candidate_search_info[field]
    puts "#{field} validation passed " if validation
    puts "#{field} validation failed " unless validation
    validation
  end

  def validate_empty(candidate_profile_info, candidate_search_info, field)
    validation = (candidate_search_info[field] - candidate_profile_info[field]).empty?
    puts "#{field} validation passed " if validation
    puts "#{field} validation failed " unless validation
    validation
  end
end
