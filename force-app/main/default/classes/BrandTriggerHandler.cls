/************************************************************************ 
Author: Randolf Suplito
Date: 08/18/2022
Description: This handler class is for BrandTrigger
*************************************************************************/

public class BrandTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Brand__c> triggerNewList, Map<Id,Brand__c> triggerNewMap) {
        
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;
		
		jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<brandDTO> brandDTOList = new List<brandDTO>();
        
        for(Brand__c brandRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Brand__c WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(brandRec.Id, brandRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(brandRec.Id, brandRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = brandRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Brand__c brandRec : triggerNewList) {
            brandDTO bDTO = new brandDTO();
            bDTO.TENANTID = brandRec.TenantId__c != null ? brandRec.TenantId__c : '';
            bDTO.ModuleName = brandRec.ModuleName__c != null ? brandRec.ModuleName__c : '';
            bDTO.ScreenName = brandRec.ScreenName__c != null ? brandRec.ScreenName__c : '';
            bDTO.CodeCategory = brandRec.CodeCategory__c != null ? brandRec.CodeCategory__c : '';
            bDTO.CodeType = brandRec.CodeType__c != null ? brandRec.CodeType__c : '';
            bDTO.Code = brandRec.Code__c != null ? brandRec.Code__c : '';
            bDTO.BrandCode = brandRec.BrandCode__c != null ? brandRec.BrandCode__c : '';
            bDTO.BrandFamily = brandRec.BrandFamily__c != null ? brandRec.BrandFamily__c : '';
            bDTO.Description = brandRec.Description__c != null ? brandRec.Description__c : '';
            bDTO.DisplayDescription = brandRec.DisplayDescription__c != null ? brandRec.DisplayDescription__c : '';
            bDTO.DisplayOrder = brandRec.DisplayOrder__c != null ? brandRec.DisplayOrder__c : '';
            bDTO.ProductLineFlag = brandRec.ProductLineFlag__c != null ? brandRec.ProductLineFlag__c : '';
            bDTO.OperatingCompany = brandRec.Operating_Company__c != null ? brandRec.Operating_Company__c : '';
            bDTO.CRCOperatingCompany = brandRec.CRC_Operating_Company__c != null ? brandRec.CRC_Operating_Company__c : '';
            bDTO.ProductLine = brandRec.ProductLineCode__c != null ? brandRec.ProductLineCode__c : '';
            bDTO.USTDateType = brandRec.USTDateType__c != null ? brandRec.USTDateType__c : '';
            if(brandRec.IsActive__c != null && brandRec.IsActive__c) {
                bDTO.Active_flag = 'Y';
            } else if(brandRec.IsActive__c != null && !brandRec.IsActive__c) {
                bDTO.Active_flag = 'N';
            } else if(brandRec.IsActive__c == null) {
                bDTO.Active_flag = '';
            }
            bDTO.CreatedDate = brandRec.CreatedDate__c != null ? brandRec.CreatedDate__c : '';
            bDTO.CreatedBy = createdComNameMap.get(brandRec.Id);
            bDTO.ModifiedDate = brandRec.LastModifiedDate__c != null ? brandRec.LastModifiedDate__c : '';
            bDTO.ModifiedBy = modifiedComNameMap.get(brandRec.Id);
            
            brandDTOList.add(bDTO);
        }
        
        if(!brandDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.BrandCode = brandDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.BRAND_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<brandDTO> BrandCode;
    }
    
    public class brandDTO {
        public String TENANTID {get; set;}
        public String ModuleName {get; set;}
        public String ScreenName {get; set;}
        public String CodeCategory {get; set;}
        public String CodeType {get; set;}
        public String Code {get; set;}
        public String BrandCode {get; set;}
        public String BrandFamily {get; set;}
        public String Description {get; set;}
        public String DisplayDescription {get; set;}
        public String DisplayOrder {get; set;}
        public String ProductLineFlag {get; set;}
        public String OperatingCompany {get; set;}
        public String CRCOperatingCompany {get; set;}
        public String ProductLine {get; set;}
        public String USTDateType {get; set;}
        public String Active_flag {get; set;}
        public String CreatedDate {get; set;}
        public String CreatedBy {get; set;}
        public String ModifiedDate {get; set;}
        public String ModifiedBy {get; set;}
    }
}