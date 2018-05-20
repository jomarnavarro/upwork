require_relative './page_object'
# Takes care of google search steps and validations
class UWResultsPage < PageObject
  FREELANCERS_TYPE = 'freelancers'.freeze
  SALARY_RANGE = '-'.freeze
  # object repository section
  define :result_tiles, xpath: '//article'
  define :candidate_name_lbl, xpath: './/*[@data-qa="tile_name"]'
  define :title_lbl, xpath: './/*[@data-qa="tile_title"]'
  define :hourly_rate_lbl, xpath:'.//*[@data-freelancer-rate]//strong'
  define :earnings_lbl, xpath: './/*[@data-freelancer-earnings]//*[contains(text(), "$")]'
  define :badge_img, xpath: './/*[@data-freelancer-top-rated-badge]'
  define :success_rate_lbl, xpath: './/*[@data-freelancer-job-success-score]'
  define :location_lbl, xpath: './/*[@data-freelancer-location]'
  define :desc_lbl, xpath: './/*[@data-freelancer-description]'
  define :skill_list_lbl, xpath: './/span[text()]'
  define :captcha_lbl, xpath: '//h1[text() = "Please pass the challenge to continue."]'

  def captcha?
    catpcha_found = exists?(:captcha_lbl)
    puts 'Catpcha element found.  Exiting...' if catpcha_found
    end_section if catpcha_found
    catpcha_found
  end

  def save_candidate_data
    raise('Captcha found.') if captcha?
    puts "Saving candidate's information."
    candidates ||= []
    candidate_results = select_elements(:result_tiles)
    candidate_results.each do |candidate_elem|
      candidates.push(candidate_info(candidate_elem)) \
        unless company?(candidate_elem)
    end
    fail('No data found.') if candidates.empty?
    end_section
    candidates
  end

  def company?(candidate)
    info(candidate, :hourly_rate_lbl).include?(SALARY_RANGE)
  end

  def validate_keyword_on_candidates(candidates, keyword)
    puts "Validating keywords appear on candidate's keywords."
    candidates.each { |candidate| validate_keyword(candidate, keyword) }
    end_section
  end

  def open_random_profile(candidates, candidate_number)
    puts "\nOpening random profile: #{candidates[candidate_number][:name]}"
    click(link_text: candidates[candidate_number][:name])
  end

  def validate_keyword(candidate, keyword)
    puts "\n#{candidate[:name]}\nAttributes containing '#{keyword}': "
    candidate.each { |k, v| puts k if v.to_s.include?(keyword) }
    puts "Attributes not containing '#{keyword}':"
    candidate.each { |k, v| puts k unless v.to_s.include?(keyword)}
  end
end