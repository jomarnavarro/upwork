require_relative './page_object'
##
# Describes the Upwork Home Page
class UWHomePage < PageObject
  FREELANCERS_TYPE = 'freelancers'.freeze
  # object repository section
  define :search_txt, name: 'q'
  define :search_icon, xpath: '//*[contains(@class, "glyphicon")]'
  define :find_freelancers_lnk, xpath: '//a[@data-qa = "freelancer_value"]'
  define :find_jobs_lnk, xpath: '//a[@data-qa = "client_value"]'
  define :in_all_media_lnk, css: 'a[href*="inallmedia.com"]'

  ##
  # Searches for either freelancers or jobs.
  # Params:
  # - keyword: Job search to match.
  # - type: search type, either 'freelancers' or 'jobs'
  def search(keyword, type)
    click(:search_icon)
    click(:find_freelancers_lnk) if type == FREELANCERS_TYPE
    click(:find_jobs_lnk) unless type == FREELANCERS_TYPE
    puts "Selected search type: '#{type}'."
    input(:search_txt, keyword)
    puts "Typed '#{keyword}' into search field."
    submit(:search_txt)
    puts 'Submitted search field.'
    end_section
  end
end
