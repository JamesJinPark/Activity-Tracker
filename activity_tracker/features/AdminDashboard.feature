Feature: Admin dashboard works
	As an administrator
	I want to log into my account
	And see my Admin dashboard

Scenario: Administrator can remove patients 
	Given I need an admin
	Given I need a test patient
	Given I am on the home page
	When I follow "Administrator"
	Then I should see "Log in"
	And I fill in "Email" with "admin@activitytracker.com"
	And I fill in "Password" with "password"
	And I press "Log in"
	Then I should see "Hello Admin! Below are the users signed up for Activity Tracker."
	Then I should see "test_name"
	Then I should see "Remove Patient"
	When I follow "Remove Patient"
	Then I should not see "test_name"