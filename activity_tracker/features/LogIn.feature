Feature: Users can log in
	As a patient or administrator
	So that I can see my logged in home page
	I want to log into my account
	And see my logged in home page

Scenario: Sign up screen exists
	Given I am on the home page
	When I follow "Patient"
	When I follow "Sign up"
	Then I should see "Name"
	Then I should see "Dob"
	Then I should see "Mrn"
	Then I should see "Email"
	Then I should see "Password (6 characters minimum)"
	Then I should see "Password confirmation"
	Then I should see "Sign up"
	Then I should see "Log in"

Scenario: Patient can sign up and log in
	Given I am on the home page
	When I follow "Patient"
	When I follow "Sign up"
	And I fill in "Name" with "test_name"
	And I fill in "Dob" with "test_dob"
	And I fill in "Mrn" with "1234567890"
	And I fill in "Email" with "test@activitytracker.com"
	And I fill in "Password" with "1234567890"
	And I fill in "Password confirmation" with "1234567890"
	And I press "Sign up"
	Then I should see "Hello test_name!"
	When I follow "Log out"
	Then I should be on the home page
	Then I should see "Patient"
	When I follow "Patient"
	And I fill in "Email" with "test@activitytracker.com"
	And I fill in "Password" with "1234567890"
	And I press "Log in"
	Then I should see "Hello test_name!"
	Then I should see "DOB"
	Then I should see "test_dob"
	Then I should see "MRN"
	Then I should see "1234567890"
	Then I should see "Authorized Apps"
	Then I should see "None"

Scenario: Administrator can log in 
	Given I need an admin
	Given I am on the home page
	When I follow "Administrator"
	Then I should see "Log in"
	And I fill in "Email" with "admin@activitytracker.com"
	And I fill in "Password" with "password"
	And I press "Log in"
	Then I should see "Hello Admin!"