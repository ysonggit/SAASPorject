Feature: display a list of available course meetings for a selected TA 

	 As a user
	 I want to see a list of course meetings when I select a TA
	 so that the listed meetings can be assigned to this TA

Background: course meetings and TA commitments have been added to activerecord
	    
	    Given the following course meeting exist:
	    | Course Number | Section Number | Start Time | End Time | Day | Instructor | More Info	|
	    | 101    	    | 001     	     | 08:30 	  | 09:20    | M   | TBA	| More about 101| 
	    | 101    	    | 001     	     | 08:30 	  | 09:20    | W   | TBA	| More about 101|    	  
	    | 101    	    | 001     	     | 08:30 	  | 09:20    | F   | TBA	| More about 101| 
	    | 101    	    | 002     	     | 08:30 	  | 09:20    | M   | TBA	| More about 101| 
	    | 101    	    | 002     	     | 08:30 	  | 09:20    | W   | TBA	| More about 101|    	  
	    | 101    	    | 002     	     | 08:30 	  | 09:20    | F   | TBA	| More about 101|    	  
	    | 101    	    | 003     	     | 08:30 	  | 09:20    | M   | TBA	| More about 101| 
	    | 101    	    | 003     	     | 08:30 	  | 09:20    | W   | TBA	| More about 101|    	  
	    | 101    	    | 003     	     | 08:30 	  | 09:20    | F   | TBA	| More about 101| 
	    | 101    	    | 004     	     | 10:05 	  | 11:40    | M   | TBA	| More about 101| 
	    | 101    	    | 004     	     | 10:05 	  | 11:40    | W   | TBA	| More about 101|    	  
	    | 101    	    | 004     	     | 03:30 	  | 04:20    | F   | TBA	| More about 101| 
	    | 513 	    | 001	     | 10:05	  | 11:20    | M   | TBA	| More about 513|
	    | 513	    | 001 	     | 10:05	  | 11:20    | W   | TBA	| More about 513|
	  
	    
	    Given the following TA commitments exist:
	    | Name    | Commitments | More Info		|
	    | A	      | 513	    | More about A 	|
	    
Scenario: 
	  When I click on the "More about A"
	  Then I should see the details of TA commitments
	  And I click "edit TA commitments"
	  
	  Then I should see "Edit current TA commitments"
	  And I click on "edit TA info"
	  And I should see "| 101    	    | 001     	     | 08:30 	  | 09:20    | M   | TBA	| More about 101| "
	  And I should see "| 101    	    | 001     	     | 08:30 	  | 09:20    | W   | TBA	| More about 101| "
	  And I should see "| 101    	    | 001     	     | 08:30 	  | 09:20    | F   | TBA	| More about 101| "
	  And I should see "| 101    	    | 002     	     | 08:30 	  | 09:20    | M   | TBA	| More about 101| "
	  And I should see "| 101    	    | 002     	     | 08:30 	  | 09:20    | W   | TBA	| More about 101| "
	  And I should see "| 101    	    | 002     	     | 08:30 	  | 09:20    | F   | TBA	| More about 101| "
	  And I should see "| 101    	    | 003     	     | 08:30 	  | 09:20    | M   | TBA	| More about 101| "
	  And I should see "| 101    	    | 003     	     | 08:30 	  | 09:20    | W   | TBA	| More about 101| "
	  And I should see "| 101    	    | 003     	     | 08:30 	  | 09:20    | F   | TBA	| More about 101| "
	  And I should see "| 101    	    | 004     	     | 03:30 	  | 04:20    | F   | TBA	| More about 101| "
