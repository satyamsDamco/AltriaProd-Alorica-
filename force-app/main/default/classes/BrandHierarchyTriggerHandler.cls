/************************************************************************ 
Author: Randolf Suplito
Date: 08/19/2022
Description: This handler class is for BrandHierarchyTrigger
*************************************************************************/

public class BrandHierarchyTriggerHandler {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Brand_Hierarchy__c> triggerNewList, Map<Id,Brand_Hierarchy__c> triggerNewMap) {
        
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;

        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<brandHierarchyDTO> brandHierarchyDTOList = new List<brandHierarchyDTO>();
        
        for(Brand_Hierarchy__c brandHieRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Brand_Hierarchy__c WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(brandHieRec.Id, brandHieRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(brandHieRec.Id, brandHieRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = brandHieRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Brand_Hierarchy__c brandHieRec : triggerNewList) {
            brandHierarchyDTO bhDTO = new brandHierarchyDTO();
            bhDTO.TENANTID = brandHieRec.TenantId__c != null ? brandHieRec.TenantId__c : '';
            bhDTO.CODECATEGORY = brandHieRec.CodeCategory__c != null ? brandHieRec.CodeCategory__c : '';
            bhDTO.CODETYPE = brandHieRec.CodeType__c != null ? brandHieRec.CodeType__c : '';
            bhDTO.CRCBRANDHIERARCHYCODE = brandHieRec.Name != null ? brandHieRec.Name : '';
            bhDTO.PRODUCTLINECODE = brandHieRec.ProductLine_Code__c != null ? brandHieRec.ProductLine_Code__c : '';
            bhDTO.BRANDCODE = brandHieRec.Code__c != null ? brandHieRec.Code__c : '';
            bhDTO.UPC = brandHieRec.UPC__c != null ? brandHieRec.UPC__c : '';
            bhDTO.TASTE = brandHieRec.Taste__c != null ? brandHieRec.Taste__c : '';
            bhDTO.LENGTH = brandHieRec.Length__c != null ? brandHieRec.Length__c : '';
            bhDTO.PACKAGING = brandHieRec.Packaging__c != null ? brandHieRec.Packaging__c : '';
            bhDTO.FLAVOR = brandHieRec.Flavor__c != null ? brandHieRec.Flavor__c : '';
            bhDTO.FILTER = brandHieRec.Filter__c != null ? brandHieRec.Filter__c : '';
            bhDTO.PAPERTYPE = brandHieRec.PaperType__c != null ? brandHieRec.PaperType__c : '';
            bhDTO.CUT = brandHieRec.Cut__c != null ? brandHieRec.Cut__c : '';
            bhDTO.USTDATETYPE = brandHieRec.Ust_Date_Type__c != null ? brandHieRec.Ust_Date_Type__c : '';
			bhDTO.PMBRANDCODE = brandHieRec.Pm_Brand_Code__c != null ? brandHieRec.Pm_Brand_Code__c : '';
            bhDTO.SHORTCUT = brandHieRec.Short_Cut__c != null ? brandHieRec.Short_Cut__c : '';
            bhDTO.BRANDSASCODE = brandHieRec.Brand_Sas_Code__c != null ? brandHieRec.Brand_Sas_Code__c : '';
            bhDTO.BRANDMMCODE = brandHieRec.Brand_MM_Code__c != null ? brandHieRec.Brand_MM_Code__c : '';
            bhDTO.PRODUCTDESC = brandHieRec.ProductDescFeed__c != null ? brandHieRec.ProductDescFeed__c : '';
            bhDTO.PRODUCTTYPE = brandHieRec.ProductTypeFeed__c != null ? brandHieRec.ProductTypeFeed__c : '';
            bhDTO.PRICECATEGORY = brandHieRec.PriceCategoryFeed__c != null ? brandHieRec.PriceCategoryFeed__c : '';
            bhDTO.LICENSEGROUP = brandHieRec.License_Group__c != null ? brandHieRec.License_Group__c : '';
            bhDTO.BRANDSTATUS = brandHieRec.Brand_Status__c != null ? brandHieRec.Brand_Status__c : '';
            bhDTO.BRANDCLASSIFICATION = brandHieRec.Brand_Classification__c != null ? brandHieRec.Brand_Classification__c : '';
            bhDTO.PACKTYPE = brandHieRec.Pack_Type__c != null ? brandHieRec.Pack_Type__c : '';
            bhDTO.REPORTINGBRANDFAMILY = brandHieRec.Reporting_Brand_Family__c != null ? brandHieRec.Reporting_Brand_Family__c : '';
            bhDTO.STRINGDATA = brandHieRec.String_Data__c != null ? brandHieRec.String_Data__c : '';
            bhDTO.VANTIVEID = brandHieRec.Vantive_Id__c != null ? brandHieRec.Vantive_Id__c : '';
            bhDTO.UNITSPERPACK = brandHieRec.Units_Per_Pack__c != null ? String.valueOf(brandHieRec.Units_Per_Pack__c) : '';
            bhDTO.PICKUPPOLICYWEEKS = brandHieRec.Pick_Up_Policy_Weeks__c != null ? String.valueOf(brandHieRec.Pick_Up_Policy_Weeks__c) : '';
            if(brandHieRec.Active__c != null && brandHieRec.Active__c) { 
                bhDTO.ACTIVEFLAG = 'Y'; 
            } else if(brandHieRec.Active__c != null && !brandHieRec.Active__c) { 
                bhDTO.ACTIVEFLAG = 'N'; 
            } else if(brandHieRec.Active__c == null) {
                bhDTO.ACTIVEFLAG = ''; 
            }
            bhDTO.CREATEDDATE = brandHieRec.CreatedDate__c != null ? brandHieRec.CreatedDate__c : '';
            bhDTO.CREATEDBY = createdComNameMap.get(brandHieRec.Id);
            bhDTO.MODIFIEDDATE = brandHieRec.LastModifiedDate__c != null ? brandHieRec.LastModifiedDate__c : '';
            bhDTO.MODIFIEDBY = modifiedComNameMap.get(brandHieRec.Id);
            bhDTO.ARCHIVALDATE = brandHieRec.Archival_Date__c != null ? brandHieRec.Archival_Date__c : '';
            
            brandHierarchyDTOList.add(bhDTO);
        }
        
        if(!brandHierarchyDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.BrandHierarchy = brandHierarchyDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
        	APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.BRANDHIERARCHY_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<brandHierarchyDTO> BrandHierarchy;
    }
    
    public class brandHierarchyDTO {
        public String TENANTID {get; set;}
        public String CODECATEGORY {get; set;}
        public String CODETYPE {get; set;}
        public String CRCBRANDHIERARCHYCODE {get; set;}
        public String PRODUCTLINECODE {get; set;}
        public String BRANDCODE {get; set;}
        public String UPC {get; set;}
        public String TASTE {get; set;}
        public String LENGTH {get; set;}
        public String PACKAGING {get; set;}
        public String FLAVOR {get; set;}
        public String FILTER {get; set;}
        public String PAPERTYPE {get; set;}
        public String CUT {get; set;}
        public String USTDATETYPE {get; set;}
        public String PMBRANDCODE {get; set;}
        public String SHORTCUT {get; set;}
        public String BRANDSASCODE {get; set;}
        public String BRANDMMCODE {get; set;}
        public String PRODUCTDESC {get; set;}
        public String PRODUCTTYPE {get; set;}
        public String PRICECATEGORY {get; set;}
        public String LICENSEGROUP {get; set;}
        public String BRANDSTATUS {get; set;}
        public String BRANDCLASSIFICATION {get; set;}
        public String PACKTYPE {get; set;}
        public String REPORTINGBRANDFAMILY {get; set;}
        public String STRINGDATA {get; set;}
        public String VANTIVEID {get; set;}
        public String UNITSPERPACK {get; set;}
        public String PICKUPPOLICYWEEKS {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String CREATEDDATE {get; set;}
        public String CREATEDBY {get; set;}
        public String MODIFIEDDATE {get; set;}
        public String MODIFIEDBY {get; set;}
        public String ARCHIVALDATE {get; set;}
    }
}