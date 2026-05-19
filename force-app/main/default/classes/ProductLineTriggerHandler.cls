/************************************************************************ 
Author: Randolf Suplito
Date: 08/18/2022
Description: This handler class is for ProductLineTrigger
*************************************************************************/

public class ProductLineTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Product_Line__c> triggerNewList, Map<Id,Product_Line__c> triggerNewMap) {
        
        String lastModifiedUser;
        
        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<productLineDTO> productLineDTOList = new List<productLineDTO>();
        
        for(Product_Line__c prodLineRec : [SELECT Id, LastModifiedBy.CommunityNickname FROM Product_Line__c WHERE Id IN :triggerNewMap.keyset()]) {
            lastModifiedUser = prodLineRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Product_Line__c prodLineRec : triggerNewList) {
            productLineDTO plDTO = new productLineDTO();
            plDTO.TENANTID = prodLineRec.TenantId__c != null ? prodLineRec.TenantId__c : '';
            plDTO.CODE = prodLineRec.Code__c != null ? prodLineRec.Code__c : '';
            plDTO.ALTCODE = prodLineRec.Altcode__c != null ? prodLineRec.Altcode__c : '';
            plDTO.DESCRIPTION = prodLineRec.Name != null ? prodLineRec.Name : '';
            plDTO.DISPLAYDESCRIPTION = prodLineRec.DisplayDescription__c != null ? prodLineRec.DisplayDescription__c : '';
            if(prodLineRec.isActive__c != null && prodLineRec.isActive__c) {
                plDTO.ACTIVEFLAG = 'Y';
            } else if(prodLineRec.isActive__c != null && !prodLineRec.isActive__c) {
                plDTO.ACTIVEFLAG = 'N';
            } else if(prodLineRec.isActive__c == null) {
                plDTO.ACTIVEFLAG = '';
            }
            plDTO.DISPLAYORDER = prodLineRec.DisplayOrder__c != null ? prodLineRec.DisplayOrder__c : '';
            
            productLineDTOList.add(plDTO);
        }
        
        if(!productLineDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.ProductLine = productLineDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.PRODUCTLINE_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<productLineDTO> ProductLine;
    }
    
    public class productLineDTO {
        public String TENANTID {get; set;}
        public String CODE {get; set;}
        public String ALTCODE {get; set;}
        public String DESCRIPTION {get; set;}
        public String DISPLAYDESCRIPTION {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String DISPLAYORDER {get; set;}
    }
}