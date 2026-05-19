/* Issue New/Edit Reimbursement
   07/19/2016 - Infogain---Created
*/

public class ReimbursementEditController{
  // Global declaration of variables
    public Reimbursement__c reimbursement{get;set;}
    public Correspondence_Fulfilment__c ffObj{get;set;} 
    public Case issue{get;set;} 
    public Case issueId{get; set;}
    public Id reimId;
    public String consumername{get;set;}
    public decimal purchasePrice {get;set;}
    public Boolean showReimbAddtl {get;set;}
    public String inConsole{get;set;}
    
    public ReimbursementEditController(ApexPages.StandardController controller){
        
        system.debug('---controller---');
        consumername = '';
        try{
            if(ApexPages.currentPage().getParameters().get('id') == null){
                this.reimbursement = new Reimbursement__c ();
            }
            else{
                this.reimbursement = [SELECT id,Reimbursement_Type__c,Purchase_Price__c,PackageCode__c,
                                      Cheque_Amount__c,Issue__r.id,Issue__c, Consumer__c, Name, Consumer__r.Name, 
                                      TransactionId__c, First_Name__c, Last_Name__c, Street_Address__c,
                                      Apt_Lot__c, City__c, State__c, Zip_Code__c, Transfer_to_Altria_Date__c,
                                      Altria_File_Name__c, File_Name__c, Ship_Date__c,
                                      Ecount_ID__c, Card_Number__c
                                      FROM Reimbursement__c 
                                      WHERE Id=: ApexPages.currentPage().getParameters().get('Id') LIMIT 1]; 
                
                this.issue = [Select Id, ContactId, Crc_Brand_Hierarchy_Code__r.Brand_Code__c,CaseNumber,CaseNumber__c,
                              Contact.Email,Contact.Email_Verified__c
                              from Case Where Id =: reimbursement.Issue__c];
                consumername = reimbursement.Consumer__r.Name;
                purchasePrice = reimbursement.Purchase_Price__c;
            }
            
            if(ApexPages.currentPage().getParameters().get('issueId') != null){
                this.issue= [Select Id, ContactId, Contact.Name,Purchase_Price__c, 
                             Crc_Brand_Hierarchy_Code__r.Brand_Code__c,IsReviewed__c,CaseNumber,CaseNumber__c,
                             Contact.Email, Contact.Email_Verified__c
                             from Case 
                             Where Id =: ApexPages.currentPage().getParameters().get('issueId')]; 
                reimbursement.Consumer__c = issue.ContactId;
                reimbursement.isReviewed__c = issue.IsReviewed__c;
                consumername = issue.Contact.Name;
                purchasePrice = issue.Purchase_Price__c;
            }
        }catch(Exception ex){
            
        }
        ffObj=new Correspondence_Fulfilment__c();
       }
    
