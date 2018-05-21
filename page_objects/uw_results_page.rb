require_relative './page_object'
##
# Describes the Upwork Results Page
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

  ##
  # Determines whether the current page contains the captcha control.
  def captcha?
    catpcha_found = exists?(:captcha_lbl)
    puts 'Catpcha element found.  Exiting...' if catpcha_found
    end_section if catpcha_found
    catpcha_found
  end

  ##
  # Returns into an +Array+ of +Hash+es  containing candidates' data, including name, title, hourly rate,
  # earnings, whether s/he has top rated badge, success rate, location, description and a
  # +String+ +Array+ of skills.  It does not take companies into account, only individual
  # candidates.  It stops execution if a captcha challenge is found instead of a candidate
  # list, or whether there are no candidates in the page.
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

  ##
  # Determines whether a candidate is a company, by checking whether candidate's hourly rate
  # contains a salary range.
  def company?(candidate)
    info(candidate, :hourly_rate_lbl).include?(SALARY_RANGE)
  end

  ##
  # Checks which of a candidate's info contain the keyword, and which do not, and
  # outputs the information into stdout.
  # Params:
  # - candidates: +Array+ of +Hash+es containing every candidate's information.
  # - keyword:  searched keyword.
  def validate_keyword_on_candidates(candidates, keyword)
    puts "Validating keywords appear on candidate's keywords."
    candidates.each { |candidate| validate_keyword(candidate, keyword) }
    end_section
  end

  ##
  # Traverses a candidate's information to output those traits which have or don't
  # the searched keyword.
  # Params:
  # - candidate: +Hash+ containing candidate's information.
  # - keyword:  searched keyword.s
  def validate_keyword(candidate, keyword)
    puts "\n#{candidate[:name]}\nAttributes containing '#{keyword}': "
    candidate.each { |k, v| puts k if v.to_s.include?(keyword) }
    puts "Attributes not containing '#{keyword}':"
    candidate.each { |k, v| puts k unless v.to_s.include?(keyword)}
  end

  ##
  # Opens a candidate profile from a random number.
  # Params:
  # - candidates: +Hash+ containing every candidate's information.
  # - candidate_number: Random number
  def open_random_profile(candidates, candidate_number)
    puts "\nOpening random profile: #{candidates[candidate_number][:name]}"
    click(link_text: candidates[candidate_number][:name])
  end
end
