## Upwork Sample script

This project is a project sample using the bare minimum automation with Selenium Ruby bindings.  

# Tools:
1. Ruby
2. Selenium Webdriver (only this one gem should used, no other ones)
3. Git/Github (this repo)

# Assumption:
 * Only individual candidate information is captured.  Whenever an agency presents a sample candidate, his info is not captured.


# Test case
1. Run `www.upwork.com
4. Focus onto "Find freelancers"
5. Enter `<keyword>` into the search input right from the dropdown and submit it (click on the magnifying glass button)
6. Parse the 1st page with search results: store info given on the 1st page of search results as structured data of any chosen by you type (i.e. hash of hashes or array of hashes, whatever structure handy to be parsed).
7. Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer) from parsed search results contains `<keyword>` Log in stdout which freelancers and attributes contain `<keyword>` and which do not.
9. Click on random freelancer's title
10. Get into that freelancer's profile
11. Check that each attribute value is equal to one of those stored in the structure created in #67
12. Check whether at least one attribute contains `<keyword>` 

# Requirements:
1. Browser and `<keyword>` should be configurable. The test should run with any combination of them.
2. Imagine that this is not such a simple tiny task, but a big scalable project which can be extended. Hence, implement appropriate OOP model/approach.
3. Prove model/approach chosen.
4. Every action, every comparison result, etc should be logged accordingly (i.e. to stdout). Goal: when your script passes - detailed test-case steps should be logged into STDOUT, so anybody can read it and repeat exactly the same steps and verifications but manually.
5. Your code should be well commented, so anybody can easily find out what action is being performed there and what is the purpose of those code blocks/methods/etc.
6. Names of the elements described in the test case can differ from what you can see on the site. The site is constantly evolving. But the idea and the flow is the same    

