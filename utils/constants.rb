##
# Contains data configuration for the test case.  I'd've used a yaml file, but no other
# gems were allowed.
@config = {
  url: {
    upwork: 'http://upwork.com'
  },
  keyword: 'Selenium',
  search_type: 'freelancers',
  browser: :chrome,
  timeouts: {
    short: 5,
    medium: 10,
    long: 15
  }
}
