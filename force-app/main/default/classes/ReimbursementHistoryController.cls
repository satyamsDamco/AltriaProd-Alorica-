public class ReimbursementHistoryController {

public List<Reimbursement__c> reimbHist{get;set;}
public Contact conObj {get;set;}
public Reimbursement__c reimbursement {get;set;} //ADD THIS FOR TITLE BY SARA
public String reimbFirstName {get;set;}  //ADD THIS FOR TITLE BY SARA

public ReimbursementHistoryController(ApexPages.StandardController stdController){
    String contactID;
    System.debug('Page: ' + ApexPages.currentPage());
    contactId = ApexPages.currentPage().getParameters().get('contactId');
    
    If(contactId != null){
        for(Contact c: [SELECT Zip_Code__c, Street_Address__c 
                        FROM Contact
                        WHERE Id =: contactId]){
            conObj = c;               
            }
    }
    
    if(conObj != null){
        reimbHist =[SELECT 
                        IssueID__c,Issue__r.CreatedDate, CreatedDate,
                        Cheque_Amount__c, First_Name__c,
                        Last_Name__c, Street_Address__c, Apt_Lot__c, City__c,
                        State__c, Zip_Code__c, CustomerID__c, OpCo__c,
                        Consumer__r.AVF_GIID_Received__c, Transfer_to_Altria_Date__c,
                        Altria_File_Name__c, File_Name__c, Ship_Date__c,
                        Ecount_ID__c, Card_Number__c
                    FROM Reimbursement__c
                    WHERE  
                    (Zip_Code__c =: conObj.Zip_Code__c AND Street_Address__c =: conObj.Street_Address__c)
                    OR Consumer__c =: conObj.Id
                    ORDER BY IssueID__c DESC];
                    // Populate reimbFirstName from first record by Sara
        if(reimbHist != null && !reimbHist.isEmpty()){
            reimbFirstName = reimbHist[0].First_Name__c != null ? reimbHist[0].First_Name__c : '';
        }
        
    } 
}
}