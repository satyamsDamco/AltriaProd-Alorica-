public with sharing class LexisNexisServices {

    public static LexisNexisClasses.AgeVerificationResponse AgeVerificationRequest(LexisNexisClasses.AgeVerificationRequest requestBody, String TranId, String FormName,string opCompany, string customerCCN, string customerObj){

        LexisNexisCallout ageCallout = new LexisNexisCallout('Age Verification',opCompany);
        LexisNexisClasses.AgeVerificationResponse cObj = new LexisNexisClasses.AgeVerificationResponse();       
        
        ageCallout.transaction(TranId);
        ageCallout.formName(FormName);  
    
        if(customerCCN != null && customerCCN.trim() != '')
            ageCallout.customerCCN(customerCCN);
            
        if(customerObj != null && customerObj.trim() != '')    
            ageCallout.customerUpdate(customerObj);
             
        try{
            cObj = ageCallout.AgeVerificationRequest(requestBody);
            ageCallout.log('Age Verification ' + cObj);
            if(cObj.Status == null || cObj.Status == null){
                ageCallout.log('Error');                
            }                                 
        }catch(Exception ex){
            cObj.Status = 'Error';
            cObj.Message = '';
            ageCallout.log(ex);
        }finally{
            insert ageCallout.log;
        }        
        return cObj;
    }
}