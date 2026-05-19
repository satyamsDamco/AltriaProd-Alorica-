/************************************************************************ 
Author: Randolf Suplito
Date: 08/08/2022
Description: This handler class is for CustomerTypeTrigger
*************************************************************************/

public class CustomerTypeTriggerHandler {
	
    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Customer_Type__c> triggerNewList, Map<Id,Customer_Type__c> triggerNewMap) {
        
        String lastModifiedUser;
        
        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<customerTypeDTO> cusTypeDTOList = new List<customerTypeDTO>();
        
        for(Customer_Type__c cusType : [SELECT Id, LastModifiedBy.CommunityNickname FROM Customer_Type__c WHERE Id IN :triggerNewMap.keyset()]) {
            lastModifiedUser = cusType.LastModifiedBy.CommunityNickname;
        }
        
        for(Customer_Type__c cusType : triggerNewList) {
            customerTypeDTO cusDTO = new customerTypeDTO();
            cusDTO.TENANTID = cusType.TenantID__c != null ? cusType.TenantID__c : '';
            cusDTO.CODETYPE = cusType.CodeType__c != null ? cusType.CodeType__c : '';
            cusDTO.CUSTOMERTYPE = cusType.Customer_Type__c != null ? cusType.Customer_Type__c : '';
            cusDTO.DESCRIPTION = cusType.Description__c != null ? cusType.Description__c : '';
            cusDTO.DISPLAYDESCRIPTION = cusType.Display_Description__c != null ? cusType.Display_Description__c : '';
            cusDTO.CUSTOMERCONSUMER = cusType.CustomerConsumer__c != null ? cusType.CustomerConsumer__c : '';
            if(cusType.IsActive__c != null && cusType.IsActive__c) {
                cusDTO.ACTIVEFLAG = 'Y';
            } else if(cusType.IsActive__c != null && !cusType.IsActive__c) {
                cusDTO.ACTIVEFLAG = 'N';
            } else if(cusType.IsActive__c == null) {
                cusDTO.ACTIVEFLAG = '';
            }
            
            cusTypeDTOList.add(cusDTO);
        }
        
        if(!cusTypeDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.CustomerType = cusTypeDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.CUSTOMERTYPE_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<customerTypeDTO> CustomerType;
    }
    
    public class customerTypeDTO {
        public String TENANTID {get; set;}
        public String CODETYPE {get; set;}
        public String CUSTOMERTYPE {get; set;}
        public String DESCRIPTION {get; set;}
        public String DISPLAYDESCRIPTION {get; set;}
        public String CUSTOMERCONSUMER {get; set;}
        public String ACTIVEFLAG {get; set;}
    }
}