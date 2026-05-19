public with sharing class MelissaServices{

     public static MelissaClasses.zipLookupResponse ZipLookupServiceRequest(String zipCodeVal, String TranId, String FormName, string customerCCN, string customerObj){
     
        MelissaCallout ZipLookupCallout = new MelissaCallout('Zip Lookup');
        MelissaClasses.zipLookupResponse zipLookupObj;
        
        ZipLookupCallout.transaction(TranId);
        ZipLookupCallout.formName(FormName);
        
        if(customerCCN != null && customerCCN.trim() != '')
            ZipLookupCallout.customerCCN(customerCCN);
    
        if(customerObj != null && customerObj.trim() != '')
            ZipLookupCallout.customerUpdate(customerObj);
         
        try{
                    
            zipLookupObj = ZipLookupCallout.ZipLookupRequest(zipCodeVal);
            
            if(zipLookupObj == null){
                ZipLookupCallout.log('Error : Melissa Zip Lookup service');
            }else  if(zipLookupObj != null && !zipLookupObj.ResultCode.equalsIgnoreCase('XS01')){
                ZipLookupCallout.log('No Record fetched from Melissa Zip Lookup service');
            }else{
                ZipLookupCallout.log('Result :'+zipLookupObj);
            }            
                          
        }catch(Exception ex){
            ZipLookupCallout.log(ex);
        }finally{
            insert ZipLookupCallout.log;
        }
        
        return zipLookupObj;
    }
    
    public static List<MelissaClasses.consumerAddressInnerResponse> usaAddressRequest(MelissaClasses.consumerAddressRequest addressObj, String TranId, String FormName, string customerCCN, string customerObj){
        MelissaCallout AddressCallout = new MelissaCallout('Address Verification');
        
        List<MelissaClasses.consumerAddressInnerResponse> consumerAddResList = new List<MelissaClasses.consumerAddressInnerResponse>();
        
        AddressCallout.transaction(TranId);
        AddressCallout.formName(FormName);
        
        if(customerCCN != null && customerCCN.trim() != '')
            AddressCallout.customerCCN(customerCCN);
            
        if(customerObj != null && customerObj.trim() != '')    
            AddressCallout.customerUpdate(customerObj);
        
        try{
                    
            consumerAddResList = AddressCallout.usaAddressRequest(addressObj);
          
            if(consumerAddResList.isEmpty() || consumerAddResList.size() == 0){
                AddressCallout.log('Error : Melissa USA Address Verification service');
            }else{ 
                AddressCallout.log('Result :'+consumerAddResList);
            }            
                          
        }catch(Exception ex){
            AddressCallout.log(ex);
        }finally{
            insert AddressCallout.log;
        }
        
        return consumerAddResList;  
    }
}