Feature: Patients can edit their information
	As a patient or administrator
	I want to be able to edit my information

Scenario: Patient can edit their information
	Given I need a test patient
	Given I am on the home page
	When I follow "Patient"
	And I fill in "Email" with "test@activitytracker.com"
	And I fill in "Password" with "1234567890"
	And I press "Log in"
	And I follow "Edit"
	And I fill in "Name" with "successful_edit"
	And I fill in "patient_current_password" with "1234567890"
	And I press "Update"
	Then I should see "Hello successful_edit!"

Scenario: Administrator can edit their information
	Given I need an admin
	Given I am on the home page
	When I follow "Admin"
	And I fill in "Email" with "admin@activitytracker.com"
	And I fill in "Password" with "password"
	And I press "Log in"
	And I follow "Edit"
	And I fill in "Name" with "successful_edit"
	And I fill in "admin_current_password" with "password"
	And I press "Update"
	Then I should see "Hello successful_edit!"
