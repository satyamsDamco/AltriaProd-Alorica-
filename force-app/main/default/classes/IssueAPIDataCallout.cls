/************************************************************************ 
Author: Randolf Suplito
Date: 09/14/2022
Description: This class is for Issue Data Feed Callout
*************************************************************************/

public class IssueAPIDataCallout {

    public static Boolean isFirstTime = true;
    
    public static void createCallout(List<Case> triggerNewList, Map<Id,Case> triggerNewMap) {
        
        Map<String,String> createdComNameMap = new Map<String,String>();
        Map<String,String> modifiedComNameMap = new Map<String,String>();
        String lastModifiedUser;

        Integer d;
        Integer mo;
        Integer yr;
        Set<String> contactIdSet = new Set<String>();
        Set<String> issueIdSet = new Set<String>();
        
        jsonRequestDTO jsonPayload = new jsonRequestDTO();
        List<issueDTO> issueDTOList = new List<issueDTO>();
        List<customerDTO> customerDTOList = new List<customerDTO>();
        List<customerDetailsDTO> customerDetailsDTOList = new List<customerDetailsDTO>();
        List<storeInfoDTO> storeInfoDTOList = new List<storeInfoDTO>();
        List<issueSurveyDTO> issueSurveyDTOList = new List<issueSurveyDTO>();
        List<reimbursementDTO> reimbursementDTOList = new List<reimbursementDTO>();
        List<issueAttachmentDTO> issueAttachmentDTOList = new List<issueAttachmentDTO>();
        
        for(Case caseRec : [SELECT Id, CreatedBy.CommunityNickname, LastModifiedBy.CommunityNickname FROM Case WHERE Id IN :triggerNewMap.keyset()]) {
            createdComNameMap.put(caseRec.Id, caseRec.CreatedBy.CommunityNickname);
            modifiedComNameMap.put(caseRec.Id, caseRec.LastModifiedBy.CommunityNickname);
            lastModifiedUser = caseRec.LastModifiedBy.CommunityNickname;
        }
        
        for(Case caseRec : triggerNewList) {
            
            if(caseRec.IsReviewed__c) {
                issueDTO isDTO = new issueDTO();
            
                isDTO.CRCISSUEID = caseRec.CaseNumber__c != null ? caseRec.CaseNumber__c : '';
                isDTO.TENANTID = caseRec.TenantId__c != null ? caseRec.TenantId__c : '';
                isDTO.TXCATEGORY = caseRec.TxCategory__c != null ? caseRec.TxCategory__c : '';
                isDTO.TXTYPE = caseRec.TxType__c != null ? caseRec.TxType__c : '';
                isDTO.CREATEDBY = createdComNameMap.get(caseRec.Id);
                isDTO.ISSUEDATE = caseRec.CreatedDate__c != null ? caseRec.CreatedDate__c : '';
                isDTO.MODIFIEDBY = modifiedComNameMap.get(caseRec.Id);
                isDTO.MODIFIEDDATE = caseRec.LastModifiedDate__c != null ? caseRec.LastModifiedDate__c : '';
                isDTO.CONTACTID = caseRec.Transacation_Id__c != null ? caseRec.Transacation_Id__c : '';
                isDTO.CONTACTSERVICEREQUESTID = caseRec.TMH_ID__c != null ? caseRec.TMH_ID__c : '';
                isDTO.CUSTOMERID = caseRec.CustomerID__c != null ? caseRec.CustomerID__c : '';
                isDTO.OPCO = caseRec.Operating_Company__c != null ? caseRec.Operating_Company__c : '';
                isDTO.ISSUEHIERARCHYCODE = caseRec.Issue_Hierarchy_Name__c != null ? caseRec.Issue_Hierarchy_Name__c : '';
                isDTO.CRCBRANDHIERARCHYCODE = caseRec.Brand_Hierarchy_Code__c != null ? caseRec.Brand_Hierarchy_Code__c : '';
                isDTO.CLASSIFICATION = caseRec.ClassificationCode__c != null ? caseRec.ClassificationCode__c : '';
                isDTO.PRODUCTLINECODE = caseRec.PLCode__c != null ? caseRec.PLCode__c : '';
                isDTO.ISSUETYPE = caseRec.IssueTypecode__c != null ? caseRec.IssueTypecode__c : '';
                isDTO.GROUPCODE = caseRec.GroupCodeID__c != null ? caseRec.GroupCodeID__c : '';
                isDTO.REASON = caseRec.ReasonCode__c != null ? caseRec.ReasonCode__c : '';
                isDTO.CAUSE = caseRec.CauseCode__c != null ? caseRec.CauseCode__c : '';
                isDTO.UPC = caseRec.UPC_code__c != null ? caseRec.UPC_code__c : '';
                isDTO.BRAND = caseRec.BrandID__c != null ? caseRec.BrandID__c : '';
                isDTO.TASTE = caseRec.Taste__c != null ? caseRec.Taste__c : '';
                isDTO.LENGTHCODE = caseRec.Length_Code__c != null ? caseRec.Length_Code__c : '';
                isDTO.PACKAGING = caseRec.Packaging__c != null ? caseRec.Packaging__c : '';
                isDTO.FLAVOR = caseRec.Flavor__c != null ? caseRec.Flavor__c : '';
                isDTO.FILTER = caseRec.Filter__c != null ? caseRec.Filter__c : '';
                isDTO.PAPERTYPE = caseRec.Paper_Type__c != null ? caseRec.Paper_Type__c : '';
                isDTO.CUT = caseRec.Cut__c != null ? caseRec.Cut__c : '';
                isDTO.SUSPECTEDCOUNTERFIET = caseRec.Suspected_Counterfiet__c != null ? String.valueOf(caseRec.Suspected_Counterfiet__c) : '';
                isDTO.STORETYPECODE = caseRec.StoreTypeCode__c != null ? caseRec.StoreTypeCode__c : '';
                isDTO.STORENAME = caseRec.StoreName__c != null ? caseRec.StoreName__c : '';
                isDTO.STOREADDR1 = caseRec.StoreAddr1_Feed__c != null ? caseRec.StoreAddr1_Feed__c : '';
                isDTO.STOREADDR2 = caseRec.StoreAddr2__c != null ? caseRec.StoreAddr2__c : '';
                isDTO.STORECITY = caseRec.StoreCity__c != null ? caseRec.StoreCity__c : '';
                isDTO.STORESTATE = caseRec.StoreState__c != null ? caseRec.StoreState__c : '';
                isDTO.STOREZIP = caseRec.StoreZip__c != null ? caseRec.StoreZip__c : '';
                isDTO.STOREZIP4 = caseRec.StoreZip4__c != null ? caseRec.StoreZip4__c : '';
                isDTO.PURCHASETYPE = caseRec.Purchase_Type__c != null ? caseRec.Purchase_Type__c : '';
                isDTO.PURCHASEDATE = caseRec.PurchaseDateFeed__c != null ? caseRec.PurchaseDateFeed__c : '';
                if(caseRec.Incident_Date__c != null) {
                    d = caseRec.Incident_Date__c.day();
                    mo = caseRec.Incident_Date__c.month();
                    yr = caseRec.Incident_Date__c.year();
                    
                    DateTime dt = DateTime.newInstance(yr, mo, d);
                    isDTO.INCIDENTDATE =  dt.format('MM/dd/yyyy HH:mm:ss') ;
                } else {
                    isDTO.INCIDENTDATE = '';
                }
                isDTO.EXPECTEDTYPE = caseRec.Expected_Type__c != null ? caseRec.Expected_Type__c : '';
                isDTO.AFFECTEDTYPE = caseRec.Affected_Type__c != null ? caseRec.Affected_Type__c : '';
                isDTO.MFGDATECODE = caseRec.Mfg_Trace_code__c != null ? caseRec.Mfg_Trace_code__c : '';
                isDTO.PRODUCTIONDATE = caseRec.ProductionDateFeed__c != null ? caseRec.ProductionDateFeed__c : '';
                isDTO.PRIMARYCRCISSUEDETAILID = caseRec.Primary_Crc_Issue_Detail_Id__c != null ? caseRec.Primary_Crc_Issue_Detail_Id__c : '';
                isDTO.REIMBURSEDFLAG = caseRec.ReimbursedFlagFeed__c != null ? caseRec.ReimbursedFlagFeed__c : '';
                isDTO.DATECODEPRODUCTIONDATE = caseRec.DateCodeProductionDateFeed__c != null ? caseRec.DateCodeProductionDateFeed__c : '';
                isDTO.DATECODELOCATION = caseRec.DateCodeLocation__c != null ? caseRec.DateCodeLocation__c : '';
                isDTO.DATECODESHIFT = caseRec.DateCodeShift__c != null ? caseRec.DateCodeShift__c : '';
                isDTO.DATECODEUNIT = caseRec.DateCodeUnit__c != null ? caseRec.DateCodeUnit__c : '';
                isDTO.DATECODECOLDSTORAGE = caseRec.DateCodeColdStorage__c != null ? caseRec.DateCodeColdStorage__c : '';
                isDTO.DATECODERPTBAY = caseRec.DateCodeRptBay__c != null ? caseRec.DateCodeRptBay__c : '';
                isDTO.DATECODERPTFACTORY = caseRec.DateCodeRptFactory__c != null ? caseRec.DateCodeRptFactory__c : '';
                isDTO.DATECODEMILITARYTIME = caseRec.DateCodeMilitaryTime__c != null ? caseRec.DateCodeMilitaryTime__c : '';
                isDTO.VALIDTRACECODE = caseRec.ValidTraceCodeFeed__c != null ? caseRec.ValidTraceCodeFeed__c : '';
                isDTO.USTDATECODE = caseRec.Date_Code__c != null ? caseRec.Date_Code__c : '';
                isDTO.USTDATECODETYPE = caseRec.Date_Type__c != null ? caseRec.Date_Type__c : '';
                isDTO.USTDATE = caseRec.UstDate__c != null ? caseRec.UstDate__c : '';
                isDTO.VALIDUSTDATECODE = caseRec.ValidUstDateCodeFeed__c != null ? caseRec.ValidUstDateCodeFeed__c : '';
                isDTO.SUSPECTEDTAMPERING = caseRec.Suspected_Tampering__c != null ? String.valueOf(caseRec.Suspected_Tampering__c) : '';
                isDTO.RELATEDIUSSENO = caseRec.Related_Issue__c != null ? caseRec.Related_Issue__c : '';
                isDTO.JMCMACHINECODE = caseRec.Machine_Code__c != null ? caseRec.Machine_Code__c : '';
                isDTO.CONTACTTYPE = caseRec.ContactType__c != null ? caseRec.ContactType__c : '';
                isDTO.RESHIPFLAG = caseRec.ReshipFlag__c != null ? caseRec.ReshipFlag__c : '';
                isDTO.MAJORSYMPTOM = caseRec.MajorSymptomFeed__c != null ? caseRec.MajorSymptomFeed__c : '';
                isDTO.THIRDPARTYCONTACTED = caseRec.ThirdPartyContactedFeed__c != null ? caseRec.ThirdPartyContactedFeed__c : '';
                isDTO.CCEXP = caseRec.CcExp__c != null ? caseRec.CcExp__c : '';
                isDTO.CCNUM = caseRec.CcNum__c != null ? caseRec.CcNum__c : '';
                isDTO.CCSECCODE = caseRec.CcSecCode__c != null ? caseRec.CcSecCode__c : '';
                isDTO.INVENTORYDEPLETED = caseRec.Inventory_Depleted__c != null ? String.valueOf(caseRec.Inventory_Depleted__c) : '';
                isDTO.TRACECODELOCATION = caseRec.Trace_Code_Location__c != null ? caseRec.Trace_Code_Location__c : '';
                isDTO.CALLERNAME = caseRec.Caller_Name__c != null ? caseRec.Caller_Name__c : '';
                isDTO.SUPPLIERNAME = caseRec.Supplier_Name__c != null ? caseRec.Supplier_Name__c : '';
                isDTO.CONSUMERRETURN = caseRec.Consumer_Return__c != null ? String.valueOf(caseRec.Consumer_Return__c) : '';
                isDTO.EMAILGENFLAG = caseRec.EmailgenFlag__c != null ? caseRec.EmailgenFlag__c : '';
                isDTO.COMMENTS = caseRec.Comment__c!= null ? caseRec.Comment__c: '';
                isDTO.STORECOMMENTS = caseRec.StoreComments__c != null ? caseRec.StoreComments__c : '';
                isDTO.UPDATEREASON = caseRec.UpdateReasonFeed__c != null ? caseRec.UpdateReasonFeed__c : '';
                isDTO.RESHIPREASON = caseRec.ReshipReason__c != null ? caseRec.ReshipReason__c : '';
                isDTO.CONSUMERRETURNNOTES = caseRec.ConsumerReturnNotesFeed__c != null ? caseRec.ConsumerReturnNotesFeed__c : '';
                isDTO.CALLKEYWORDS = caseRec.Consumer_Mentions__c != null ? caseRec.Consumer_Mentions__c : '';
                isDTO.CRCEMAILALERTID = caseRec.EmailAlertId__c != null ? caseRec.EmailAlertId__c : '';
                isDTO.PURCHASEPRICE = caseRec.Purchase_Price__c != null ? String.valueOf(caseRec.Purchase_Price__c) : '';
                isDTO.PURCHASEQTY = caseRec.PurchaseQtyFeed__c != null ? caseRec.PurchaseQtyFeed__c : '';
                isDTO.EXPECTEDQTY = caseRec.ExpectedQtyFeed__c != null ? caseRec.ExpectedQtyFeed__c : '';
                isDTO.AFFECTEDQTY = caseRec.AffectedQtyFeed__c != null ? caseRec.AffectedQtyFeed__c : '';
                isDTO.EXPRETURNTOTALCOST = caseRec.ExpReturnTotalCost__c != null ? caseRec.ExpReturnTotalCost__c : '';
                isDTO.RESHIPDATE = caseRec.ReshipDate__c != null ? caseRec.ReshipDate__c : '';
                isDTO.EMAILGENDATE = caseRec.EmailGenDate__c != null ? caseRec.EmailGenDate__c : '';
                isDTO.YEARMONTHMODULE = caseRec.YearMonthModule__c != null ? caseRec.YearMonthModule__c : '';
                isDTO.OVERAGE = caseRec.Overage__c != null ? caseRec.Overage__c : '';
                isDTO.PRODUCTAGE = caseRec.ProductAge__c != null ? caseRec.ProductAge__c : '';
                isDTO.RECOMMENDEDUSAGEBASEDONAGE = caseRec.RecommendedUsageBasedOnAge__c != null ? caseRec.RecommendedUsageBasedOnAge__c : '';
                isDTO.CONTACTCHANNEL = caseRec.Channel_Contact__c != null ? caseRec.Channel_Contact__c : '';
                isDTO.RETURNREIMBURSEMENTREQUEST = caseRec.ReturnReimbursementRequest__c != null ? caseRec.ReturnReimbursementRequest__c : '';
                isDTO.OBOUNDTRACKINGNO = caseRec.Outbound_Tracking__c != null ? caseRec.Outbound_Tracking__c : '';
                isDTO.INDBOUNDTRACKINGNO = caseRec.Inbound_Tracking__c != null ? caseRec.Inbound_Tracking__c : '';
                isDTO.MASTERISSUEID = caseRec.MasterId__c != null ? caseRec.MasterId__c : '';
                isDTO.REFERENCEID = caseRec.NMI_Transaction_ID__c != null ? caseRec.NMI_Transaction_ID__c : '';
                isDTO.IQOS_REF_ID = caseRec.IQOS_Reference_ID__c != null ? caseRec.IQOS_Reference_ID__c : '';
                isDTO.SERIAL_NUMBER = caseRec.Serial_Number__c != null ? caseRec.Serial_Number__c : '';
                //WARRANTY_START_DATE
                if(caseRec.Warranty_Start_Date__c != null) {
                    d = caseRec.Warranty_Start_Date__c.day();
                    mo = caseRec.Warranty_Start_Date__c.month();
                    yr = caseRec.Warranty_Start_Date__c.year();
                    
                    DateTime dt = DateTime.newInstance(yr, mo, d);
                    isDTO.WARRANTY_START_DATE =  dt.format('MM/dd/yyyy HH:mm:ss') ;
                } else {
                    isDTO.WARRANTY_START_DATE = '';
                }
                //WARRANTY_EXPIRATION_DATE
                if(caseRec.Warranty_Expiration_Date__c != null) {
                    d = caseRec.Warranty_Expiration_Date__c.day();
                    mo = caseRec.Warranty_Expiration_Date__c.month();
                    yr = caseRec.Warranty_Expiration_Date__c.year();
                    
                    DateTime dt = DateTime.newInstance(yr, mo, d);
                    isDTO.WARRANTY_EXPIRATION_DATE =  dt.format('MM/dd/yyyy HH:mm:ss') ;
                } else {
                    isDTO.WARRANTY_EXPIRATION_DATE = '';
                }
                isDTO.WARRANTY_STATUS = caseRec.Warranty_Status__c != null ? caseRec.Warranty_Status__c : '';
                isDTO.CEA_AGENT_ID = caseRec.CEA_Agent_ID__c != null ? caseRec.CEA_Agent_ID__c : '';
                isDTO.COMPLAINT_SOURCE = caseRec.Complaint_Source__c != null ? caseRec.Complaint_Source__c : '';
                //TestIssue
                if(caseRec.Test_Issue__c != null && caseRec.Test_Issue__c) {
                    isDTO.TestIssue = '1';
                } else if(caseRec.Test_Issue__c != null && !caseRec.Test_Issue__c) {
                    isDTO.TestIssue = '0';
                } else if(caseRec.Test_Issue__c == null) {
                    isDTO.TestIssue = '';
                }
                isDTO.CounterfeitCodeLookup = caseRec.CounterfeitCodeLookup__c != null ? caseRec.CounterfeitCodeLookup__c : '';
                //ReportingNoteLegal
                if(caseRec.ReportingNoteLegal__c != null && caseRec.ReportingNoteLegal__c) {
                    isDTO.ReportingNoteLegal = '1';
                } else if(caseRec.ReportingNoteLegal__c != null && !caseRec.ReportingNoteLegal__c) {
                    isDTO.ReportingNoteLegal = '0';
                } else if(caseRec.ReportingNoteLegal__c == null) {
                    isDTO.ReportingNoteLegal = '';
                }
                //ReportingNoteSC
                if(caseRec.ReportingNoteSC__c != null && caseRec.ReportingNoteSC__c) {
                    isDTO.ReportingNoteSC = '1';
                } else if(caseRec.ReportingNoteSC__c != null && !caseRec.ReportingNoteSC__c) {
                    isDTO.ReportingNoteSC = '0';
                } else if(caseRec.ReportingNoteSC__c == null) {
                    isDTO.ReportingNoteSC = '';
                }
                //ReportingNoteBrandIntegrity
                if(caseRec.ReportingNoteBrandIntegrity__c != null && caseRec.ReportingNoteBrandIntegrity__c) {
                    isDTO.ReportingNoteBrandIntegrity = '1';
                } else if(caseRec.ReportingNoteBrandIntegrity__c != null && !caseRec.ReportingNoteBrandIntegrity__c) {
                    isDTO.ReportingNoteBrandIntegrity = '0';
                } else if(caseRec.ReportingNoteBrandIntegrity__c == null) {
                    isDTO.ReportingNoteBrandIntegrity = '';
                }
                isDTO.Line = caseRec.Line__c != null ? caseRec.Line__c : '';
                //Complaints
                if(caseRec.Complaints__c != null && caseRec.Complaints__c) {
                    isDTO.Complaints = '1';
                } else if(caseRec.Complaints__c != null && !caseRec.Complaints__c) {
                    isDTO.Complaints = '0';
                } else if(caseRec.Complaints__c == null) {
                    isDTO.Complaints = '';
                }
                //Contact
                if(caseRec.Contacts__c != null && caseRec.Contacts__c) {
                    isDTO.Contact = '1';
                } else if(caseRec.Contacts__c != null && !caseRec.Contacts__c) {
                    isDTO.Contact = '0';
                } else if(caseRec.Contacts__c == null) {
                    isDTO.Contact = '';
                }
                isDTO.UCID = caseRec.UCID__c != null ? caseRec.UCID__c : '';
                //Factory_Controllable
                if(caseRec.PMUSA_Factory_Controllable__c != null && caseRec.PMUSA_Factory_Controllable__c) {
                    isDTO.Factory_Controllable = '1';
                } else if(caseRec.PMUSA_Factory_Controllable__c != null && !caseRec.PMUSA_Factory_Controllable__c) {
                    isDTO.Factory_Controllable = '0';
                } else if(caseRec.PMUSA_Factory_Controllable__c == null) {
                    isDTO.Factory_Controllable = '';
                }
                isDTO.Shortcut = caseRec.Shortcut__c != null ? caseRec.Shortcut__c : '';
                
                issueDTOList.add(isDTO);

                contactIdSet.add(caseRec.ContactId);
                issueIdSet.add(caseRec.Id);
            }
        }
        
        if(!contactIdSet.isEmpty()) {
            for(Contact conRec : [SELECT Id, CustomerID__c, CCN__c, TenantId__c, FirstName, Salutation, MiddleInitial__c, MiddleName__c, 
                                 LastName, Suffix__c, CreatedBy.CommunityNickname, CreatedDate__c, CreatedSource__c, LastModifiedBy.CommunityNickname, 
                                 LastModifiedDate__c, ModifiedSource__c, Active__c, Gender__c, DOB_Feed__c, CustomerTypeCode__c, AVF_GIID_Received__c,
                                 Repeat_Complainer__c, Age_Verified_Date_Feed__c, Repeat_Complainer_Date_Feed__c, ArchiveFlag__c,
                                 Company_Name__c, DBA_Name__c, Store__c, Account_No__c, Retail_control__c, Territory__c, Direct_Purchase__c, 
                                 Hours_of_operation__c, ALSD_Rep__c, Age_Verification_Source__c, Study_ID__c, Participant_ID__c, Blinding_Code__c,
                                 Research_Company__c, Research_Location__c, Participation_Date__c, Project_Flavor_Type__c, Research_Panelist_ID__c,
                                 Customer_Has_Product__c, Research_Panelist_Notes__c, ConsumerOrCustomer__c, Customer_Detail_ID__c, EnvCode__c,
                                 RecordType.Name, Is_Primary__c, Street_Address__c, Apt_Lot__c, City__c, State__c, Zip_Code__c, Zip4__c, Phone,
                                 OtherPhone, MobilePhone, Fax, Email, Operating_Company__c, ProfileUpdType__c, Country__c FROM Contact WHERE Id IN :contactIdSet]) {
                
                //CustomerDTO
                customerDTO cusDTO = new customerDTO();
                                     
                cusDTO.CUSTOMERID = conRec.CustomerID__c != null ? conRec.CustomerID__c : '';
                cusDTO.CUSTOMERNO = conRec.CCN__c != null ? conRec.CCN__c : '';
                cusDTO.TENANTID = conRec.TenantId__c != null ? conRec.TenantId__c : '';
                cusDTO.FIRSTNAME = conRec.FirstName != null ? conRec.FirstName : '';
                cusDTO.PREFIXCODE = conRec.Salutation != null ? conRec.Salutation : '';
                cusDTO.MIDDLEINITIAL = conRec.MiddleInitial__c != null ? conRec.MiddleInitial__c : '';
                cusDTO.MIDDLENAME = conRec.MiddleName__c != null ? conRec.MiddleName__c : '';
                cusDTO.LASTNAME = conRec.LastName != null ? conRec.LastName : '';
                cusDTO.SUFFIXCODE = conRec.Suffix__c != null ? conRec.Suffix__c : '';
                cusDTO.CREATEDBY = conRec.CreatedBy.CommunityNickname != null ? conRec.CreatedBy.CommunityNickname : '';
                cusDTO.CREATEDDATE = conRec.CreatedDate__c != null ? conRec.CreatedDate__c : '';
                cusDTO.CREATEDSOURCE = conRec.CreatedSource__c != null ? conRec.CreatedSource__c : '';
                cusDTO.MODIFIEDBY = conRec.LastModifiedBy.CommunityNickname != null ? conRec.LastModifiedBy.CommunityNickname : '';
                cusDTO.MODIFIEDDATE = conRec.LastModifiedDate__c != null ? conRec.LastModifiedDate__c : '';
                cusDTO.MODIFIEDSOURCE = conRec.ModifiedSource__c != null ? conRec.ModifiedSource__c : '';
                //ACTIVEFLAG
                if(conRec.Active__c != null && conRec.Active__c) {
                    cusDTO.ACTIVEFLAG = '1';
                } else if(conRec.Active__c != null && !conRec.Active__c) {
                    cusDTO.ACTIVEFLAG = '0';
                } else if(conRec.Active__c == null) {
                    cusDTO.ACTIVEFLAG = '';
                }
                cusDTO.GENDER = conRec.Gender__c != null ? conRec.Gender__c : '';
                cusDTO.DATEOFBIRTH = conRec.DOB_Feed__c != null ? conRec.DOB_Feed__c : '';
                cusDTO.CUSTOMERTYPE = conRec.CustomerTypeCode__c != null ? conRec.CustomerTypeCode__c : '';
                //CRCAVFRECIEVEDFLAG
                if(conRec.AVF_GIID_Received__c != null && conRec.AVF_GIID_Received__c) {
                    cusDTO.CRCAVFRECIEVEDFLAG = '1';
                } else if(conRec.AVF_GIID_Received__c != null && !conRec.AVF_GIID_Received__c) {
                    cusDTO.CRCAVFRECIEVEDFLAG = '0';
                } else if(conRec.AVF_GIID_Received__c == null) {
                    cusDTO.CRCAVFRECIEVEDFLAG = '';
                }
                //CRCREPEATCOMPLAINER
                if(conRec.Repeat_Complainer__c != null && conRec.Repeat_Complainer__c) {
                    cusDTO.CRCREPEATCOMPLAINER = '1';
                } else if(conRec.Repeat_Complainer__c != null && !conRec.Repeat_Complainer__c) {
                    cusDTO.CRCREPEATCOMPLAINER = '0';
                } else if(conRec.Repeat_Complainer__c == null) {
                    cusDTO.CRCREPEATCOMPLAINER = '';
                }
                cusDTO.CRCAVDATE = conRec.Age_Verified_Date_Feed__c != null ? conRec.Age_Verified_Date_Feed__c : '';
                cusDTO.CRCREPEATCOMPALINERFROM = conRec.Repeat_Complainer_Date_Feed__c != null ? conRec.Repeat_Complainer_Date_Feed__c : '';
                cusDTO.ARCHIVEFLAG = conRec.ArchiveFlag__c != null ? conRec.ArchiveFlag__c : '';
                cusDTO.COMPANYNAME = conRec.Company_Name__c != null ? conRec.Company_Name__c : '';
                cusDTO.DBANAME = conRec.DBA_Name__c != null ? conRec.DBA_Name__c : '';
                cusDTO.STORENO = conRec.Store__c != null ? conRec.Store__c : '';
                cusDTO.ACCOUNTNO = conRec.Account_No__c != null ? conRec.Account_No__c : '';
                cusDTO.RETAILCONTROLNO = conRec.Retail_control__c != null ? conRec.Retail_control__c : '';
                cusDTO.TERRITORYNO = conRec.Territory__c != null ? conRec.Territory__c : '';
                cusDTO.DIRECTPURCHASE = conRec.Direct_Purchase__c != null ? conRec.Direct_Purchase__c : '';
                cusDTO.HOURSOFOPERATION = conRec.Hours_of_operation__c != null ? conRec.Hours_of_operation__c : '';
                cusDTO.ALSDREP = conRec.ALSD_Rep__c != null ? conRec.ALSD_Rep__c : '';
                cusDTO.AGEVERIFIED_SRC = conRec.Age_Verification_Source__c != null ? conRec.Age_Verification_Source__c : '';
                cusDTO.STUDY_ID = conRec.Study_ID__c != null ? conRec.Study_ID__c : '';
                cusDTO.RESEARCH_PARTICIPANT_ID = conRec.Participant_ID__c != null ? conRec.Participant_ID__c : '';
                cusDTO.BLINDING_CODE = conRec.Blinding_Code__c != null ? conRec.Blinding_Code__c : '';
                cusDTO.RESEARCH_COMPANY = conRec.Research_Company__c != null ? conRec.Research_Company__c : '';
                cusDTO.RESEARCH_LOCATION = conRec.Research_Location__c != null ? conRec.Research_Location__c : '';
                cusDTO.PARTICIPATION_DATE = conRec.Participation_Date__c != null ? conRec.Participation_Date__c : '';
                cusDTO.PRODUCT_FLAVOR = conRec.Project_Flavor_Type__c != null ? conRec.Project_Flavor_Type__c : '';
                cusDTO.RESEARCH_PANELIST_ID = conRec.Research_Panelist_ID__c != null ? conRec.Research_Panelist_ID__c : '';
                //CUSTOMER_HAS_PRODUCT
                if(conRec.Customer_Has_Product__c != null && conRec.Customer_Has_Product__c) {
                    cusDTO.CUSTOMER_HAS_PRODUCT = '1';
                } else if(conRec.Customer_Has_Product__c != null && !conRec.Customer_Has_Product__c) {
                    cusDTO.CUSTOMER_HAS_PRODUCT = '0';
                } else if(conRec.Customer_Has_Product__c == null) {
                    cusDTO.CUSTOMER_HAS_PRODUCT = '';
                }
                cusDTO.RESEARCH_PANELIST_NOTES = conRec.Research_Panelist_Notes__c != null ? conRec.Research_Panelist_Notes__c : '';
                cusDTO.CONSUMERORCUSTOMER = conRec.ConsumerOrCustomer__c != null ? conRec.ConsumerOrCustomer__c : '';
                                     
                customerDTOList.add(cusDTO);
                                     
                //CustomerDetailsDTO
                customerDetailsDTO cdDTO = new customerDetailsDTO();
                                     
                cdDTO.CustomerDetailId = conRec.Customer_Detail_ID__c != null ? conRec.Customer_Detail_ID__c : '';
                cdDTO.Tenantid = conRec.TenantId__c != null ? conRec.TenantId__c : '';
                cdDTO.EnvCode = conRec.EnvCode__c != null ? conRec.EnvCode__c : '';
                cdDTO.CustomerID = conRec.CustomerID__c != null ? conRec.CustomerID__c : '';
                cdDTO.RecordType = conRec.RecordType.Name != null ? conRec.RecordType.Name : '';
                cdDTO.IsPrimary = conRec.Is_Primary__c != null ? conRec.Is_Primary__c : '';
                //ActiveFlag
                if(conRec.Active__c != null && conRec.Active__c) {
                    cdDTO.ActiveFlag = '1';
                } else if(conRec.Active__c != null && !conRec.Active__c) {
                    cdDTO.ActiveFlag = '0';
                } else if(conRec.Active__c == null) {
                    cdDTO.ActiveFlag = '';
                }
                cdDTO.Address1 = conRec.Street_Address__c != null ? conRec.Street_Address__c : '';
                cdDTO.Address2 = conRec.Apt_Lot__c != null ? conRec.Apt_Lot__c : '';
                cdDTO.City = conRec.City__c != null ? conRec.City__c : '';
                cdDTO.State = conRec.State__c != null ? conRec.State__c : '';
                cdDTO.Zip = conRec.Zip_Code__c != null ? conRec.Zip_Code__c : '';
                cdDTO.Zip4 = conRec.Zip4__c != null ? conRec.Zip4__c : '';
                cdDTO.PhoneNo = conRec.Phone != null ? conRec.Phone : '';
                cdDTO.AltPhone = conRec.OtherPhone != null ? conRec.OtherPhone : '';
                cdDTO.MobileNo = conRec.MobilePhone != null ? conRec.MobilePhone : '';
                cdDTO.Faxno = conRec.Fax != null ? conRec.Fax : '';
                cdDTO.Email = conRec.Email != null ? conRec.Email : '';
                cdDTO.CreatedDate = conRec.CreatedDate__c != null ? conRec.CreatedDate__c : '';
                cdDTO.CreatedBy = conRec.CreatedBy.CommunityNickname != null ? conRec.CreatedBy.CommunityNickname : '';
                cdDTO.ModifiedDate = conRec.LastModifiedDate__c != null ? conRec.LastModifiedDate__c : '';
                cdDTO.ModifiedBy = conRec.LastModifiedBy.CommunityNickname != null ? conRec.LastModifiedBy.CommunityNickname : '';
                cdDTO.OpCompanyCode = conRec.Operating_Company__c != null ? conRec.Operating_Company__c : '';
                cdDTO.ProfileUpdType = conRec.ProfileUpdType__c != null ? conRec.ProfileUpdType__c : '';
                cdDTO.ArchivedFlag = conRec.ArchiveFlag__c != null ? conRec.ArchiveFlag__c : '';
                cdDTO.Country = conRec.Country__c != null ? conRec.Country__c : '';
                                     
                customerDetailsDTOList.add(cdDTO);
            }
        }
        
        if(!issueIdSet.isEmpty()) {
            //Store Info
            for(Store__c storeRec : [SELECT Id, IssueID__c, TransacationID__c, Store_Type_Text__c, Store_Name__c, Store_Address1__c, Store_Address2__c,
                                    Store_City__c, Store_State__c, Store_Zip__c, Store_Zip4__c, StoreCommentFeed__c, LastModifiedBy.CommunityNickname,
                                    LastModifiedDate__c, Name FROM Store__c WHERE Issue__c IN :issueIdSet]) {

                storeInfoDTO storeDTO = new storeInfoDTO();
                                        
                storeDTO.CRCIssueId = storeRec.IssueID__c != null ? storeRec.IssueID__c : '';
                storeDTO.ContactId = storeRec.TransacationID__c != null ? storeRec.TransacationID__c : '';
                storeDTO.StoreTypeCode = storeRec.Store_Type_Text__c != null ? storeRec.Store_Type_Text__c : '';
                storeDTO.StoreName = storeRec.Store_Name__c != null ? storeRec.Store_Name__c : '';
                storeDTO.StoreAddr1 = storeRec.Store_Address1__c != null ? storeRec.Store_Address1__c : '';
                storeDTO.StoreAddr2 = storeRec.Store_Address2__c != null ? storeRec.Store_Address2__c : '';
                storeDTO.StoreCity = storeRec.Store_City__c != null ? storeRec.Store_City__c : '';
                storeDTO.StoreState = storeRec.Store_State__c != null ? storeRec.Store_State__c : '';
                storeDTO.StoreZip = storeRec.Store_Zip__c != null ? storeRec.Store_Zip__c : '';
                storeDTO.StoreZip4 = storeRec.Store_Zip4__c != null ? storeRec.Store_Zip4__c : '';
                storeDTO.StoreComments = storeRec.StoreCommentFeed__c != null ? storeRec.StoreCommentFeed__c : '';
                storeDTO.ModifiedBy = storeRec.LastModifiedBy.CommunityNickname != null ? storeRec.LastModifiedBy.CommunityNickname : '';
                storeDTO.ModifiedDate = storeRec.LastModifiedDate__c != null ? storeRec.LastModifiedDate__c : '';
                storeDTO.IssueStoreId = storeRec.Name != null ? storeRec.Name : '';
                                        
                storeInfoDTOList.add(storeDTO);
            }
            
            //Issue Survey
            for(Survey_Issue__c siRec : [SELECT Id, Issue_Id__c, Transacation_Id__c, SurveyID__c, Question_ID__c, QuestionText__c, Answer_ID__c,
                                         AnswerText__c , Comment__c, Question_Sequence__c, Answer_Sequence__c FROM Survey_Issue__c WHERE isActive__c = true and Issue__c IN :issueIdSet]) {
                     
                issueSurveyDTO isDTO = new issueSurveyDTO();
                                             
                isDTO.CRCISSUEID = siRec.Issue_Id__c != null ? siRec.Issue_Id__c : '';
                isDTO.CONTACTID = siRec.Transacation_Id__c != null ? siRec.Transacation_Id__c : '';
                isDTO.SURVEYID = siRec.SurveyID__c != null ? siRec.SurveyID__c : '';
                isDTO.SURVEYQUESTIONID = siRec.Question_ID__c != null ? siRec.Question_ID__c : '';
                isDTO.SURVEYQUESTIONTEXT = siRec.QuestionText__c!= null ? siRec.QuestionText__c: '';
                isDTO.SURVERYANSWERID = siRec.Answer_ID__c != null ? siRec.Answer_ID__c : '';
                isDTO.SURVEYANSWERTEXT = siRec.AnswerText__c != null ? siRec.AnswerText__c: '';
                isDTO.ANSWERCOMMENTS = siRec.Comment__c != null ? siRec.Comment__c: '';
                isDTO.QUESTSEQUENCE = siRec.Question_Sequence__c != null ? String.valueOf(siRec.Question_Sequence__c) : '';
                isDTO.ANSSEQUENCE = siRec.Answer_Sequence__c != null ? String.valueOf(siRec.Answer_Sequence__c) : '';
                                             
                issueSurveyDTOList.add(isDTO);
            }
            
            //Reimbursement
            for(Reimbursement__c reRec : [SELECT Id, Tenant_Id__c, CustomerID__c, TransactionIdName__c, TransactionManagementHistoryID__c,
                                         IssueID__c, CreatedDate__c, CreatedBy.CommunityNickname, OpCo__c, BrandCode__c, Coupon_Qty__c, Cheque_Amount__c,
                                         ProgramCode__c, PackageCode__c, Coupon__c, Reimbursement_Type__c, FulfillDate__c, ReshipDate__c, ExtractDateFeed__c,
                                         Consumer__r.Street_Address__c, Consumer__r.Apt_Lot__c, Consumer__r.City__c, Consumer__r.State__c,
                                         Consumer__r.Zip_Code__c, Consumer__r.Zip4__c FROM Reimbursement__c WHERE Issue__c IN :issueIdSet]) {
                                             
                reimbursementDTO reDTO = new reimbursementDTO();
                                             
                reDTO.TENANTID = reRec.Tenant_Id__c != null ? reRec.Tenant_Id__c : '';
                reDTO.CUSTOMERID = reRec.CustomerID__c != null ? reRec.CustomerID__c : '';
                reDTO.CONTACTID = reRec.TransactionIdName__c != null ? reRec.TransactionIdName__c : '';
                reDTO.CONTACTSERVICEREQUESTID = reRec.TransactionManagementHistoryID__c != null ? reRec.TransactionManagementHistoryID__c : '';
                reDTO.CRCISSUEID = reRec.IssueID__c != null ? reRec.IssueID__c : '';
                reDTO.REIMBCREATEDDATE = reRec.CreatedDate__c != null ? reRec.CreatedDate__c : '';
                reDTO.REIMBCREATEDBY = reRec.CreatedBy.CommunityNickname != null ? reRec.CreatedBy.CommunityNickname : '';
                reDTO.OPCO = reRec.OpCo__c != null ? reRec.OpCo__c : '';
                reDTO.BRAND = reRec.BrandCode__c != null ? reRec.BrandCode__c : '';
                reDTO.COUPONQTY = reRec.Coupon_Qty__c != null ? reRec.Coupon_Qty__c : '';
                reDTO.CHKAMT = reRec.Cheque_Amount__c != null ? String.valueOf(reRec.Cheque_Amount__c) : '';
                reDTO.PROGRAMCODE = reRec.ProgramCode__c != null ? reRec.ProgramCode__c : '';
                reDTO.PACKAGECODE = reRec.PackageCode__c != null ? reRec.PackageCode__c : '';
                reDTO.COUPON = reRec.Coupon__c != null ? reRec.Coupon__c : '';
                reDTO.REIMBTYPE = reRec.Reimbursement_Type__c != null ? reRec.Reimbursement_Type__c : '';
                //FULFILLDATE
                if(reRec.FulfillDate__c != null) {
                    d = reRec.FulfillDate__c.day();
                    mo = reRec.FulfillDate__c.month();
                    yr = reRec.FulfillDate__c.year();
                    
                    DateTime dt = DateTime.newInstance(yr, mo, d);
                    reDTO.FULFILLDATE =  dt.format('MM/dd/yyyy HH:mm:ss') ;
                } else {
                    reDTO.FULFILLDATE = '';
                }
                //RESHIPDATE
                if(reRec.ReshipDate__c != null) {
                    d = reRec.ReshipDate__c.day();
                    mo = reRec.ReshipDate__c.month();
                    yr = reRec.ReshipDate__c.year();
                    
                    DateTime dt = DateTime.newInstance(yr, mo, d);
                    reDTO.RESHIPDATE =  dt.format('MM/dd/yyyy HH:mm:ss') ;
                } else {
                    reDTO.RESHIPDATE = '';
                }
                reDTO.EXTRACTDATE = reRec.ExtractDateFeed__c != null ? reRec.ExtractDateFeed__c : '';
                reDTO.MAILTOADDRESS1 = reRec.Consumer__r.Street_Address__c != null ? reRec.Consumer__r.Street_Address__c : '';
                reDTO.MAILTOADDRESS2 = reRec.Consumer__r.Apt_Lot__c != null ? reRec.Consumer__r.Apt_Lot__c : '';
                reDTO.MAILTOADDRESSCITY = reRec.Consumer__r.City__c != null ? reRec.Consumer__r.City__c : '';
                reDTO.MAILTOADDRESSSTATE = reRec.Consumer__r.State__c != null ? reRec.Consumer__r.State__c : '';
                reDTO.MAILTOADDRESSZIP = reRec.Consumer__r.Zip_Code__c != null ? reRec.Consumer__r.Zip_Code__c : '';
                reDTO.MAILTOADDRESSZIP4 = reRec.Consumer__r.Zip4__c != null ? reRec.Consumer__r.Zip4__c : '';
                                             
                reimbursementDTOList.add(reDTO);
            }
            
            //IssueAttachment
            for(Attachment_Detail__c adRec : [SELECT Id, Name, IssueID__c, DescriptionFeed__c, Attachment_Name__c, IsActive__c, CreatedBy.CommunityNickname,
                                             CreatedDate__c, LastModifiedBy.CommunityNickname, LastModifiedDate__c FROM Attachment_Detail__c WHERE Issue__c IN :issueIdSet]) {
            
                issueAttachmentDTO iaDTO = new issueAttachmentDTO();
                                                 
                iaDTO.ISSUEATTACHMENTID = adRec.Name != null ? adRec.Name : '';
                iaDTO.ISSUEID = adRec.IssueID__c != null ? adRec.IssueID__c : '';
                iaDTO.DESCRIPTION = adRec.DescriptionFeed__c != null ? adRec.DescriptionFeed__c : '';
                iaDTO.ATTACHMENTNAME = adRec.Attachment_Name__c != null ? adRec.Attachment_Name__c : '';
                //ACTIVEFLAG
                if(adRec.IsActive__c != null && adRec.IsActive__c) {
                    iaDTO.ACTIVEFLAG = 'Y';
                } else if(adRec.IsActive__c != null && !adRec.IsActive__c) {
                    iaDTO.ACTIVEFLAG = 'N';
                } else if(adRec.IsActive__c == null) {
                    iaDTO.ACTIVEFLAG = '';
                }
                iaDTO.CREATEDBY = adRec.CreatedBy.CommunityNickname != null ? adRec.CreatedBy.CommunityNickname : '';
                iaDTO.CREATEDDATE = adRec.CreatedDate__c != null ? adRec.CreatedDate__c : '';
                iaDTO.MODIFIEDBY = adRec.LastModifiedBy.CommunityNickname != null ? adRec.LastModifiedBy.CommunityNickname : '';
                iaDTO.MODIFIEDDATE = adRec.LastModifiedDate__c != null ? adRec.LastModifiedDate__c : '';
                                                 
                issueAttachmentDTOList.add(iaDTO);
            }
        }
        
        if(!issueDTOList.isEmpty()) {
            jsonPayload.userName = lastModifiedUser;
            jsonPayload.Issue = issueDTOList;
            jsonPayload.Customer = customerDTOList;
            jsonPayload.CustomerDetails = customerDetailsDTOList;
            jsonPayload.StoreInfo = storeInfoDTOList;
            jsonPayload.IssueSurvey = issueSurveyDTOList;
            jsonPayload.Reimbursement = reimbursementDTOList;
            jsonPayload.IssueAttachment = issueAttachmentDTOList;
            System.debug('jsonPayload: ' + JSON.Serialize(jsonPayload));
            
            APIDataCalloutServices.dataFeedCallout(JSON.Serialize(jsonPayload), ConstantClass.ISSUE_CALLOUT_NAME);
        }
    }
    
