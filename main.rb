Dir["./page_objects/*.rb"].each { |file| require file}
Dir["./utils/*.rb"].each { |file| require file}
require 'selenium-webdriver'

before("Upwork Freelancer Search and profile verification test.")
ensure_page(UWHomePage)
@page.search(@config[:keyword], @config[:search_type])
ensure_page(UWResultsPage)
@candidates = @page.save_candidate_data
@page.validate_keyword_on_candidates(@candidates, @config[:keyword])
candidate_number = rand(@candidates.count)
@page.open_random_profile(@candidates, candidate_number)
ensure_page(UWCandidateProfilePage)
@candidate_profile_info = @page.profile_info
@page.validate_candidate_data(@candidate_profile_info, @candidates[candidate_number])
after