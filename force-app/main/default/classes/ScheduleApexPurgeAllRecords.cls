global class ScheduleApexPurgeAllRecords implements Schedulable {

    global void execute(SchedulableContext ctx) {
        BatchApexPurgeAllRecords allRecords = new BatchApexPurgeAllRecords(); 
        database.executebatch(allRecords);
        
        BatchApexPurgeIntegrationLogRecords allIntegrationRecords = new BatchApexPurgeIntegrationLogRecords(); 
        database.executebatch(allIntegrationRecords);
    }    
}