public class IssueAdjustmentReviewController{
    
    public Integer PageSize{get;set;}
    private String sortDirection;
    private String sortExp;
    public List<Issue_Adjustment__c> issueList{get;set;}
    public string selectedReviewType {get;set;}
    
    public IssueAdjustmentReviewController(ApexPages.StandardController controller) {
        pageInit();
    }
    
    private void pageInit(){
        issueList = new List<Issue_Adjustment__c>();       
        if(ApexPages.currentPage().getParameters().get('pageSize') != null){
            PageSize = Integer.valueOf(ApexPages.currentPage().getParameters().get('pageSize'));
        }else{
            PageSize = 25;
        }
        if(ApexPages.currentPage().getParameters().get('sortDirection') != null && ApexPages.currentPage().getParameters().get('sortDirection') != ''  && (ApexPages.currentPage().getParameters().get('sortDirection') == 'a' ||  ApexPages.currentPage().getParameters().get('sortDirection') == 'd')){
            sortDirection = ApexPages.currentPage().getParameters().get('sortDirection');
        }else{
            sortDirection = 'a';
        }
        if(ApexPages.currentPage().getParameters().get('ReviewType') != null && ApexPages.currentPage().getParameters().get('ReviewType') != ''){
            selectedReviewType = ApexPages.currentPage().getParameters().get('ReviewType');
        }else{
            selectedReviewType = 'Not Reviewed';
        }
        
        sortExp = 'IssueNumber__c';
        
    }
    
    public String sortExpression{
        get{ return sortExp;}
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'a')? 'd' : 'a';
            else
                sortDirection = 'a';
            sortExp = value;
        }
    }
   
   public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'a';
        else
            return sortDirection;
    }

    public void setSortDirection(String value){
        sortDirection = value;
    }
    
    public ApexPages.StandardSetController setQun {
         
        get {
            if(setQun == null) {
                //build the full sort expression
                string sortFullExp = '';
                if(sortDirection == 'a'){
                    sortFullExp = sortExpression  + ' ASC ';
                }else{
                     sortFullExp = sortExpression  + ' DESC ';
                }    
                System.debug('test '+sortFullExp );
                String ActionType = 'R';
                string queryIssue = '';
                if(selectedReviewType == 'Reviewed'){
                    queryIssue = 'SELECT id, IssueNumber__c, Issue__c, Adjustment_Instructions__c,Comment__c '; 
                    queryIssue  += ' FROM Issue_Adjustment__c Where Issue__c != null and  Action_Type__c = \''+ ActionType  +'\' and IsReviewed__c = true order by ' +sortFullExp + ' limit 1000'; 
                }else{
                    queryIssue = 'SELECT id, IssueNumber__c, Issue__c, Adjustment_Instructions__c,Comment__c '; 
                    queryIssue  += ' FROM Issue_Adjustment__c Where Issue__c != null and  Action_Type__c = \''+ ActionType +'\' and IsReviewed__c = false order by ' +sortFullExp + ' limit 1000'; 
                }  
                System.debug('test queryIssue  '+queryIssue  );
                setQun = new ApexPages.StandardSetController(Database.getQueryLocator(queryIssue));
                setQun.setPageSize(PageSize);
 
            }
            return setQun;
        }
        set;
    }
        
    public Boolean hasNext {
        get {
            return setQun.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setQun.getHasPrevious();
        }
        set;
    }
    
    public void previous() {
         setQun.previous();
     }
    
    public void next() {
         setQun.next();
    } 
    
    public PageReference ViewData(){
        PageReference pageRef = new PageReference('/apex/IssueAdjustmentReview?sortDirection='+sortDirection+'&ReviewType='+selectedReviewType);
        pageRef.setRedirect(true); 
        return pageRef ; 
    }   
    
    // Wrapper list  
    public List<Issue_Adjustment__c> getIssueReviewList() {        
          
        List<Issue_Adjustment__c> issueList = new List<Issue_Adjustment__c>();
        issueList =setQun.getRecords();
        
        return issueList;
    }
    
     public List<SelectOption> getReviewList(){
        List<SelectOption> ReviewDataList = new List<SelectOption>();
        
        
        ReviewDataList.add(new SelectOption('Not Reviewed', 'Not Reviewed'));
        ReviewDataList.add(new SelectOption('Reviewed', 'Reviewed'));  
        
        return ReviewDataList;
    }  
}