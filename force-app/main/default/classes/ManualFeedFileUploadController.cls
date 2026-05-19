public class ManualFeedFileUploadController {
    
    Public String option{get;set;}
    Public PageReference pg;

    public Pagereference UploadPage(){
        
        
        if(option=='Brand Hierarchy'){
            system.debug('------------'+option);
            pg=new PageReference ('/apex/ManualBrandHierarchyUpload');
            
        } else if (option=='Issue Hierarchy'){
             pg=new PageReference ('/apex/ManualIssueHierarchyUpload'); 
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Hierarchy.'));
            return null;
        }
        
        pg.setRedirect(true);
        return pg;
    }
    
    
}