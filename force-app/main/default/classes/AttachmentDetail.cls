public class AttachmentDetail {

   public Attachment attachment {get;set;}
   public Id attID{get;set;}
   public id tranid {get;set;}
    
   public AttachmentDetail(ApexPages.StandardController stdController){
       this.attachment = (Attachment)stdController.getRecord();
       attID=ApexPages.currentPage().getParameters().get('id');
       Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if(counter != null) {
            tranid = counter.getValue();
        }
       
   }
    public PageReference editPage(){
        PageReference pg=new PageReference('/apex/AttachmentUploadPage?id='+attID);
        pg.setRedirect(true);
        return pg;
    }
}