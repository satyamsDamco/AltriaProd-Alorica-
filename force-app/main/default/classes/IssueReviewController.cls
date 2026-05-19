public class IssueReviewController{
    
    public Integer PageSize{get;set;}
    private String sortDir;
    private String sortExp;
    public List<Case> issueList{get;set;}
    
    public IssueReviewController(ApexPages.StandardController controller) {
        pageInit();
    }
    
    private void pageInit(){
        issueList = new List<Case>();       
        if(ApexPages.currentPage().getParameters().get('pageSize') != null){
            PageSize = Integer.valueOf(ApexPages.currentPage().getParameters().get('pageSize'));
        }else{
            PageSize = 25;
        }
        System.debug('test --'+ApexPages.currentPage().getParameters().get('sortDirection'));
        if(ApexPages.currentPage().getParameters().get('sortDirection') != null && ApexPages.currentPage().getParameters().get('sortDirection') != '' && (ApexPages.currentPage().getParameters().get('sortDirection') == 'asc' ||  ApexPages.currentPage().getParameters().get('sortDirection') == 'desc')){
            sortDir = ApexPages.currentPage().getParameters().get('sortDirection');
        }else{
            sortDir = 'asc';
        }
        
        if(ApexPages.currentPage().getParameters().get('sortExpression') != null && ApexPages.currentPage().getParameters().get('sortExpression') != ''){
            if(ApexPages.currentPage().getParameters().get('sortExpression') == 'cn'){
                sortExp = 'cn';
            }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'bc'){
                sortExp = 'bc';
            }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'pl'){
                sortExp = 'pl';
            }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'cl'){
                sortExp = 'cl';
            }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 're'){
                sortExp = 're';
            }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'cs'){
                sortExp = 'cs';
            }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'contn'){
                sortExp = 'contn';
            }else{
                sortExp = 'cn';
            }
        }else{
            sortExp = 'cn';
        }
    }
    
    public String sortExpression{
        get{ return sortExp;}
        set{
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDir = (sortDir == 'asc')? 'desc' : 'asc';
            else
                sortDir = 'asc';
            sortExp = value;
        }
    }
   
   public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'asc';
        else
            return sortDir;
    }

    public void setSortDirection(String value){
        sortDir = value;
    }
    
    public ApexPages.StandardSetController setQun {
         
        get {
            if(setQun == null) {
                string sortFullExp = '';
                //build the full sort expression
                if(ApexPages.currentPage().getParameters().get('sortExpression') != null && ApexPages.currentPage().getParameters().get('sortExpression') != ''){
                    if(ApexPages.currentPage().getParameters().get('sortExpression') == 'cn'){
                        sortFullExp = 'CaseNumber__c ' + sortDir;
                    }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'bc'){
                        sortFullExp = 'Brandcode__c ' + sortDir;
                    }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'pl'){
                        sortFullExp = 'Product_Line__c ' + sortDir;
                    }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'cl'){
                        sortFullExp = 'Classificationtxt__c ' + sortDir;
                    }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 're'){
                        sortFullExp = 'Reasontxt__c ' + sortDir;
                    }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'cs'){
                        sortFullExp = 'Causetxt__c ' + sortDir;
                    }else if(ApexPages.currentPage().getParameters().get('sortExpression') == 'contn'){
                        sortFullExp = 'CustomerID__c ' + sortDir;
                    }else{
                        sortFullExp = 'CaseNumber__c ' + sortDir;
                    }
                }else{
                    sortFullExp = 'CaseNumber__c ' + sortDir;
                }
                
                //string sortFullExp = sortExpression  +' ' + sortDir;
                
                System.debug('test '+sortFullExp );
                string queryIssue = 'SELECT id, CaseNumber,CaseNumber__c, CustomerID__c, Issue_Type__c, Comment__c, ContactId, Brandcode__c, Product_Line__c,'; 
                       queryIssue  += ' Classificationtxt__c, Reasontxt__c, Causetxt__c, Contact.Name'; 
                       queryIssue  += ' FROM Case Where IsReviewed__c = false order by ' +sortFullExp + ' limit 1000'; 
                System.debug('test queryIssue '+queryIssue );       
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
        System.debug('test ViewData ' +sortDir +sortExpression);
        PageReference pageRef = new PageReference('/apex/IssueReview?sortExpression='+sortExpression+'&sortDirection='+sortDir);
        pageRef.setRedirect(true); 
        return pageRef ; 
    }   
    
    // Wrapper list  
    public List<Case> getIssueReviewList() {        
          
        List<Case> issueList = new List<Case>();
        issueList =setQun.getRecords();
        
        return issueList ;
    }
   
}