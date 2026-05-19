/************************************************************************ 
Author: Randolf Suplito
Date: 08/15/2022
Description: This handler class is for StoreTypeTrigger
*************************************************************************/

public class StoreTypeTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Store_Type__c> triggerNewList, Map<Id,Store_Type__c> triggerNewMap) {
        
        String lastModifiedUser;

        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<storeTypeDTO> storeTypeDTOList = new List<storeTypeDTO>();
        
        for(Store_Type__c storeTypeRec : [SELECT Id, LastModifiedBy.CommunityNickname FROM Store_Type__c WHERE Id IN :triggerNewMap.keyset()]) {
            lastModifiedUser = storeTypeRec.LastModifiedBy.CommunityNickname;
        }

        for(Store_Type__c storeTypeRec : triggerNewList) {
            storeTypeDTO stDTO = new storeTypeDTO();
            stDTO.TENANTID = storeTypeRec.TenantId__c != null ? storeTypeRec.TenantId__c : '';
            stDTO.CODE = storeTypeRec.Name != null ? storeTypeRec.Name : '';
            stDTO.ALTCODE = storeTypeRec.AltCode__c != null ? storeTypeRec.AltCode__c : '';
            stDTO.DESCRIPTION = storeTypeRec.Description__c != null ? storeTypeRec.Description__c : '';
            stDTO.DISPLAYDESCRIPTION = storeTypeRec.Display_Description__c != null ? storeTypeRec.Display_Description__c : '';
            if(storeTypeRec.isActive__c != null && storeTypeRec.isActive__c) {
                stDTO.ACTIVEFLAG = 'Y';
            } else if(storeTypeRec.isActive__c != null && !storeTypeRec.isActive__c) {
                stDTO.ACTIVEFLAG = 'N';
            } else if(storeTypeRec.isActive__c == null) {
                stDTO.ACTIVEFLAG = '';
            }
            stDTO.DISPLAYORDER = storeTypeRec.DisplayOrder__c != null ? storeTypeRec.DisplayOrder__c : '';
            
            storeTypeDTOList.add(stDTO);
        }
        
        if(!storeTypeDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.StoreType = storeTypeDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.STORETYPE_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<storeTypeDTO> StoreType;
    }
    
    public class storeTypeDTO {
        public String TENANTID {get; set;}
        public String CODE {get; set;}
        public String ALTCODE {get; set;}
        public String DESCRIPTION {get; set;}
        public String DISPLAYDESCRIPTION {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String DISPLAYORDER {get; set;}
    }
}