    public class jsonRequestDTO {
        public String userName {get; set;}
        public List<issueDTO> Issue;
        public List<customerDTO> Customer;
        public List<customerDetailsDTO> CustomerDetails;
        public List<storeInfoDTO> StoreInfo;
        public List<issueSurveyDTO> IssueSurvey;
        public List<reimbursementDTO> Reimbursement;
        public List<issueAttachmentDTO> IssueAttachment;
    }
    
    public class issueDTO {
        public String CRCISSUEID {get; set;}
        public String TENANTID {get; set;}
        public String TXCATEGORY {get; set;}
        public String TXTYPE {get; set;}
        public String CREATEDBY {get; set;}
        public String ISSUEDATE {get; set;}
        public String MODIFIEDBY {get; set;}
        public String MODIFIEDDATE {get; set;}
        public String CONTACTID {get; set;}
        public String CONTACTSERVICEREQUESTID {get; set;}
        public String CUSTOMERID {get; set;}
        public String OPCO {get; set;}
        public String ISSUEHIERARCHYCODE {get; set;}
        public String CRCBRANDHIERARCHYCODE {get; set;}
        public String CLASSIFICATION {get; set;}
        public String PRODUCTLINECODE {get; set;}
        public String ISSUETYPE {get; set;}
        public String GROUPCODE {get; set;}
        public String REASON {get; set;}
        public String CAUSE {get; set;}
        public String UPC {get; set;}
        public String BRAND {get; set;}
        public String TASTE {get; set;}
        public String LENGTHCODE {get; set;}
        public String PACKAGING {get; set;}
        public String FLAVOR {get; set;}
        public String FILTER {get; set;}
        public String PAPERTYPE {get; set;}
        public String CUT {get; set;}
        public String SUSPECTEDCOUNTERFIET {get; set;}
        public String STORETYPECODE {get; set;}
        public String STORENAME {get; set;}
        public String STOREADDR1 {get; set;}
        public String STOREADDR2 {get; set;}
        public String STORECITY {get; set;}
        public String STORESTATE {get; set;}
        public String STOREZIP {get; set;}
        public String STOREZIP4 {get; set;}
        public String PURCHASETYPE {get; set;}
        public String PURCHASEDATE {get; set;}
        public String INCIDENTDATE {get; set;}
        public String EXPECTEDTYPE {get; set;}
        public String AFFECTEDTYPE {get; set;}
        public String MFGDATECODE {get; set;}
        public String PRODUCTIONDATE {get; set;}
        public String PRIMARYCRCISSUEDETAILID {get; set;}
        public String REIMBURSEDFLAG {get; set;}
        public String DATECODEPRODUCTIONDATE {get; set;}
        public String DATECODELOCATION {get; set;}
        public String DATECODESHIFT {get; set;}
        public String DATECODEUNIT {get; set;}
        public String DATECODECOLDSTORAGE {get; set;}
        public String DATECODERPTBAY {get; set;}
        public String DATECODERPTFACTORY {get; set;}
        public String DATECODEMILITARYTIME {get; set;}
        public String VALIDTRACECODE {get; set;}
        public String USTDATECODE {get; set;}
        public String USTDATECODETYPE {get; set;}
        public String USTDATE {get; set;}
        public String VALIDUSTDATECODE {get; set;}
        public String SUSPECTEDTAMPERING {get; set;}
        public String RELATEDIUSSENO {get; set;}
        public String JMCMACHINECODE {get; set;}
        public String CONTACTTYPE {get; set;}
        public String RESHIPFLAG {get; set;}
        public String MAJORSYMPTOM {get; set;}
        public String THIRDPARTYCONTACTED {get; set;}
        public String CCEXP {get; set;}
        public String CCNUM {get; set;}
        public String CCSECCODE {get; set;}
        public String INVENTORYDEPLETED {get; set;}
        public String TRACECODELOCATION {get; set;}
        public String CALLERNAME {get; set;}
        public String SUPPLIERNAME {get; set;}
        public String CONSUMERRETURN {get; set;}
        public String EMAILGENFLAG {get; set;}
        public String COMMENTS {get; set;}
        public String STORECOMMENTS {get; set;}
        public String UPDATEREASON {get; set;}
        public String RESHIPREASON {get; set;}
        public String CONSUMERRETURNNOTES {get; set;}
        public String CALLKEYWORDS {get; set;}
        public String CRCEMAILALERTID {get; set;}
        public String PURCHASEPRICE {get; set;}
        public String PURCHASEQTY {get; set;}
        public String EXPECTEDQTY {get; set;}
        public String AFFECTEDQTY {get; set;}
        public String EXPRETURNTOTALCOST {get; set;}
        public String RESHIPDATE {get; set;}
        public String EMAILGENDATE {get; set;}
        public String YEARMONTHMODULE {get; set;}
        public String OVERAGE {get; set;}
        public String PRODUCTAGE {get; set;}
        public String RECOMMENDEDUSAGEBASEDONAGE {get; set;}
        public String CONTACTCHANNEL {get; set;}
        public String RETURNREIMBURSEMENTREQUEST {get; set;}
        public String OBOUNDTRACKINGNO {get; set;}
        public String INDBOUNDTRACKINGNO {get; set;}
        public String MASTERISSUEID {get; set;}
        public String REFERENCEID {get; set;}
        public String IQOS_REF_ID {get; set;}
        public String SERIAL_NUMBER {get; set;}
        public String WARRANTY_START_DATE {get; set;}
        public String WARRANTY_EXPIRATION_DATE {get; set;}
        public String WARRANTY_STATUS {get; set;}
        public String CEA_AGENT_ID {get; set;}
        public String COMPLAINT_SOURCE {get; set;}
        public String TestIssue {get; set;}
        public String CounterfeitCodeLookup {get; set;}
        public String ReportingNoteLegal {get; set;}
        public String ReportingNoteSC {get; set;}
        public String ReportingNoteBrandIntegrity {get; set;}
        public String Line {get; set;}
        public String Complaints {get; set;}
        public String Contact {get; set;}
        public String UCID {get; set;}
        public String Factory_Controllable {get; set;}
        public String Shortcut {get; set;}
    }
    
