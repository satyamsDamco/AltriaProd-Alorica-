/************************************************************************ 
Author: Randolf Suplito
Date: 08/22/2022
Description: This handler class is for CounterfeitTraceCodeTrigger
*************************************************************************/

public class CounterfeitTraceCodeTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<CounterfeitTraceCode__c> triggerNewList, Map<Id,CounterfeitTraceCode__c> triggerNewMap) {
        
        String lastModifiedUser;
        
        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<counterfeittcDTO> counterfeittcDTOList = new List<counterfeittcDTO>();
		Integer d;
        Integer mo;
        Integer yr;
        
        for(CounterfeitTraceCode__c counterfeittcRec : [SELECT Id, LastModifiedBy.CommunityNickname FROM CounterfeitTraceCode__c WHERE Id IN :triggerNewMap.keyset()]) {
            lastModifiedUser = counterfeittcRec.LastModifiedBy.CommunityNickname;
        }
        
        for(CounterfeitTraceCode__c counterfeittcRec : triggerNewList) {
            counterfeittcDTO ctcDTO = new counterfeittcDTO();
            ctcDTO.Type = counterfeittcRec.Type__c != null ? counterfeittcRec.Type__c : '';
            ctcDTO.Brand = counterfeittcRec.MFGBrand__c != null ? counterfeittcRec.MFGBrand__c : '';
            ctcDTO.CounterfeitCodes = counterfeittcRec.Trace_Code__c != null ? counterfeittcRec.Trace_Code__c : '';
            if(counterfeittcRec.Production_Date__c != null) {
                d = counterfeittcRec.Production_Date__c.day();
                mo = counterfeittcRec.Production_Date__c.month();
                yr = counterfeittcRec.Production_Date__c.year();
                
                DateTime dt = DateTime.newInstance(yr, mo, d);
                ctcDTO.RepresentedMFGDate =  dt.format('MM/dd/yyyy') ;
            } else {
                ctcDTO.RepresentedMFGDate = '';
            }
            ctcDTO.MFGYear = counterfeittcRec.MFGYear__c != null ? counterfeittcRec.MFGYear__c : '';
            ctcDTO.Source = counterfeittcRec.Source__c != null ? counterfeittcRec.Source__c : '';
            ctcDTO.SourceCity = counterfeittcRec.SourceCity__c != null ? counterfeittcRec.SourceCity__c : '';
            ctcDTO.SourceState = counterfeittcRec.SourceState__c != null ? counterfeittcRec.SourceState__c : '';
            if(counterfeittcRec.SourceDateDetected__c != null) {
                d = counterfeittcRec.SourceDateDetected__c.day();
                mo = counterfeittcRec.SourceDateDetected__c.month();
                yr = counterfeittcRec.SourceDateDetected__c.year();
                
                DateTime dt = DateTime.newInstance(yr, mo, d);
                ctcDTO.SourceDateDetected =  dt.format('MM/dd/yyyy') ;
            } else {
                ctcDTO.SourceDateDetected = '';
            }
            ctcDTO.Remarks = counterfeittcRec.Remarks__c != null ? counterfeittcRec.Remarks__c : '';
            
            counterfeittcDTOList.add(ctcDTO);
        }
        
        if(!counterfeittcDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.CounterfeitCodes = counterfeittcDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.COUNTERFEITTRACECODE_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<counterfeittcDTO> CounterfeitCodes;
    }
    
    public class counterfeittcDTO {
        public String Type {get; set;}
        public String Brand {get; set;}
        public String CounterfeitCodes {get; set;}
        public String RepresentedMFGDate {get; set;}
        public String MFGYear {get; set;}
        public String Source {get; set;}
        public String SourceCity {get; set;}
        public String SourceState {get; set;}
        public String SourceDateDetected {get; set;}
        public String Remarks {get; set;}
    }
}