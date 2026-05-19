public class CorrespondenceController {

    public Correspondence_Fulfilment__c codObj{get;set;}
    
    public Boolean showMasterID{get;set;}
    public string selectedId{get;set;}
    public string selectedBrand{get;set;}
    public string selectedLetter{get;set;}
    public List<SelectOption> OptionBrand{ get;set; }
    public List<SelectOption> letterList {get;set;}
    public List<SelectOption> MasterIssueList {get;set;}
    public String customerRecType{get;set;}
    public boolean newFulfillment {get;set;}
    private List<Case> caseObj;
    private Id contid;
    private Map<id, DocumentType__c> docObj;
    private Map<id,Brand__c> brandObj;    
    public string dateOutput{get;set;}
    public boolean BrandRequired {get;set;}
 
    public CorrespondenceController (ApexPages.StandardController stdController){  
        
        codObj = new Correspondence_Fulfilment__c();
        codObj=(Correspondence_Fulfilment__c)stdController.getRecord();    
        docObj = new Map<id, DocumentType__c>();  
        caseObj = new List<Case>();
        BrandRequired = false;
        newFulfillment = false;
        dateOutput = '';
        System.debug('codObj: ' + codObj);
        if(codObj.id == null){   
            contid=ApexPages.currentPage().getParameters().get('contid');
            Cookie counter = ApexPages.currentPage().getCookies().get('customerRecType');
            System.debug('Cont id: ' + contid);
            System.debug('Counter: ' + counter);
            if(counter != null) {
                    customerRecType = counter.getValue();
            }
            newFulfillment = true;
            codObj.contact__c=contid;        
            Date yourDate = Date.today();
            dateOutput = yourDate.format();
            codObj.LetterDate__c = date.parse(dateOutput);
        }else{
            system.debug('--------codObj------'+codObj);
            codObj = [Select id,MasterId__c,DocType__c,Comments__c, Contact__c,DocType__r.Description__c,Brand_Corres__c,
                      BCode__c, LetterDate__c,isReimbursement__c from Correspondence_Fulfilment__c where id =:codObj.id];
            dateOutput = codObj.LetterDate__c.format();
            contid = codObj.contact__c;
            id consumerRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
            system.debug('------codObj.contact__c---'+codObj.contact__c);
            system.debug('------codObj---'+codObj);
            Contact con = [select id, RecordTypeId from Contact where id =: codObj.contact__c];
            if(con != null && con.RecordTypeId != null && con.RecordTypeId == consumerRectype){
                customerRecType =  'consumer';
            }else{
                customerRecType =  'trade';
            }
            system.debug('-----con--'+con);
            system.debug('-----con.RecordTypeId--'+con.RecordTypeId);
        }
        
        caseObj = new List<Case>();
        docObj=new Map<id, DocumentType__c>();
        brandObj=new Map<id, Brand__c>();
        OptionBrand = new List<SelectOption>();  
        letterList = new List<SelectOption>();  
        MasterIssueList = new List<SelectOption>();
        LetterData();   
        MasterIssueListData();
        OptionBrand.add(new SelectOption('--None--','--None--'));
        if(codObj.id != null){            
            selectedLetter = codObj.DocType__c;
            
            if(customerRecType != 'trade'){
                brandList();
                if(codObj.MasterId__c != null){
                    selectedId = '1-'+codObj.MasterId__c;   
                }
                selectedBrand = codObj.Brand_Corres__c;
            }else{
                if(codObj.MasterId__c != null){
                    selectedId = '1-'+codObj.MasterId__c;   
                }
            }
        }   
             
    }
    
    private void LetterData(){ 
        letterList = new List<SelectOption>();        
        letterList.add(new SelectOption('--None--','--None--'));  
        if(customerRecType != 'trade'){
            if(codObj.id == null){
                docObj = new Map<Id, DocumentType__c>([select id,Description__c,showMasterField__c,Operating_Company__c,
                                                  PrintLetterHead__c,PkgCode__c, FileName__c,ReqFulfillment__c,Brand_Required__c  
                                                  from DocumentType__c 
                                                  Where IsActive__c =  true 
                                                  and isReimbursement__c =  false
                                                  and isTrade__c = false order by Description__c]);
            }else{
                docObj = new Map<Id, DocumentType__c>([select id,Description__c,showMasterField__c,Operating_Company__c,
                                                  PrintLetterHead__c,PkgCode__c,  FileName__c,ReqFulfillment__c,Brand_Required__c  
                                                  from DocumentType__c 
                                                  Where IsActive__c =  true 
                                                  and isTrade__c = false order by Description__c]);            
            }                                      
            for(DocumentType__c docTyp: docObj.values()){            
                letterList.add(new SelectOption(docTyp.id,docTyp.Description__c));
            }
        }else{
              docObj = new Map<Id, DocumentType__c>([select id,PkgCode__c,Description__c,showMasterField__c,Operating_Company__c,Brand_Required__c 
                                                  from DocumentType__c 
                                                  Where IsActive__c =  true 
                                                  and isTrade__c = true]);
                                                  
             for(DocumentType__c docTyp: docObj.values()){            
                letterList.add(new SelectOption(docTyp.id,docTyp.Description__c));
                showMasterID = docTyp.showMasterField__c;
             }
        }
    }
    
    public PageReference brandList(){   
        BrandRequired = false;
        system.debug('test '+selectedLetter +' ,customerRecType   '+customerRecType );
         if(customerRecType != 'trade'){
             selectedBrand = null; 
                 OptionBrand = new List<SelectOption>();
                 OptionBrand.add(new SelectOption('--None--','--None--'));
             if(selectedLetter != '--None--' && docObj.ContainsKey(selectedLetter)){
                 DocumentType__c docObj1 = docObj.get(selectedLetter);
                 BrandRequired = docObj1.Brand_Required__c;
                 
                 if(docObj1 !=null){
                    if(docObj1.showMasterField__c == true ){
                        showMasterID=true;  
                        MasterIssueListData(); 
                        if(caseObj.isEmpty()){
                            String name = customerRecType == 'trade' ? 'trade customer' :customerRecType;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The letter you have chosen requires an Issue/Master ID and the consumer does not have any issues'));
                        }              
                    }
                    else{
                        showMasterID=false;
                    } 
                    system.debug('------Brand__c---------'+brandObj);
                    if(codObj.id == null || (codObj.id != null && !codObj.isReimbursement__c)){
                        system.debug('---------brandObj inside--------');
                        brandObj=new Map<id, Brand__c>([select id,Name, BrandCode__c
                                                     from Brand__c 
                                                     where Operating_Company__c=: docObj1.Operating_Company__c 
                                                     and IsActive__c = true 
                                                     and IsCorrespondence__c= true order by Name asc limit 999]);
                    }
                    if(codObj.id != null && codObj.isReimbursement__c){ 
                        brandObj=new Map<id, Brand__c>([select id,Name, BrandCode__c
                                                     from Brand__c 
                                                     where id =: codObj.Brand_Corres__c order by Name asc]);
                    }
                    for(Brand__c brandDesc:brandObj.values()){                 
                         OptionBrand.add(new SelectOption(brandDesc.id,brandDesc.Name));                 
                    }           
                }
            }else{
                showMasterID=false;
            }
        }else{
            selectedBrand = null;
        }
            
        return null;             
     }
    
     private void MasterIssueListData(){
        MasterIssueList = new List<SelectOption>();
        caseObj=[select id,CaseNumber,CaseNumber__c,MasterId__c,CreatedDate from case where Contact.id=:contid  order by CreatedDate desc limit 100];
        Set<String> setTran = new Set<String>();
        MasterIssueList.add(new SelectOption('--None--','--None--'));
        for(Case caseRecord:caseObj){ 
           if(!setTran.contains(caseRecord.MasterId__c)) {
               MasterIssueList.add(new SelectOption('1-'+caseRecord.MasterId__c,caseRecord.CaseNumber__c +' ( '+ caseRecord.CreatedDate.format('MM/dd/yyyy') +' )'));            
               setTran.add(caseRecord.MasterId__c);
           }else{
               MasterIssueList.add(new SelectOption('2-'+caseRecord.MasterId__c,caseRecord.CaseNumber__c +' ( '+ caseRecord.CreatedDate.format('MM/dd/yyyy') +' )'));            
           }
        }
        system.debug('-----MasterIssueList----'+MasterIssueList);
    }

    public PageReference SaveRecord(){
        if(codObj.Contact__c!=NULL){
            if(customerRecType != 'trade'){
                system.debug('----selectedLetter-------'+selectedLetter);
                system.debug('----BrandRequired-------'+BrandRequired);
                system.debug('----showMasterID-------'+showMasterID);
                system.debug('----selectedId-------'+selectedId);
                if(selectedLetter=='--None--'|| (BrandRequired == true  && selectedBrand =='--None--') || (showMasterID==true && (selectedId=='--None--' ||selectedId==null ))){                    
                    
                    
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select required field.'));
                    
                    
                    if(caseObj.isEmpty() && showMasterID==true && (selectedId=='--None--' ||selectedId==null )){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The letter you have chosen requires an Issue/Master ID and the consumer does not have any issues'));
                    }
                    return null;
                }
            }else{
                if( selectedLetter=='--None--' || showMasterID==true && (selectedId=='--None--' ||selectedId==null )){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select required field.'));
                    if(caseObj.isEmpty() && showMasterID==true && (selectedId=='--None--' ||selectedId==null )){
                        String name = customerRecType == 'trade' ? 'trade customer' :customerRecType;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The letter you have chosen requires an Issue/Master ID and the '+name+' does not have any issues'));
                    }
                    return null;
                }
            }
            system.debug('-----selectedId---'+selectedId);
            if(selectedId != null){
                codObj.MasterId__c = selectedId.split('-')[1];
            }  
            
            codObj.DocType__c=selectedLetter;
            if(customerRecType != 'trade' && selectedBrand !='--None--'){                
                codObj.Brand_Corres__c=selectedBrand;
                 system.debug('------brandobj --------'+brandObj );
                 system.debug('------selected brand --------'+selectedBrand );
                codObj.BCode__c =   brandObj.get(selectedBrand).BrandCode__c;
                
               
            }
            system.debug('----codObj.id--------'+codObj.id);
            system.debug('----codObj.Contact__c--------'+codObj.Contact__c);
            system.debug('----customerRecType--------'+customerRecType);
            if(codObj.id == null && codObj.Contact__c != null && customerRecType != 'trade'){
                Contact conObj=[select id ,FirstName,LastName,Street_Address__c,Apt_Lot__c,City__c,CustomerID__c,Salutation,Suffix__c,State__c,Zip_Code__c 
                                from contact 
                                where id=:codObj.Contact__c];
                                
                if(selectedLetter != '--None--' && docObj.ContainsKey(selectedLetter)){            
                    DocumentType__c docType = docObj.get(selectedLetter);
                    if(docType.ReqFulfillment__c){
                        codObj.Requires_Fulfillment__c = true; 
                    }                 
                    codObj.DocumentOpCompany__c = docType.Operating_Company__c;
                    codObj.Add1__c=conObj.Street_Address__c;
                    codObj.Add2__c=conObj.Apt_Lot__c;
                    codObj.City__c=conObj.City__c;
                    codObj.FName__c=conObj.FirstName;
                    codObj.LName__c=conObj.LastName;
                    codObj.Nameprefix__c=conObj.Salutation;
                    codObj.Name_Suffix__c= conObj.Suffix__c;
                    codObj.State__c=conObj.State__c;
                    codObj.Zip__c=conObj.Zip_Code__c;
                    codObj.Accnumber__c=conObj.CustomerID__c;
                    
                    codObj.Packagecode__c=docType.PkgCode__c; 
                    codObj.Letter_head__c=docType.PrintLetterHead__c;
                    codObj.FileName__c=docType.FileName__c; 
                 }
            }
            
        }
        
        Database.UpsertResult upsRst = Database.upsert(codObj);
        system.debug('==upsRst==='+upsRst);
        PageReference pg = new PageReference('/apex/CorrespondenceDetail?id=' + codObj.Id); // edited - fix for Spring '20
        if(upsRst.isSuccess()){
            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
            if(upsRst.isCreated()){
                mgmtHelper.createTransactionMgmtHistoryRecord('CORSP_OUTBOUND',String.valueOf(upsRst.getId()));
            }
        }    
        pg.setRedirect(true); // added - fix for Spring '20
        return pg;
    }
    
    public PageReference Clear() {
        system.debug('-------ApexPages.currentPage().getUrl()---'+ApexPages.currentPage().getUrl());
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        
        pageRef.setRedirect(true);
        return pageRef;
    }  
    
    public PageReference CancelRedirect(){
        PageReference pageRef = new PageReference('/apex/CorrespondenceDetail?id='+codObj.Id);
        pageRef.setRedirect(true);
        return pageRef;   
    }   
}