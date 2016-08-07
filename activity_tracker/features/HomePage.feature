Feature: Activity Tracker home page exists
	As a patient or administrator
	So that I can see my logged in home page
	I want to see links for patient login and administrator login

Scenario: Home page exists
	Given I am on the home page
	Then I should see "Welcome to Activity Tracker!"
	Then I should see "Patient"
	Then I should see "Administrator"

Scenario: Patient link work
	Given I am on the home page
	When I follow "Patient"
	Then I should see "Log in"
	Then I should see "Email"
	Then I should see "Password"
	Then I should see "Remember me"
	Then I should see "Sign up"
	Then I should see "Forgot your password?"

Scenario: Administrator link work
	Given I am on the home page
	When I follow "Administrator"
	Then I should see "Log in"
	Then I should see "Email"
	Then I should see "Password"
	Then I should see "Remember me"

