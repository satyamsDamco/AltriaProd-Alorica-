public class ContactHelper {
    public void updateReimbursement(Map<id, Contact>  newMap, Map<id, Contact>  oldmap){
        list<Id> contactIdLst = new list<Id>();
        list<Reimbursement__c> lstreimbupdate = new list<Reimbursement__c>();
        for(Contact conObj : newMap.values()){
        	if(conObj.AVF_GIID_Received__c != oldmap.get(conObj.id).AVF_GIID_Received__c && conObj.AVF_GIID_Received__c){
                contactIdLst.add(conObj.id);
            }
            if(contactIdLst != null && contactIdLst.size() > 0){
            	list<Reimbursement__c> lstreimb = [Select Id, Status__c, Consumer__c From Reimbursement__c 
                                                   Where Consumer__c in: contactIdLst];
                if(lstreimb != null && lstreimb.size() > 0){
                    for(Reimbursement__c reimb : lstreimb){
                        reimb.Status__c = 'Age Verified';
                        lstreimbupdate.add(reimb);
                    }
                } 
                if(lstreimbupdate != null && lstreimbupdate.size()>0){
                    list<Database.SaveResult> lstSaveRst = Database.update(lstreimbupdate);
                    system.debug('----lstSaveRst---'+lstSaveRst);
                }
            }
        }
    }
}