public with sharing class AcxiomServices {
    
   public static IntegrationLog__c getAccessToken(){
        AcxiomCallout tokenCallout = new AcxiomCallout('Token');
        try{
            AcxiomClasses.TokenInfo currentToken = tokenCallout.getAccessToken();
            tokenCallout.log('access token: ' + currentToken);
        }catch(Exception ex){
            tokenCallout.log(ex);
        }finally{
            insert tokenCallout.log;
        }
        return tokenCallout.log;
    }
    
    public static AcxiomClasses.ConsumerFinalResponse FullSearchLookupRequest(String strRequestBody, String TranId, String FormName){
        AcxiomCallout fullSearchLookupCallout = new AcxiomCallout('Full Search Lookup');
        AcxiomClasses.ConsumerFinalResponse cObj = new AcxiomClasses.ConsumerFinalResponse();
        
        fullSearchLookupCallout.transaction(TranId);
        fullSearchLookupCallout.formName(FormName);
        
        try{
            AcxiomClasses.TokenInfo currentToken = fullSearchLookupCallout.getAccessToken();
           
            fullSearchLookupCallout.log('Aquired the access token: ' + currentToken.access_token);
            
            cObj = fullSearchLookupCallout.FullSearchLookupRequest(strRequestBody);
            fullSearchLookupCallout.log('Full Search ' + cObj);
            if(cObj == null || cObj.CCN == null){
                fullSearchLookupCallout.log('No Record fetched from Acxiom Full Search Service');                
            }         
                          
        }catch(Exception ex){
            fullSearchLookupCallout.log(ex);
        }finally{
            insert fullSearchLookupCallout.log;
        }
        
        return cObj;
    }
    
    
    public static AcxiomClasses.CCNLookupFinalResponse CCNLookupRequest(String strRequestBody, String customerCCN, String TranId, String FormName){
        AcxiomCallout CCNLookupCallout = new AcxiomCallout('CCN Lookup');
        AcxiomClasses.CCNLookupFinalResponse cObj = new AcxiomClasses.CCNLookupFinalResponse();
        
        CCNLookupCallout.customerCCN(customerCCN);
        System.debug('TranId'+TranId);
        CCNLookupCallout.transaction(TranId);
        CCNLookupCallout.formName(FormName);
        
        try{
            AcxiomClasses.TokenInfo currentToken = CCNLookupCallout.getAccessToken();
           
            CCNLookupCallout.log('Aquired the access token: ' + currentToken.access_token);
            
            cObj = CCNLookupCallout.CCNLookupRequest(strRequestBody);
            CCNLookupCallout.log('CCN Lookup ' + cObj);
            if(cObj == null){
                CCNLookupCallout.log('No Record fetched from Acxiom CCN Lookup');                
            }         
                          
        }catch(Exception ex){
            CCNLookupCallout.log(ex);
        }finally{
            insert CCNLookupCallout.log;
        }
        System.debug('CCN Lookup ' + cObj);
        return cObj;
    }
}