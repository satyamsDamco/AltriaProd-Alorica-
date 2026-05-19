public class ConsumerDetailController {

    public contact conObj {get;set;}
    public Boolean Customershow {get;set;}  
    public Boolean isAgeVerificationReq{get;set;}
    public id currentTran {get;set;}
    public list<Case> lstIssue{get;set;}
    public Boolean isHotZip{get;set;}
    public Boolean isReimbHist{get;set;}
	public List<case> Cases;
   	public String sortDirection = 'ASC';
   	public String sortExp {get;set;}
    public string selectedCaseId {get;set;}
     public List<Contact> householdMembers { get; set; }
    
    /* Initiate constructor for controller ConsumerDetailController. */
    public ConsumerDetailController (ApexPages.StandardController stdController){
        lstIssue = new list<Case>();
        conObj = new Contact();
        this.conObj=(Contact)stdController.getRecord();  
        system.debug('ConObj is '+ conObj);
        System.debug('Page: ' + ApexPages.currentPage());	
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        System.debug('Counter: ' + counter);
        if(counter != null) {
            currentTran = counter.getValue();            
        }
        id consumerRectype = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
         
        if(conObj.RecordTypeId != null && conObj.RecordTypeId != consumerRectype){
            Customershow = false;
        }else{
            Customershow = true;   
        }

        getCurrCountry();
        gethouseholdMemberDetail();
		toggleSort();
        lstIssue = [Select Id, CaseNumber__C, Brandcode__c, Product_Line__c, Classificationtxt__c, Reasontxt__c, Causetxt__c, CreatedDate, Reimbchk__c, Survey__c,
                    Survey_Cancel_Reason__c From Case Where ContactId =: conObj.id order by CreatedDate DESC];
        system.debug('-----lstIssue------'+lstIssue);
        
        //JD: 4/28/2019 - RITM0343263 - SCR 19-03-06 2018 Reimbursement Restrictions
        //Only available for Consumer - not available for Trade customers
        if(Customershow)
        {            
            String getHZ;
            getHZ = ApexPages.currentPage().getParameters().get('isHotZip');
            if(getHZ !=null) 
            {
                isHotZip = Boolean.valueOf(getHZ);
            }else{
                isHotZip = false;
            }
            isReimbHist = checkReimbHist();
        }
    }
    
    //Method to display the Age verify button on the screen
    public void getCurrCountry(){
        if(conObj.Country__c == null || conObj.Country__c == '--None--' || conObj.Country__c == Label.Country){
            isAgeVerificationReq = true;
        }else{
            isAgeVerificationReq = false;
        }
        if(isAgeVerificationReq && conObj.CustomerType__c != Label.CustomerType){
            isAgeVerificationReq = false;
        }
    }

    //Method to launch the consumer edit page on the Edit button
    public PageReference editConsumer(){
       PageReference pg1;
        if(conObj.id!=null){
         pg1=new PageReference ('/apex/ConsumerEntry?id='+conObj.id);    
        }
        return pg1;
       
    }
    
    //Method to refresh the detail page
    public PageReference refreshpage(){
        if(conObj.id!=null){
            PageReference pg1;
            pg1 = new PageReference('/apex/ConsumerDetailPage?id='+conObj.Id);
            pg1.setRedirect(true);
            return pg1;
        }
        return null;
    }
    
    //Method to get the Associated Chat History
    public List<LiveChatTranscript> getChatHistory(){
        List<LiveChatTranscript> listChatHist = new List<LiveChatTranscript>();
        listChatHist = [
                Select Chat_ID__c, CreatedDate, CreatedBy.Name, CaseId, Issue_ID__c, WaitTime, StartTime, EndTime, 
                    LastModifiedDate, LastModifiedBy.Name 
                From LiveChatTranscript 
                Where ContactId =:conObj.id 
                order by Id desc
            ];
        if(listChatHist.isEmpty()){
            return null;
        }
        return listChatHist;
    }
    
    public Boolean checkReimbHist(){
        Integer countCon, countRI,totalCount;
        Boolean result;
        if(conObj.id != null)
        {
            countCon = [SELECT count() FROM Reimbursement__c WHERE Consumer__c =: conObj.Id];
        }
        
        if(conObj.Zip_Code__c != null && conObj.Street_Address__c != null)
        {
            countRI = [SELECT count() FROM Reimbursement__c WHERE Zip_Code__c =: conObj.Zip_Code__c AND Street_Address__c =: conObj.Street_Address__c];
        }   
        
        totalCount = countCon + countRi;
        
        if(totalCount > 0)
        { result = true; }
        else
        { result = false;}
        
        return result;
    }

	public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
		system.debug('sortExp :' +sortExp);
		system.debug('Value :'+Value);
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

    public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }

	public void setSortDirection(String value)
     {  
       sortDirection = value;
     }
	
	public List<case> getcases() {
       return cases;
   }
	 public PageReference ViewData() {
       //build the full sort expression
       system.debug('Sort EXP :' +sortExp);
		if(sortExp == null){
            sortExp = 'CaseNumber__c';
        }
         else{
             sortExp = sortExp;
         }
       string sortFullExp = sortExpression  + ' ' + sortDirection;
       system.debug('sortFullExp : '+sortFullExp);
       system.debug('conObj.id : '+conObj.id);
       //query the database based on the sort expression
		 String query = 'SELECT Id, CaseNumber__c, Brandcode__c, Product_Line__c, Classificationtxt__c, Reasontxt__c, Causetxt__c, CreatedDate, Reimbchk__c, Survey__c, Survey_Cancel_Reason__c ' +
                   'FROM Case ' +
                   'WHERE ContactId = \'' + conObj.id + '\' ' +
                   'ORDER BY ' + sortFullExp + 
                   ' LIMIT 1000';
    	cases = Database.query(query);
         system.debug('cases : '+cases);
       return null;
   }


	 public void toggleSort() {
        // Logic for toggling the sort order
        // You can implement the sorting logic here
        // Example:
		getSortDirection();
        
        ViewData(); // Reload data after sorting
    }

    public void gethouseholdMemberDetail(){
        if (Customershow) {
            // Query household members based on criteria
             if (householdMembers == null) {
                householdMembers = new List<Contact>();
            }
    
            String streetAddress = conObj.Street_Address__c;
            String zipCode = conObj.Zip_Code__c;
            system.debug('Street Address is : '+streetAddress + '   zip code is :  '+zipCode );
            //string conName = conobj.Name;
            List<contact> conValue = [SELECT Id, Name, Birthdate__c, CustomerID__c,Street_Address__c,	City__c,State__c,Zip_Code__c,Active__c,DoNotUse__c 
								      FROM Contact 
                                      WHERE Zip_Code__c = :zipCode 
                                      and Street_Address__c =:streetAddress 
                                      and Active__c= true  
                                      and DoNotUse__c = false
                                      LIMIT 1000
                                      ];
			system.debug('Contact Value : ' +conValue );
            for(contact c:conValue){
                if(c.Street_Address__c != 'Not Provided' || c.Street_Address__c != null){
					system.debug(c);
                   householdMembers.add(c);
                }
                
            }
        }
    }
	
	
	
	    
}