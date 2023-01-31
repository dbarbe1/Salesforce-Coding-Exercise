# Salesforce-Coding-Exercise

# Brief

1. Create a custom page component
2. The component should initially contain one empty input box
3. When the user enters a value in the input box and hits the "enter" key, the input should become readonly and a new line with another input should be created
4. The maximum amount of inputs allowed per page should be 10
5. A submit button should be placed at the bottom of the page which, when clicked, will send a request to an Apex controller with all the search terms
6. A custom object should be created to hold all the search terms and associate them with a request number/ID
7. The Apex controller should create the objects for this search request and add the hash (e.g. sha1) and numeric value (e.g. a = 1, b = 2) of each to the object
8. Once done, the results should be displayed alongside the search terms in the component without the user having to reload
9. When the results for this batch are ready, a button should appear called "Batch Fibonacci" that, when clicked, will call a batch job for all of these objects and find the closest fibonacci numbers above and below the numeric values for each object
10. When the batch is complete, the values should show on the page

# Deployment Notes

Requires creation of custom object sampleobject
- Fields:
- request__c : Text
- numeric_value_display__c : Number
- hashed_request__c : Long Text
- lower_fibonacci__c : Number
- upper_fibonacci__c : Number
