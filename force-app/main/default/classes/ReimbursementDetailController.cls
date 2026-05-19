/*
Functionality to the Reimbursement Detail page
7/5/2016 Infogain – Created.
*/

public class ReimbursementDetailController{
    public Reimbursement__c reimbursement{get;set;} /* Object to get reimbursement data */
    public boolean isCorrespondenceReq{get;set;} /* Boolean flag for corresepondence requirement */
    public boolean isAllowedToEdit{get;set;} /*Boolean flag to set the permission to edit the reimbursement */
    public string tranid{get;set;}
    public string consumerName{get;set;}
    public Boolean showReimbAddtl {get;set;}
    public String inConsole{get;set;}
    
    public ReimbursementDetailController(ApexPages.StandardController controller){
        isAllowedToEdit = false;    
        boolean isCurrTransaction = true;
        boolean isProfileAllowed = true; 
        consumerName = '';       
        String reimbursementId = ApexPages.currentPage().getParameters().get('id');
        try{
            this.reimbursement = [Select Id,Issue__c,IssueID__c,Reimbursement_Type__c,Consumer__c,Status__c,
                                      Cheque_Amount__c,Name,TransactionId__c, Consumer__r.Name,Purchase_Price__c,
                                      First_Name__c, Last_Name__c, Street_Address__c,
                                      Apt_Lot__c, City__c, State__c, Zip_Code__c, Transfer_to_Altria_Date__c,
                                      Altria_File_Name__c, File_Name__c, Ship_Date__c,
                                      Ecount_ID__c, Card_Number__c,
                                  	  Consumer__r.Email, Consumer__r.Email_Verified__c
                                  From Reimbursement__c  Where Id =: reimbursementId Limit 1];
            Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
            if(counter != null) {
                tranid = counter.getValue();
            }
            consumerName = reimbursement.Consumer__r.Name;
            if(tranid != reimbursement.TransactionId__c){
                isCurrTransaction = false;
            }
            string profileName = getCurrentUserprofileName();
            if(profileName != null && profileName != ''){
                Profile_Permission_Setting__c profilePerm = Profile_Permission_Setting__c.getValues(profileName);
                if(profilePerm != null){
                    isProfileAllowed = profilePerm.AllowedToEditReimbursement__c;
                }
            }
            if(isCurrTransaction || isProfileAllowed){
                isAllowedToEdit = true;
            }
        }catch(Exception ex){
        }
        updateStatus();
    }
    
    /*Update Correspondence Status*/
    public void updateStatus(){
        if(reimbursement.Status__c == 'Age Not Verified'){
            isCorrespondenceReq = true;
        }else{
            isCorrespondenceReq = false;
        }
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