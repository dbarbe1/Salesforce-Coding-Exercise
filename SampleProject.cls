public class SampleProject{

    //input tied to inputfield and used as request field when submitting record, isbatchable tied to Batch Fibonacci button, numeric value referenced in Apex Table and used to submit record, inputlist is the list used to submit records via bulk DML
    public String input{ get; set; }
    public boolean isBatchable{ get; set; }
    public boolean isBatched{ get; set; }
    private Integer numeric_value{ get; set; }
    public List<sampleobject__c> inputlist{ get; set; }
    
    //constructor: will intiialize inputlist, numeric value to 1, and hides batch button
    public SampleProject() {
        isBatchable = false;
        isBatched = false;
        numeric_value = 1;
        System.debug('Constructor called, initializing list of Sample Objects');
        inputlist = new List<sampleobject__c>();
        System.debug('list: ' + inputlist);
    }
    
    //adds a new sampledata object and initializes the request field to the value of input. adds sampledata record to list.
    public void setinputlist() {
        System.debug('Set InputList Function Called, Adding Request to list...');
        sampleobject__c a = new sampleobject__c(request__c=input, numeric_value_display__c=numeric_value);
        System.debug('sampleobject: ' + a);
        inputlist.add(a);
        numeric_value++;
        System.debug('list: ' + inputlist);
        input = '';
    }
    
    //returns the current inputlist
    public List<sampleobject__c> getInputlist() {
        return inputlist;
    }
    
    //inserts list of sampledata records
    public PageReference createRecords() {
        System.debug('Create Records Function Called, Hashing Request and Inserting Records...');
        System.debug('Looping through list: ' + inputlist);
        //include hashed request in list before insert
        for(sampleobject__c i:inputlist){
            i.hashed_request__c = hashString(i.request__c);
            System.debug('Hashed Request Result: ' + i.hashed_request__c);
        }
        try {
            //DML insert
            insert inputlist;
            //set isBatchable to true to allow button to appear
            isBatchable = true;
            System.debug('List after Insert: ' + inputlist);
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
        } return null;
    }
    
    
    public PageReference checkBatch() {
        //include hashed request in list before insert
        if (isBatched = true){
            for(sampleobject__c i:inputlist){
                sampleobject__c temp = [SELECT Id, upper_fibonacci__c, lower_fibonacci__c FROM sampleobject__c WHERE Id =:i.Id LIMIT 1];
                i.upper_fibonacci__c= temp.upper_fibonacci__c;
                i.lower_fibonacci__c = temp.lower_fibonacci__c;
                System.debug('lower_fibonacci__c  Result: ' + i.lower_fibonacci__c);
                System.debug('upper_fibonacci__c  Result: ' + i.upper_fibonacci__c);
            }
        }
        return null;
    }
    
    //sends Batch Job to update records with upper and lower fibonacci values
    public PageReference batchFibonacci() {
        
        SampleProjectBatchUpdate a = new SampleProjectBatchUpdate();
        ID batchprocessid = database.executebatch(a);
        isBatched = true;
        checkBatch();
        return null;
    }
    
    //hashes request of sampledata, returns hashed string
    public string hashString(string key) {
        //SHA-512 hash
        Blob digest = Crypto.generateDigest('SHA-512', Blob.valueOf(key)); 
        //blob to string      
        String hashedstring= EncodingUtil.Base64Encode(digest);
        return hashedstring;
    }
   
}
