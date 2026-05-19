global class  BatchApexPurgeAllRecords implements Database.Batchable<sObject>, Database.Stateful{

    global integer TotalIssueRecordsChanged = 0;
    global integer TotalStoreRecordsChanged = 0;
    global integer TotalSurveyIssueRecordsChanged = 0;
    global integer TotalAttachmentRecordsChanged = 0;
    global integer TotalReimbursementRecordsChanged = 0;
    global integer TotalIssueAdjustmentRecordsChanged = 0;
    global integer TotalContactRecordsChanged = 0;
    global integer TotalCorrespondenceRecordsChanged = 0;
    global integer TotalTransactionRecordsChanged = 0;
    global integer TotalTransactionHistoryRecordsChanged = 0;
    
    global integer TotalErrorIssueRecordsChanged = 0;
    global integer TotalErrorStoreRecordsChanged = 0;
    global integer TotalErrorSurveyIssueRecordsChanged = 0;
    global integer TotalErrorAttachmentRecordsChanged = 0;
    global integer TotalErrorReimbursementRecordsChanged = 0;
    global integer TotalErrorIssueAdjustmentRecordsChanged = 0;
    global integer TotalErrorContactRecordsChanged = 0;
    global integer TotalErrorCorrespondenceRecordsChanged = 0;
    global integer TotalErrorTransactionRecordsChanged = 0;
    global integer TotalErrorTransactionHistoryRecordsChanged = 0;
    
    global Date startDate; 
    global Integer MonthCount = 0; 
    global BatchApexPurgeAllRecords(){
        
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
           strQuery = 'Select id,ContactId,Contact.Last_Modified_DateTime__c From Case where FeedLastModifiedDate__c < :startDate';
       }else{
           strQuery = 'Select id,ContactId,Contact.Last_Modified_DateTime__c From Case limit 1';
       }
       return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Case> caseList = (List<Case>)scope;
        TotalIssueRecordsChanged = TotalIssueRecordsChanged + scope.size();
        Set<Id>  contIds = new Set<Id>();
        Set<Id>  issueIds = new Set<Id>();
        for(Case cObj :caseList){
            issueIds.add(cObj.id); 
            if(!Test.isRunningTest()){
                if(cObj.ContactId != null && cObj.Contact.Last_Modified_DateTime__c < startDate)
                contIds.add(cObj.ContactId);
            }else{
                if(cObj.ContactId != null)
                contIds.add(cObj.ContactId);           
            }
        }
        list<Contact> lstConsumerWithoutIssue = [select Id from Contact where Id NOT In (select ContactId from Case)];
        if(lstConsumerWithoutIssue != null && lstConsumerWithoutIssue.size() > 0){
            for(Contact con : lstConsumerWithoutIssue){
                contIds.add(con.id);
            }
        }
        if(!contIds.isEmpty()){
            List<Case> caseNewList = New List<Case>();
            if(!Test.isRunningTest()){ 
                caseNewList = New List<Case>([Select id, ContactId from Case where Contactid in:contIds and FeedLastModifiedDate__c >=: startDate]);
            }else{
                caseNewList = New List<Case>([Select id, ContactId from Case where Contactid in:contIds]);
            }
            if(!caseNewList.isEmpty()){
                for(Case c: caseNewList){
                    if(contIds.contains(c.ContactId)){
                        contIds.remove(c.ContactId);
                    }
                }
            }        
        }
        /* Store Information Start */
        List<Store__c> storeList = new List<Store__c>([Select id from Store__c where Issue__c in :issueIds]);
        
        TotalStoreRecordsChanged = TotalStoreRecordsChanged + storeList.size();
        
        Database.DeleteResult[] drstoreList = Database.delete(storeList, false);
        
        List<id> idStore =new List<id>();
        for(Database.DeleteResult dr : drstoreList) {
            if (dr.isSuccess()) {
               idStore.add(dr.getId());     
            }else{
                List<Database.Error> errors = dr.getErrors();
                TotalErrorStoreRecordsChanged = TotalErrorStoreRecordsChanged + errors.size();
            }
        }
        if(!idStore.isEmpty())
            Database.EmptyRecycleBinResult[] emp = Database.emptyRecycleBin(idStore);

        /* Store Information End */
        
        /* Attachment Information Start */
        List<Attachment_Detail__c> attachList = new List<Attachment_Detail__c>([Select id from Attachment_Detail__c where Issue__c in :issueIds]);
        
        TotalAttachmentRecordsChanged = TotalAttachmentRecordsChanged + attachList.size();
        
        Database.DeleteResult[] drattachList = Database.delete(attachList, false);
        List<id> idAtt =new List<id>();
        for(Database.DeleteResult dr : drattachList) {
            if (dr.isSuccess()) {
               idAtt.add(dr.getId());     
            }else{
                List<Database.Error> errors = dr.getErrors();
                TotalErrorAttachmentRecordsChanged = TotalErrorAttachmentRecordsChanged + errors.size();
            }
        }
        
        if(!idAtt.isEmpty())
            Database.EmptyRecycleBinResult[] emp2 = Database.emptyRecycleBin(idAtt);

        /* Attachment Information End */
        
        
        /* Reimbursement Information Start */
        List<Reimbursement__c> reimbursementList = new List<Reimbursement__c>([Select id from Reimbursement__c where Issue__c in :issueIds]);
        
        TotalReimbursementRecordsChanged = TotalReimbursementRecordsChanged + reimbursementList.size();
        
        Database.DeleteResult[] drreimbursementList = Database.delete(reimbursementList, false);
        List<id> idRem =new List<id>();
        for(Database.DeleteResult dr : drreimbursementList) {
            if (dr.isSuccess()) {
               idRem.add(dr.getId());     
            }else{
                List<Database.Error> errors = dr.getErrors();
                TotalErrorReimbursementRecordsChanged = TotalErrorReimbursementRecordsChanged + errors.size();
            }
        }
        
        if(!idRem.isEmpty())
            Database.EmptyRecycleBinResult[] emp3 = Database.emptyRecycleBin(idRem);

        /* Reimbursement Information End */
        
        
        /* SurveyIssue Information Start */
        List<Survey_Issue__c> issueSurveyList = new List<Survey_Issue__c>([Select id from Survey_Issue__c where Issue__c in :issueIds]);
        
        TotalSurveyIssueRecordsChanged = TotalSurveyIssueRecordsChanged + issueSurveyList.size();
        
        Database.DeleteResult[] drissueSurveyList = Database.delete(issueSurveyList, false);
        List<id> idSurvey =new List<id>();
        for(Database.DeleteResult dr : drissueSurveyList) {
            if (dr.isSuccess()) {
               idSurvey.add(dr.getId());     
            }else{
                List<Database.Error> errors = dr.getErrors();
                TotalErrorSurveyIssueRecordsChanged = TotalErrorSurveyIssueRecordsChanged + errors.size();
            }
        }
        
        if(!idSurvey.isEmpty())
            Database.EmptyRecycleBinResult[] emp4 = Database.emptyRecycleBin(idSurvey);

        /* SurveyIssue Information End */
        
        /* Issue Adjustment Information Start */
        List<Issue_Adjustment__c> issueAdjustmentList = new List<Issue_Adjustment__c>([Select id from Issue_Adjustment__c 
                                                                                       where LastModifiedDate <: startDate 
                                                                                       or Issue__c in :issueIds]);
        
        TotalIssueAdjustmentRecordsChanged = TotalIssueAdjustmentRecordsChanged + issueAdjustmentList.size();
        
        Database.DeleteResult[] drissueAdjustmentList = Database.delete(issueAdjustmentList, false);
        List<id> idIssueAd =new List<id>();
        for(Database.DeleteResult dr : drissueAdjustmentList) {
            if (dr.isSuccess()) {
               idIssueAd.add(dr.getId());     
            }else{
                List<Database.Error> errors = dr.getErrors();
                TotalErrorIssueAdjustmentRecordsChanged = TotalErrorIssueAdjustmentRecordsChanged + errors.size();
            }
        }
        
        if(!idIssueAd.isEmpty())
            Database.EmptyRecycleBinResult[] emp5 = Database.emptyRecycleBin(idIssueAd);

        /* Issue Adjustment Information End */        
                
        if(!contIds.isEmpty()){

            /* Correspondence & Fulfilment Information Start */
            List<Correspondence_Fulfilment__c> correspondenceList = new List<Correspondence_Fulfilment__c>([Select id from Correspondence_Fulfilment__c where Contact__c in :contIds]);
            
            TotalCorrespondenceRecordsChanged = TotalCorrespondenceRecordsChanged + correspondenceList.size();
            
            Database.DeleteResult[] drcorrespondenceList = Database.delete(correspondenceList, false);
            List<id> idCorr =new List<id>();
            for(Database.DeleteResult dr : drcorrespondenceList) {
                if (dr.isSuccess()) {
                   idCorr.add(dr.getId());     
                }else{
                    List<Database.Error> errors = dr.getErrors();
                    TotalErrorCorrespondenceRecordsChanged = TotalErrorCorrespondenceRecordsChanged + errors.size();
                }
            }
            
            if(!idCorr.isEmpty())
                Database.EmptyRecycleBinResult[] emp6 = Database.emptyRecycleBin(idCorr);
            
            /* Correspondence & Fulfilment Information End */
            
           
            List<Contact> contList = new List<Contact>([Select id from Contact Where id in :contIds]);
            TotalContactRecordsChanged = TotalContactRecordsChanged+ contList.size();    
           
            List<Transaction_Management__c> tranList = new List<Transaction_Management__c>([Select id from Transaction_Management__c Where Contact__c in : contIds]);
            TotalTransactionRecordsChanged = TotalTransactionRecordsChanged + tranList.size();
            
            List<Transaction_Management_History__c> tranHistoryList = new List<Transaction_Management_History__c>([Select id from Transaction_Management_History__c Where Transaction_Management__c in : tranList]);        
            TotalTransactionHistoryRecordsChanged = TotalTransactionHistoryRecordsChanged + tranHistoryList.size();
            
            Database.DeleteResult[] drtranHistoryList = Database.delete(tranHistoryList, false);
            List<id> idTH =new List<id>();
            for(Database.DeleteResult dr : drtranHistoryList) {
                if (dr.isSuccess()) {
                   idTH.add(dr.getId());     
                }else{
                    List<Database.Error> errors = dr.getErrors();
                    TotalErrorTransactionHistoryRecordsChanged = TotalErrorTransactionHistoryRecordsChanged + errors.size();
                }
            }
            
            if(!idTH.isEmpty())
                Database.EmptyRecycleBinResult[] emp8 = Database.emptyRecycleBin(idTH);
            
           
            /* Transaction & Transaction History Information End */   
            
            Database.DeleteResult[] drcaseList = Database.delete(caseList, false);
            List<id> idIssue =new List<id>();    
            for(Database.DeleteResult dr : drcaseList) {
                if (dr.isSuccess()) {
                   idIssue.add(dr.getId());     
                }else{
                    List<Database.Error> errors = dr.getErrors();
                    TotalErrorIssueRecordsChanged = TotalErrorIssueRecordsChanged + errors.size();
                }
            }
            
            if(!idIssue.isEmpty())
                Database.EmptyRecycleBinResult[] emp10 = Database.emptyRecycleBin(idIssue);
           
            Database.DeleteResult[] drtranList = Database.delete(tranList, false);
            List<id> idTM =new List<id>();
            for(Database.DeleteResult dr : drtranList) {
                if (dr.isSuccess()) {
                   idTM.add(dr.getId());     
                }else{
                    List<Database.Error> errors = dr.getErrors();
                    TotalErrorTransactionRecordsChanged = TotalErrorTransactionRecordsChanged + errors.size();
                }
            }
            
            if(!idTM.isEmpty())
                Database.EmptyRecycleBinResult[] emp9 = Database.emptyRecycleBin(idTM);     
            
            Database.DeleteResult[] drcontList  = Database.delete(contList, false);
            List<id> idCont =new List<id>();
            for(Database.DeleteResult dr : drcontList) {
                if (dr.isSuccess()) {
                   idCont.add(dr.getId());     
                }else{
                    List<Database.Error> errors = dr.getErrors();
                    TotalErrorContactRecordsChanged = TotalErrorContactRecordsChanged + errors.size();
                }
            }
            
             if(!idCont.isEmpty())
                Database.EmptyRecycleBinResult[] emp7 = Database.emptyRecycleBin(idCont);    
                           
        }else{
        
            List<Transaction_Management_History__c> tranHistoryList = new List<Transaction_Management_History__c>([Select id from Transaction_Management_History__c Where Issue__c in : issueIds]);        
            
        
            TotalTransactionHistoryRecordsChanged = TotalTransactionHistoryRecordsChanged + tranHistoryList.size();
            
            Database.DeleteResult[] drtranHistoryList = Database.delete(tranHistoryList, false);
            List<id> idTH =new List<id>();
            for(Database.DeleteResult dr : drtranHistoryList) {
                if (dr.isSuccess()) {
                   idTH.add(dr.getId());     
                }else{
                    List<Database.Error> errors = dr.getErrors();
                    TotalErrorTransactionHistoryRecordsChanged = TotalErrorTransactionHistoryRecordsChanged + errors.size();
                }
            }
            
            if(!idTH.isEmpty())
                Database.EmptyRecycleBinResult[] emp9 = Database.emptyRecycleBin(idTH);
            
            
            Database.DeleteResult[] drcaseList = Database.delete(caseList, false);
            List<id> idIssue =new List<id>();    
            for(Database.DeleteResult dr : drcaseList) {
                if (dr.isSuccess()) {
                   idIssue.add(dr.getId());     
                }else{
                    List<Database.Error> errors = dr.getErrors();
                    TotalErrorIssueRecordsChanged = TotalErrorIssueRecordsChanged + errors.size();
                }
            }
            
            if(!idIssue.isEmpty())
                Database.EmptyRecycleBinResult[] emp10 = Database.emptyRecycleBin(idIssue);
        
        } 
    }
    
    global void finish(Database.BatchableContext BC) {
       
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
        
        List<Purge_Tracking__c> purgeList = new List<Purge_Tracking__c>();
        
        Purge_Tracking__c purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorIssueRecordsChanged, 
                                                           Object_Name__c = 'Issue', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalIssueRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorStoreRecordsChanged, 
                                                           Object_Name__c = 'Store', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalStoreRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorSurveyIssueRecordsChanged, 
                                                           Object_Name__c = 'Survey Issue', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalSurveyIssueRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorAttachmentRecordsChanged, 
                                                           Object_Name__c = 'Attachment', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalAttachmentRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorReimbursementRecordsChanged, 
                                                           Object_Name__c = 'Reimbursement', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalReimbursementRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorIssueAdjustmentRecordsChanged, 
                                                           Object_Name__c = 'Issue Adjustment (Review Data)', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalIssueAdjustmentRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorContactRecordsChanged, 
                                                           Object_Name__c = 'Contact (Consumer and trade customer)', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalContactRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorCorrespondenceRecordsChanged, 
                                                           Object_Name__c = 'Correspondence & Fulfilment', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalCorrespondenceRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorTransactionRecordsChanged, 
                                                           Object_Name__c = 'Transaction Management', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalTransactionRecordsChanged);
        purgeList.add(purgeObj);
        purgeObj = new Purge_Tracking__c(NumberOfErrors__c = TotalErrorTransactionHistoryRecordsChanged, 
                                                           Object_Name__c = 'Transaction Management History', 
                                                           Status__c = job.Status,
                                                           Total_Records__c = TotalTransactionHistoryRecordsChanged);
        purgeList.add(purgeObj);   
    
    
        Database.SaveResult[] purgeInsertList = Database.insert(purgeList, false);
       
    }    
}