    // Validation for reimbursement
    public PageReference validationBeforeReimbursement(){   
        system.debug('---validationBeforeReimbursement---');
        boolean isAllowedToEdit = false;
        string tranid;
        boolean isCurrTransaction = true;
        boolean isProfileAllowed = true;
        String reimbursementId = ApexPages.currentPage().getParameters().get('id');
        system.debug('---reimbursementId---'+reimbursementId);
        if(reimbursementId != null && reimbursementId != ''){
            Reimbursement__c reimbursement = [Select Id,Issue__c,Reimbursement_Type__c,Purchase_Price__c,Consumer__c,Cheque_Amount__c,Status__c,Name,     
                                              TransactionId__c From Reimbursement__c  Where Id =: reimbursementId Limit 1];
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                tranid = counter.getValue();
            }
            if(tranid != reimbursement.TransactionId__c){
                isCurrTransaction = false;
            }
            system.debug('------isCurrTransaction-----'+isCurrTransaction);
            string profileName = getCurrentUserprofileName();
            if(profileName != null && profileName != ''){
                Profile_Permission_Setting__c profilePerm = Profile_Permission_Setting__c.getValues(profileName);
                if(profilePerm != null){
                    isProfileAllowed = profilePerm.AllowedToEditReimbursement__c;
                }
            }
            system.debug('------isProfileAllowed-----'+isProfileAllowed);
            if(isCurrTransaction || isProfileAllowed){
                isAllowedToEdit = true;
            }
            if(!isAllowedToEdit){
                return redirectDetail();
            }
        }
        return null; 
    } 
    
    // Submit button event on reimbursement edit/new page
    public pagereference submit(){
        system.debug('------reimbursement-----'+reimbursement);
        if(reimbursement.TransactionId__c == null){
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                string tranIdStr = counter.getValue();
                Transaction_Management__c tranId = [Select Id From Transaction_Management__c Where Id =: tranIdStr limit 1];
                if(tranId != null){
                    reimbursement.TransactionId__c = tranId.Id;
                }
            }
        }
        boolean age_verification;
        Case ageReimbursement = new Case ();
        ageReimbursement = [ Select Contact.AVF_GIID_Received__c,Contact.Zip_Code__c,ContactId,Contact.State__c,Contact.CustomerId__c, 
                            Contact.Salutation,Contact.LastName,Contact.FirstName,Contact.City__c,Contact.Apt_Lot__c,
                            Contact.Street_Address__c,Transaction__c, Brandcode__c,Contact.Suffix__c, Crc_Brand_Hierarchy_Code__r.Brand_Code__c,
                            Crc_Brand_Hierarchy_Code__r.Brand_Code__r.BrandCode__c,Operating_Company__c,Product_Line_Code__c
                            From Case WHERE id =: issue.id];
        
        
        String amount= string.valueof(reimbursement.Cheque_Amount__c ); 
        reimbursement.BrandCode__c = ageReimbursement.Crc_Brand_Hierarchy_Code__r.Brand_Code__r.BrandCode__c;
        
        if(ageReimbursement.Operating_Company__c != null && ageReimbursement.Operating_Company__c != ''){
            String opCo = ageReimbursement.Operating_Company__c.toUppercase();
            if(opCo == 'PMUSA'){            
                reimbursement.PackageCode__c = 'CHKPAM';
            }else if(opCo == 'USST'){            
                reimbursement.PackageCode__c = 'CHKUS';
            }else if(opCo == 'JMC'){            
                reimbursement.PackageCode__c = 'CHKJM';
            }             
        }
                
        if(ageReimbursement.Contact.AVF_GIID_Received__c){
            reimbursement.Status__c = 'Age Verified'; // update if contact has age verified on reimbursement detail page                  
            
        }else{
            reimbursement.Status__c = 'Age Not Verified'; //update if contact has age not verified on reimbursement detail page            
        }
        
      if(reimbursement.Reimbursement_Type__c == null){

    for (Schema.PicklistEntry pe :
         Reimbursement__c.Reimbursement_Type__c
            .getDescribe()
            .getPicklistValues()) {

        if (pe.isActive()) {
            reimbursement.Reimbursement_Type__c = pe.getValue();
            break;
        }
    }
}
        
        //JD RITM0343263 - SCR 19-03-06 2018 Reimbursement Restrictions
        if(ageReimbursement.Contact.FirstName != null){
            reimbursement.First_Name__c = ageReimbursement.Contact.FirstName;
        }        
        
        if(ageReimbursement.Contact.LastName != null){
            reimbursement.Last_Name__c = ageReimbursement.Contact.LastName;
        }
        
        if(ageReimbursement.Contact.Street_Address__c !=null){
            reimbursement.Street_Address__c = ageReimbursement.Contact.Street_Address__c;
        }
        
        if(ageReimbursement.Contact.Apt_Lot__c !=null){
            reimbursement.Apt_Lot__c = ageReimbursement.Contact.Apt_Lot__c;
        }
        
		if(ageReimbursement.Contact.City__c !=null){
            reimbursement.City__c = ageReimbursement.Contact.City__c;
        }        
        
        if(ageReimbursement.Contact.State__c !=null){
            reimbursement.State__c = ageReimbursement.Contact.State__c;
        }
        
        if(ageReimbursement.Contact.Zip_Code__c !=null){
            reimbursement.Zip_Code__c = ageReimbursement.Contact.Zip_Code__c;
        }
        
        if(reimbursement.Cheque_Amount__c <= 0 || amount == '' || amount == null ){  // Validation check- Reimbursement amount cannot be zero or empty.     
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Amount can not be Empty or Zero. Please enter valid value and try again!!!'));
            return null;
        }else if(reimbursement.id == null){             
            reimbursement.Issue__c=issue.id;  
            Database.SaveResult saveRst = Database.insert(reimbursement);  
            if(saveRst.isSuccess()){
                TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                system.debug('----inside success insert-----');
                mgmtHelper.createTransactionMgmtHistoryRecord('CREATE_REIMB',String.valueOf(saveRst.getId()));
                if(reimbursement.Status__c == 'Age Not Verified'){ 
                    Database.SaveResult saveFulFill;                 
                    if(ageReimbursement.Operating_Company__c != null){ 
                        List<DocumentType__c> docObj = new List<DocumentType__c>([Select Id, FileName__c, PkgCode__c, PrintLetterHead__c,ReqFulfillment__c  
                                                                  From DocumentType__c 
                                                                  Where isActive__c = true and isReimbursement__c = true
                                                                  and Operating_Company__c =: ageReimbursement.Operating_Company__c limit 1]);              
                        if(!docObj.isEmpty() && docObj.size() >0){ 
                            ffObj.DocType__c = docObj[0].id;
                            if(docObj[0].ReqFulfillment__c){
                                ffObj.Requires_Fulfillment__c = true; 
                            }
                            ffObj.contact__c=ageReimbursement.ContactId;                                                                 
                            ffObj.Accnumber__c=ageReimbursement.Contact.CustomerID__c;
                            ffObj.Add1__c=ageReimbursement.Contact.Street_Address__c;
                            ffObj.Add2__c=ageReimbursement.Contact.Apt_Lot__c;
                            ffObj.City__c=ageReimbursement.Contact.City__c;
                            ffObj.FName__c=ageReimbursement.Contact.FirstName;
                            ffObj.LName__c=ageReimbursement.Contact.LastName;
                            ffObj.Nameprefix__c=ageReimbursement.Contact.Salutation;
                            ffObj.State__c=ageReimbursement.Contact.State__c;
                            ffObj.Zip__c=ageReimbursement.Contact.Zip_Code__c;
                            ffObj.Name_Suffix__c= ageReimbursement.Contact.Suffix__c;
                            
                            ffObj.Packagecode__c=docObj[0].PkgCode__c; 
                            ffObj.Letter_head__c=docObj[0].PrintLetterHead__c;
                            ffObj.FileName__c=docObj[0].FileName__c;
                            ffObj.BCode__c = ageReimbursement.Crc_Brand_Hierarchy_Code__r.Brand_Code__r.BrandCode__c ;
                            ffObj.Brand_Corres__c = ageReimbursement.Crc_Brand_Hierarchy_Code__r.Brand_Code__c;
                            
                            ffObj.LetterDate__c = Date.today();
                            saveFulFill = Database.insert(ffObj);                      
                        }
                    }
                    
                    if(saveFulFill != null && saveFulFill.isSuccess()){
                        reimbursement.Correspondence_Fulfilment__c = ffObj.id;
                        update reimbursement;
                        TransactionMgmtHelper mgmtHelper1 = new TransactionMgmtHelper();            
                        mgmtHelper1.createTransactionMgmtHistoryRecord('CORSP_OUTBOUND',String.valueOf(saveFulFill.getId()));
                
                    }
                }
            }
        }else{
            Database.UpsertResult upsRst = Database.upsert(reimbursement);
            if(upsRst.isSuccess()){
                TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
                if(upsRst.isCreated()){
                    mgmtHelper.createTransactionMgmtHistoryRecord('CREATE_REIMB',String.valueOf(upsRst.getId()));
                }else{
                    mgmtHelper.createTransactionMgmtHistoryRecord('UPDATE_REIMB',String.valueOf(upsRst.getId()));
                }
            }
            
        }
        return redirectDetail();
    }
 
    // Redirect to reimbursement detail page.
    public PageReference redirectDetail(){
        Id id=ApexPages.currentPage().getParameters().get('id');
        PageReference reimbursement= new PageReference('/apex/ReimbursementDetail?id='+reimbursement.id);
        reimbursement.setRedirect(true);
        return reimbursement;
    }
     
     // this function call on click of cancel button and return on the previous page 
    public PageReference cancel(){
        if(ApexPages.currentPage().getParameters().get('Id') != null ){
            reimId=ApexPages.currentPage().getParameters().get('Id');
        }else if(ApexPages.currentPage().getParameters().get('issueId') != null){
            PageReference pageRef = new PageReference('/apex/Issue_Detail?id='+ ApexPages.currentPage().getParameters().get('issueId')); 
            pageRef.setRedirect(true); 
            return pageRef;
        }
        PageReference pageRef = new PageReference('/apex/ReimbursementDetail?id='+ reimId); 
        pageRef.setRedirect(true); 
        return pageRef;
    }
        /* Get the current user profile Name */
    public string getCurrentUserprofileName(){
        string currUserProfileId = UserInfo.getProfileId();
        Profile currProfileName = [Select Name from Profile where Id =: currUserProfileId limit 1];
        string profileName;
        if(currProfileName != null){
            profileName = currProfileName.name;
        }
        return profileName;
    }
    public PageReference CancelRedirect(){
        PageReference pageRef = new PageReference('/apex/ReimbursementDetail?id='+reimbursement.Id);
        pageRef.setRedirect(true);
        return pageRef; 
    } 
    
    //This will assign value passed from javascript to controller
    public void assignValue(){
        if(Test.isRunningTest()){
            inConsole = 'true';
        }
 		String profileName = getCurrentUserprofileName();
        if(profileName == 'CRC Agent'){
        	showReimbAddtl = false;   
        }else
        {
    		showReimbAddtl = Boolean.valueOf(inConsole);
        }
    }
}