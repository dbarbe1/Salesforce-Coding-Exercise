global class SampleProjectBatchUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start (Database.BatchableContext BC) {
        //query sampleobject where fibonacci isn't initialized
        string query = 'SELECT Id, numeric_value_display__c, upper_fibonacci__c, lower_fibonacci__c from sampleobject__c WHERE (lower_fibonacci__c= null OR upper_fibonacci__c= null)';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sampleobject__c> a){
        //list of fibonacci numbers
        List<Integer> fibonacci = new List<Integer>{0,1,2,3,5,8,13,21,34,55,89,144,233,377,610};
        
        //check each fibonacci number to see if it is the cloest to the numeric value of the sampleobject
        for (sampleobject__c i: a) {
            Decimal distanceAbove = null;
            Decimal distanceBelow = null;
            Decimal tempdistanceAbove = null;
            Decimal tempdistanceBelow = null;
            for (Integer j : fibonacci) {
            
                if ( i.numeric_value_display__c - j > 0 ){
                
                    tempdistanceBelow = i.numeric_value_display__c - j;
                    
                }else if ( j - i.numeric_value_display__c > 0 ){
                
                    tempdistanceAbove = j - i.numeric_value_display__c;
                    
                }else if ((i.numeric_value_display__c - j) == 0){
                    tempdistanceAbove = 0;
                    tempdistanceBelow = 0;
                }
                
                if(distanceAbove == null || tempdistanceAbove < distanceAbove)
                {
                    distanceAbove = tempdistanceAbove ;
                    System.debug('tempdistanceabove: ' + distanceAbove);
                }
                if(distanceBelow == null || tempdistanceBelow < distanceBelow)
                {
                    distanceBelow = tempdistanceBelow;
                }
                
            }
            System.debug('final distanceabove: ' + distanceAbove);
            //initialize lower and upper fibonacci numbers
            i.lower_fibonacci__c = i.numeric_value_display__c - distanceBelow;
            i.upper_fibonacci__c = i.numeric_value_display__c + distanceAbove;
        }
        update a;
    }
    
    global void finish (Database.BatchableContext BC) {
        System.debug('Batch Fibonacci Complete');
    }
}