    public class customerDTO {
        public String CUSTOMERID {get; set;}
        public String CUSTOMERNO {get; set;}
        public String TENANTID {get; set;}
        public String FIRSTNAME {get; set;}
        public String PREFIXCODE {get; set;}
        public String MIDDLEINITIAL {get; set;}
        public String MIDDLENAME {get; set;}
        public String LASTNAME {get; set;}
        public String SUFFIXCODE {get; set;}
        public String CREATEDBY {get; set;}
        public String CREATEDDATE {get; set;}
        public String CREATEDSOURCE {get; set;}
        public String MODIFIEDBY {get; set;}
        public String MODIFIEDDATE {get; set;}
        public String MODIFIEDSOURCE {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String GENDER {get; set;}
        public String DATEOFBIRTH {get; set;}
        public String CUSTOMERTYPE {get; set;}
        public String CRCAVFRECIEVEDFLAG {get; set;}
        public String CRCREPEATCOMPLAINER {get; set;}
        public String CRCAVDATE {get; set;}
        public String CRCREPEATCOMPALINERFROM {get; set;}
        public String ARCHIVEFLAG {get; set;}
        public String COMPANYNAME {get; set;}
        public String DBANAME {get; set;}
        public String STORENO {get; set;}
        public String ACCOUNTNO {get; set;}
        public String RETAILCONTROLNO {get; set;}
        public String TERRITORYNO {get; set;}
        public String DIRECTPURCHASE {get; set;}
        public String HOURSOFOPERATION {get; set;}
        public String ALSDREP {get; set;}
        public String AGEVERIFIED_SRC {get; set;}
        public String STUDY_ID {get; set;}
        public String RESEARCH_PARTICIPANT_ID {get; set;}
        public String BLINDING_CODE {get; set;}
        public String RESEARCH_COMPANY {get; set;}
        public String RESEARCH_LOCATION {get; set;}
        public String PARTICIPATION_DATE {get; set;}
        public String PRODUCT_FLAVOR {get; set;}
        public String RESEARCH_PANELIST_ID {get; set;}
        public String CUSTOMER_HAS_PRODUCT {get; set;}
        public String RESEARCH_PANELIST_NOTES {get; set;}
        public String ConsumerOrCustomer {get; set;}
    }
    
