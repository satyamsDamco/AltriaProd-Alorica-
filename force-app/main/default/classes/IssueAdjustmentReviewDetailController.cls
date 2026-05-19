public class IssueAdjustmentReviewDetailController {

    // Global declaration of variables
    public Case caseObj {get;set;}
    public Issue_Adjustment__c issueAdjustment {get;set;}
    public boolean isUpdateReasonVisible{get;set;}
    public String custName {get;set;} 
    public string custId{get;set;}
    public string customerRecType {get;set;} 
    
    // Constructor
    public IssueAdjustmentReviewDetailController(ApexPages.StandardController controller) {
        this.caseObj = (Case)controller.getRecord();
        issueAdjustment = new Issue_Adjustment__c();
        Id issueAdjust =ApexPages.currentPage().getParameters().get('issueAdjust');
        if(issueAdjust  != null){
            issueAdjustment = [Select id,IsReviewed__c,Issue__c,Status__c,Comment__c from Issue_Adjustment__c where id=: issueAdjust];
            CheckValidation();
            custName  = '';
            custId = '';
            getCustomerDetails();
        }
        
    }
    public void CheckValidation(){     
        if (issueAdjustment.IsReviewed__c == True){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Issue Reviewed'));
        } 
    }
        
    public void getCustomerDetails(){
       Case currIssue = [Select Id, Contact.Name, Contact.CustomerID__c,ContactId, Contact.RecordType.Name From Case Where Id =: this.caseObj.id limit 1];
       if(currIssue.ContactId != null){
            custName  = currIssue.Contact.Name;
            custId = currIssue.Contact.CustomerID__c;
            if(currIssue.Contact.RecordType.Name  == 'Consumer'){
                customerRecType = 'consumer';
            }else{
                customerRecType = 'trade';
            }
       }
    }
    public PageReference setReview(){
       issueAdjustment.IsReviewed__c = True;
       issueAdjustment.Status__c = 'Complete';
       update issueAdjustment; 
       PageReference pg = new Pagereference('/apex/IssueAdjustmentReviewDetail?id='+this.caseObj.id+'&issueAdjust='+issueAdjustment.id);
       pg.setRedirect(true);
       return pg; 
    }        
}