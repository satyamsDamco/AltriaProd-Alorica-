/* Created By: Infogain Pvt. Ltd.
   Created Date: 9/2/2016
   Purpose: Controller class for Attachment Upload from Issue Object.
*/
public class AttachmentUpload{

    public Id attID {get;set;}
    private Attachment att;
    private Attachment_Detail__c AttachmentDetailObj;
	private PageReference pgOrigin;
    //Initiate Getter and Setter method for standard Object "Attachment".
    public Attachment attachment {
        get {
            if (att == null)
                att = new Attachment();
            return att;
        }
        set{
            att = value;
        }
    }
    
    /* Constructor for Standard Controller "AttachmentUpload". It Execute on page load. */
    public AttachmentUpload(ApexPages.StandardController stdController){
        attachment = (Attachment)stdController.getRecord();
        attID = ApexPages.currentPage().getParameters().get('id');// Get Current page Attachment's 18 digit Salesforce record id.

        AttachmentDetailObj = new Attachment_Detail__c();  
        
        if(attachment != null && attachment.id != null){
            List<Attachment_Detail__c> AttachmentDetailList = new List<Attachment_Detail__c>([Select id, File_Type__c,AttachmentId__c,Description__c, File_Name__c, 
                                                                                             Issue__c
                                                                                             From Attachment_Detail__c
                                                                                             Where AttachmentId__c =: attID and IsActive__c = true limit 1]);
            system.debug('----AttachmentDetailList-----'+AttachmentDetailList);
            if(!AttachmentDetailList.isEmpty() && AttachmentDetailList.size() >0)
                    AttachmentDetailObj = AttachmentDetailList[0];
        }    
    }
  
    /* Method for update existing Attachment. We can update Comment and File Name only. */
    public PageReference updateAttachment(){
        system.debug('----attachment----'+attachment);
        if(attachment != null && attachment.id != null){
            //Attachments's description should not be NULL and its max. length is 500 charcters. 
            if(attachment.description!=null && attachment.description.length() >= 500){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment: Max. 500 characters are allowed.'));
                return null;
            }
            update attachment;
            AttachmentDetailObj.File_Name__c = attachment.Name;
            AttachmentDetailObj.Description__c = attachment.description;
            update AttachmentDetailObj;
        }
        
        PageReference pg=new PageReference('/apex/AttachmentDetailPage?id='+attID);   // Redirect page to Attachment's Detail page.
        
        pg.setRedirect(true); 
        return pg;
    }
    
    /* Cancel Button method and redirect to Attachment Detail Page. */
    public PageReference cancelButton(){
        PageReference pg1=new PageReference('/apex/AttachmentDetailPage?id='+attID);  
        return pg1;
    }
    
    /* Methods for upload a file on a particular issue. We can Upload multiple file on a single issue. */
    public PageReference upload() {
        
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = ApexPages.currentPage().getParameters().get('issueId'); // the record the file is attached to
        attachment.IsPrivate = true;
        
        //Error message if file does not contain any boady or invalid file type.
        if(attachment.body == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please attach a valid File before upload.'));            
            return null;
        }
        
        // 10/30/2017 gcutchon: make description(comment) required when uploading attachment
        if(attachment.description == null){    
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Comment is required for attachments.'));
            attachment.Body = null;
            return null;
        }
        
        //RITM0734680 - Limit Upload Size to 5MB
        if(attachment.Body.size() > 0)
        {
            Integer fileSize = attachment.Body.size();
            if(Test.isRunningTest()){
                if(attachment.Name == 'Test Size')
                {
                	fileSize = 5342880; 
                }
            }
            //Set upload limit to only 5MB
            if(fileSize > 5242880){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'This file exceeds the maximum size limit of 5MB.'));            
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please attach a valid File before upload.'));            
                attachment.Body = null;
                attachment.Description = null;
        		return null;
            }
        }
        
        try{
            insert attachment;
            
            if(ApexPages.currentPage().getParameters().get('issueId') != null){
                string issueId = ApexPages.currentPage().getParameters().get('issueId');
                Case currIssue = [Select Id, IsReviewed__c From Case Where Id =: issueId limit 1];
                if(currIssue != null){
                    AttachmentDetailObj.isReviewed__c = currIssue.IsReviewed__c;//Assign IsReviewed Status for the Attachment.
                }
            }            
            AttachmentDetailObj.AttachmentId__c =  attachment.id;
            AttachmentDetailObj.Description__c = attachment.description;
            AttachmentDetailObj.File_Name__c = attachment.Name;
            AttachmentDetailObj.Issue__c = ApexPages.currentPage().getParameters().get('issueId');
            AttachmentDetailObj.IsActive__c = true;
            //Set Feedsend to True
            AttachmentDetailObj.FeedSend__c = true;
             
            insert AttachmentDetailObj;
            attachment.Body = null; //clear body to avoid view state error on redirect 
            PageReference pg2=new PageReference('/apex/AttachmentDetailPage?id='+attachment.id);    // Redirect Attachment Detail page.
            pg2.setRedirect(true);   
            return pg2;
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment.'));
            return null;
        }
    }
}