    public class customerDetailsDTO {
        public String CustomerDetailId {get; set;}
        public String Tenantid {get; set;}
        public String EnvCode {get; set;}
        public String CustomerID {get; set;}
        public String RecordType {get; set;}
        public String IsPrimary {get; set;}
        public String ActiveFlag {get; set;}
        public String Address1 {get; set;}
        public String Address2 {get; set;}
        public String City {get; set;}
        public String State {get; set;}
        public String Zip {get; set;}
        public String Zip4 {get; set;}
        public String PhoneNo {get; set;}
        public String AltPhone {get; set;}
        public String MobileNo {get; set;}
        public String Faxno {get; set;}
        public String Email {get; set;}
        public String CreatedDate {get; set;}
        public String CreatedBy {get; set;}
        public String ModifiedDate {get; set;}
        public String ModifiedBy {get; set;}
        public String OpCompanyCode {get; set;}
        public String ProfileUpdType {get; set;}
        public String ArchivedFlag {get; set;}
        public String Country {get; set;}
    }
    
    public class storeInfoDTO {
        public String CRCIssueId {get; set;}
        public String ContactId {get; set;}
        public String StoreTypeCode {get; set;}
        public String StoreName {get; set;}
        public String StoreAddr1 {get; set;}
        public String StoreAddr2 {get; set;}
        public String StoreCity {get; set;}
        public String StoreState {get; set;}
        public String StoreZip {get; set;}
        public String StoreZip4 {get; set;}
        public String StoreComments {get; set;}
        public String ModifiedBy {get; set;}
        public String ModifiedDate {get; set;}
        public String IssueStoreId {get; set;}
    }
    
