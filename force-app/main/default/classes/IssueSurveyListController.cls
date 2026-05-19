public class IssueSurveyListController{
    
    public Case issueObj {get; set;}
    public Integer PageSize  {get;set;}
    public boolean ReviewPage {get;set;}     
    public IssueSurveyListController(){
        pageInit();          
    }
    
    public IssueSurveyListController(ApexPages.StandardController controller) {
        pageInit();
    }
    
    private void pageInit(){
        issueObj = [select id,caseNumber,CaseNumber__c from case where id=:ApexPages.currentPage().getParameters().get('Id')];
        ReviewPage = false;
        if(ApexPages.currentPage().getParameters().get('pageSize') != null){
            PageSize = Integer.valueOf(ApexPages.currentPage().getParameters().get('pageSize'));
        }else{
            PageSize = 20;
        }
        if(ApexPages.currentPage().getParameters().get('fromPage') != null && ApexPages.currentPage().getParameters().get('fromPage') == 'review'){
            ReviewPage = true;
        }
    }
    
     public ApexPages.StandardSetController setQun {
         
        get {
            if(setQun == null) {
                setQun = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id, Comment__c, Survey_Name__c, QuestionText__c ,AnswerText__c 
                        FROM Survey_Issue__c 
                        Where isActive__c = true
                        and Issue__c =:issueObj.id 
                        order by createddate asc] ));
                
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
    
    
    // Wrapper list  
    public List<Survey_Issue__c> getIssueSurvyeList() {        
          
        List<Survey_Issue__c> surveyList = new List<Survey_Issue__c>();
        surveyList =setQun.getRecords();
        
        return surveyList ;
    } 
       
     public pagereference cancel(){
          return new PageReference('/'+issueObj.id);
     }
    
}