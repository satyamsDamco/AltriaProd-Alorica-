global class  BatchApexPurgeIntegrationLogRecords implements Database.Batchable<sObject>, Database.Stateful{

    global integer TotalRecordsChanged = 0;
    global integer TotalErrorRecordsChanged = 0;
    global Date startDate; 
    global Integer MonthCount = 0;
    global BatchApexPurgeIntegrationLogRecords (){
       
       PurgingMonth__c monthData = PurgingMonth__c.getInstance();
       
       if(monthData != null && monthData.Month_Count__c != null){
           MonthCount  = Integer.ValueOf(monthData.Month_Count__c);
       }else{
           MonthCount  = 24;
       }    
    }
    
    global database.querylocator start(Database.BatchableContext BC){  
       Date myDate = Date.newInstance(date.today().year(), date.today().month(), 1);
       
       startDate = myDate.addmonths(-MonthCount); 
       String strQuery = '';  
       if(!Test.isRunningTest()){ 
           strQuery = 'Select id from IntegrationLog__c where LastModifiedDate <: startDate';
       }else{
           strQuery = 'Select id from IntegrationLog__c  limit 1';
       }   
       return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<IntegrationLog__c> IntegrationLogList = (List<IntegrationLog__c>)scope;
        TotalRecordsChanged = TotalRecordsChanged + scope.size();
        Database.DeleteResult[] drIntegrationLogList = Database.delete(IntegrationLogList, false);
        
        List<id> idInteg =new List<id>();
        for(Database.DeleteResult dr : drIntegrationLogList) {
            if (dr.isSuccess()) {
               idInteg.add(dr.getId());     
            }else{
                List<Database.Error> errors = dr.getErrors();
                TotalErrorRecordsChanged = TotalErrorRecordsChanged+ errors.size();
            }
        }
        
        if(!idInteg.isEmpty())
            Database.EmptyRecycleBinResult[] emp4 = Database.emptyRecycleBin(idInteg);
        
    }
    
    global void finish(Database.BatchableContext BC) {       
       
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        Purge_Tracking__c purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorRecordsChanged, Object_Name__c = 'Integration Log', Status__c = job.Status,Total_Records__c = TotalRecordsChanged);
        
        insert purgeObj;               
    }    
}