    public class issueSurveyDTO {
        public String CRCISSUEID {get; set;}
        public String CONTACTID {get; set;}
        public String SURVEYID {get; set;}
        public String SURVEYQUESTIONID {get; set;}
        public String SURVEYQUESTIONTEXT {get; set;}
        public String SURVERYANSWERID {get; set;}
        public String SURVEYANSWERTEXT {get; set;}
        public String ANSWERCOMMENTS {get; set;}
        public String QUESTSEQUENCE {get; set;}
        public String ANSSEQUENCE {get; set;}
    }
    
    public class reimbursementDTO {
        public String TENANTID {get; set;}
        public String CUSTOMERID {get; set;}
        public String CONTACTID {get; set;}
        public String CONTACTSERVICEREQUESTID {get; set;}
        public String CRCISSUEID {get; set;}
        public String REIMBCREATEDDATE {get; set;}
        public String REIMBCREATEDBY {get; set;}
        public String OPCO {get; set;}
        public String BRAND {get; set;}
        public String COUPONQTY {get; set;}
        public String CHKAMT {get; set;}
        public String PROGRAMCODE {get; set;}
        public String PACKAGECODE {get; set;}
        public String COUPON {get; set;}
        public String REIMBTYPE {get; set;}
        public String FULFILLDATE {get; set;}
        public String RESHIPDATE {get; set;}
        public String EXTRACTDATE {get; set;}
        public String MAILTOADDRESS1 {get; set;}
        public String MAILTOADDRESS2 {get; set;}
        public String MAILTOADDRESSCITY {get; set;}
        public String MAILTOADDRESSSTATE {get; set;}
        public String MAILTOADDRESSZIP {get; set;}
        public String MAILTOADDRESSZIP4 {get; set;}
    }
    
    public class issueAttachmentDTO {
        public String ISSUEATTACHMENTID {get; set;}
        public String ISSUEID {get; set;}
        public String DESCRIPTION {get; set;}
        public String ATTACHMENTNAME {get; set;}
        public String ACTIVEFLAG {get; set;}
        public String CREATEDBY {get; set;}
        public String CREATEDDATE {get; set;}
        public String MODIFIEDBY {get; set;}
        public String MODIFIEDDATE {get; set;}
    }
}