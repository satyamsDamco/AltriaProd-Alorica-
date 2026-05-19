/*
Created By : Infogain
Created Date : 19 Aug 2016
*/

public class TransactionMgmtHelper {
    
    //Method to insert history records based on the source of history.
    public void createTransactionMgmtHistoryRecord(String source, String sObjectId){
        string tranid;
        Transaction_Management_History__c history;
        Transaction_Management__c transactionObj;
        Reimbursement__c reimb;
        Correspondence_Fulfilment__c corrObj;
        Survey_Issue__c si;
        Case currIssue;
        string sobjectName;
        System.debug('test 11'+source);
        if(source == 'CCNLOOKUP'){
            tranid = sObjectId;        
        }
        else if(source == 'ISSUE_APPROVED'){
            tranid = '';
        }
        //Start: For IVR Reimbursement API Entry
        else if(source == 'REIMBURSEMENT FOUND' ||
                source == 'NO REIMBURSEMENT FOUND FOR CONSUMER' ||
               	source == 'MULTIPLE CONSUMERS FOUND' ||
               	source == 'NO CONSUMER FOUND' ||
                source == 'CONSUMER IS NOT AGE VERIFIED'){
            transactionObj = [Select Id, Contact__c, Comments__c FROM Transaction_Management__c Where Id=: sObjectId];
        }
        //End: For IVR Reimbursement API Entry
        else{
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                tranid = counter.getValue();
            } 
        }
        if(tranid != null && tranid != ''){
            System.debug('test tranid '+tranid);
            transactionObj = [Select Id, Contact__c, Comments__c From Transaction_Management__c Where Id=: tranid];
            System.debug('test transactionObj '+transactionObj);
        }
        if(source == 'ISSUE_APPROVED'){
            if(sObjectId != null && sObjectId != ''){
                history = new Transaction_Management_History__c();
                sobjectName = Id.valueOf(sObjectId).getSObjectType().getDescribe().getName();
                history.Service_Request_Code__c = source;
                if(Service_Code_Mapping__c.getValues(source) != null){
                    history.Service_Group_Code__c = Service_Code_Mapping__c.getValues(source).Service_Group_Code__c;    
                }
                if(sobjectName == 'Case'){
                    currIssue = new Case();
                    currIssue = [Select Id, ContactId, Contact.LastName, Contact.FirstName From Case where Id =: sObjectId limit 1];
                    history.Issue__c = currIssue.id;
                    history.Issue_Reviewed_Date__c = system.now();
                    history.Issue_Reviewed_By__c = UserInfo.getUserId();
                                        
                    if(currIssue.ContactId != null){
                        history.Customer__c = currIssue.ContactId;
                        history.First_Name__c = currIssue.Contact.FirstName;
                        history.Last_Name__c = currIssue.Contact.LastName;
                    }
                    
                    if(history != null && source == 'ISSUE_APPROVED'){
                        Database.SaveResult saveHistoryRst = Database.insert(history);
                    }
                }
            }
        }
        if(transactionObj != null && source != 'ISSUE_APPROVED'){
            system.debug('-----transactionObj-----'+transactionObj);
            history = new Transaction_Management_History__c();
            history.Transaction_Management__c = transactionObj.id;
            if(transactionObj.Contact__c != null){
                history.Customer__c = transactionObj.Contact__c;
                Contact conObj = [Select Id, LastName, FirstName From Contact Where Id =: transactionObj.Contact__c limit 1];
                if(conObj != null){
                    history.First_Name__c = conObj.FirstName;
                    history.Last_Name__c = conObj.LastName;
                }
                list<Transaction_Management_History__c> lstTMH = getHistoryWithoutContact(transactionObj.id);
                if(lstTMH != null && lstTMH.size() > 0){
                    list<Transaction_Management_History__c> lstTMHUpdate = new list<Transaction_Management_History__c>();
                    for(Transaction_Management_History__c tmh : lstTMH){
                        tmh.Customer__c = transactionObj.Contact__c;
                        tmh.First_Name__c = conObj.FirstName;
                        tmh.Last_Name__c = conObj.LastName;
                        lstTMHUpdate.add(tmh);
                    }
                    if(lstTMHUpdate != null && lstTMHUpdate.size() > 0){
                        list<Database.SaveResult> lstSvRst = Database.update(lstTMHUpdate);
                    }
                }
            }
            history.Service_Request_Code__c = source;
            if(Service_Code_Mapping__c.getValues(source) != null){
                history.Service_Group_Code__c = Service_Code_Mapping__c.getValues(source).Service_Group_Code__c;    
            }
           if(source == 'ENDCALL'){
               history.Comments__c = transactionObj.Comments__c;
           }
           if(sObjectId != null && sObjectId != ''){
                sobjectName = Id.valueOf(sObjectId).getSObjectType().getDescribe().getName();
                if(sobjectName == 'Contact'){
                    //JAD: RITM0441447 - Production Implementation for SCR 20-06-03 2020 Wirecard Virtual Pay
                    history.Comments__c = transactionObj.Comments__c;
                    // JAD: RITM0441447 -- end
                }
                if(sobjectName == 'Case' && source == 'CREATE_SURVEY'){
                    currIssue = new Case();
                    currIssue = [Select Id, Survey__c,Survey_Cancel_Reason__c From Case where Id =: sObjectId limit 1];
                    if(currIssue != null){
                        history.Issue__c = currIssue.id;
                        history.Status__c = currIssue.Survey__c;
                        history.Survey_Termination_Reason__c = currIssue.Survey_Cancel_Reason__c;
                    }
                }
                if(sobjectName == 'Case' && source != 'CREATE_SURVEY'){
                    system.debug('-----Case----');
                    currIssue = new Case();
                    currIssue = [Select Id, Update_Reason__c,Transaction_Management_History__c From Case where Id =: sObjectId limit 1];
                    history.Issue__c = currIssue.id;
                    history.Update_Reason__c = currIssue.Update_Reason__c;
                }
                if(sobjectName == 'Reimbursement__c'){
                    system.debug('-----Reimbursement----');
                    reimb = new Reimbursement__c();
                    reimb = [Select Id, Cheque_Amount__c, Issue__c,PackageCode__c, Transaction_Management_History__c From Reimbursement__c Where Id =: sObjectId limit 1];
                    history.Amount__c = reimb.Cheque_Amount__c;
                    history.Issue__c = reimb.Issue__c;
                    history.Package_Code__c = reimb.PackageCode__c;
                }
                if(sobjectName == 'Correspondence_Fulfilment__c'){
                    system.debug('-----Correspondence_Fulfilment__c----');
                    corrObj = new Correspondence_Fulfilment__c();
                    corrObj = [Select Id, LetterDesc__c,  Packagecode__c,Transaction_Management_History__c From Correspondence_Fulfilment__c Where Id=: sObjectId];
                    history.Letter_Type__c = corrObj.LetterDesc__c;
                    history.Package_Code__c = corrObj.Packagecode__c;
                }
                system.debug('test sobjectName  '+sobjectName );
                if(sobjectName == 'Survey_Issue__c'){
                    system.debug('-----Survey_Issue----');
                    si = new Survey_Issue__c();
                    si = [Select id, Issue__c, Issue__r.Survey__c, Issue__r.Survey_Cancel_Reason__c
                                          From Survey_Issue__c Where Id =: sObjectId limit 1];
                    system.debug('test sobjectName si '+si);                          
                    if(si != null){
                        history.Issue__c = si.Issue__c;
                        history.Status__c = si.Issue__r.Survey__c;
                        history.Survey_Termination_Reason__c = si.Issue__r.Survey_Cancel_Reason__c;
                    }
                }
                if(sobjectName == 'Transaction_Management__c')
                {
                    history.Comments__c = transactionObj.Comments__c;
                }
            }
            System.debug('history = ' + history);
            if(history != null){
                Database.SaveResult saveHistoryRst = Database.insert(history);
                system.debug('-----saveHistoryRst----'+saveHistoryRst);
                if(saveHistoryRst.isSuccess()){
                    if(sobjectName != null && sobjectName != ''){
                        if(sobjectName == 'Reimbursement__c' && reimb != null && reimb.id != null){
                            reimb.Transaction_Management_History__c = saveHistoryRst.getId();
                            update reimb;
                        }
                        if(sobjectName == 'Case' && source != 'CREATE_SURVEY' && currIssue != null && currIssue.id != null){
                            currIssue.Transaction_Management_History__c = saveHistoryRst.getId();
                            update currIssue;
                        }
                        if(sobjectName == 'Correspondence_Fulfilment__c' && corrObj != null && corrObj.id != null){
                            corrObj.Transaction_Management_History__c = saveHistoryRst.getId();
                            update corrObj;
                        }
                    }
                }
            }
        }
    }
    public list<Transaction_Management_History__c> getHistoryWithoutContact(string tranid){
        system.debug('inside gethistory');
        list<Transaction_Management_History__c> lstTMH = [Select Id, Customer__c, Transaction_Management__c From Transaction_Management_History__c Where Transaction_Management__c=: tranid and Customer__c = null];
        system.debug('------lstTMH------'+lstTMH);
        if(lstTMH != null){
            return lstTMH;
        }
        return null;
    }
}