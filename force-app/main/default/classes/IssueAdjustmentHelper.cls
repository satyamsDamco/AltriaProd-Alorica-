public class IssueAdjustmentHelper {

    public void updateIssueData(list<Issue_Adjustment__c> lstIssueAdjust){
        List<Id> ids = new List<id>();
        for(Issue_Adjustment__c issue : lstIssueAdjust){
            ids.add(issue.id);
        }
        IssueAdjustmentFutureHelper.updateIssue(ids); 
    }
    
    public void updateSequence(list<Issue_Adjustment__c> lstIssueAdjust){
        for(Issue_Adjustment__c issue : lstIssueAdjust){
            if(issue.Adjustment_Code__c == 'BH'){
                issue.Sequence__c = 1;
            }else if(issue.Adjustment_Code__c == 'IH'){
                issue.Sequence__c = 2;
            }else if(issue.Adjustment_Code__c == 'CN'){
                issue.Sequence__c = 3;
            }else if(issue.Adjustment_Code__c == 'RID'){
                issue.Sequence__c = 4;
            }else if(issue.Adjustment_Code__c == 'SCF'){
                issue.Sequence__c = 5;
            }else if(issue.Adjustment_Code__c == 'ST'){
                issue.Sequence__c = 6;
            }else if(issue.Adjustment_Code__c == 'TC'){
                issue.Sequence__c = 7;
            }else if(issue.Adjustment_Code__c == 'DC'){
                issue.Sequence__c = 8;
            }else{
                issue.Sequence__c = 9;
            }
        }
    }  
}