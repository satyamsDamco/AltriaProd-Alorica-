//DNIS Search Page
//When salesforce receive the call or Agent select the Op Company then open the Search Page(Consumer  or Trade) 

public class DNISSearchController{
    
    public string testFuncMe {get;set;}
    public Transaction_Management__c transmgmObj {get; set;}
    public string opCompany {get;set;}
    private Map<Id,Operating_Company__c> opMap;
    private string customerNumber;
    private string tollNumber;
    private string ucid;
    public string tranid {get;set;}
    
    public DNISSearchController() {  
    
        transmgmObj = new Transaction_Management__c();
        customerNumber = '';
        ucid = '';
        //Reset the transaction data in Cookie
        Cookie counter = ApexPages.currentPage().getCookies().get('tranid');
        if (counter != null) {
            counter = new Cookie('tranid', null , null, 0,true);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});
        }
        //Reset the custmer type (Consumer or Trade) flag in Cookie
        Cookie counter1 = ApexPages.currentPage().getCookies().get('customerRecType');
        if (counter1 != null) {
            counter1 = new Cookie('customerRecType', null , null, 0,true);
            ApexPages.currentPage().setCookies(new Cookie[]{counter1});
        }
        if(ApexPages.currentPage().getParameters().get('remotenumber') != null && ApexPages.currentPage().getParameters().get('remotenumber') != ''){
            customerNumber = EncodingUtil.URLdecode(ApexPages.currentPage().getParameters().get('remotenumber'),'UTF-8');
        }
        
        if(ApexPages.currentPage().getParameters().get('called') != null && ApexPages.currentPage().getParameters().get('called') != ''){
            tollNumber = ApexPages.currentPage().getParameters().get('called');
        }
        
        if(ApexPages.currentPage().getParameters().get('ucid') != null && ApexPages.currentPage().getParameters().get('ucid') != ''){
            ucid = ApexPages.currentPage().getParameters().get('ucid');
        }        
        
        System.debug('test customerNumber '+customerNumber +' , tollNumber '+tollNumber );
        
    }
    //Method to get the list of OpCompany 
     public List<SelectOption> getopCompanyList(){
         
        List<SelectOption> selectOptions=new List<SelectOption>();
        selectOptions.add(new selectOption('--Select DNIS--','--Select DNIS--'));
        opMap = new  Map<Id,Operating_Company__c>([select id,Default_TFN__c,OperatingCompany__c,Trade__c 
                                                        from Operating_Company__c 
                                                        where Active__c = true
                                                        and Default_TFN__c != null 
                                                        order by OperatingCompany__c asc]);
        if(!opMap.IsEmpty() && opMap.size() >0){
            for(Operating_Company__c temp :opMap.Values()){         
                if(temp.OperatingCompany__c != NULL && temp.OperatingCompany__c.trim() != ''){                
                    selectOptions.add(new selectOption(temp.id, temp.OperatingCompany__c));
                }
            }
        }
       return selectOptions;
    }
    
    public PageReference searchOnLoad(){
        PageReference pgRef = null; 
        if(customerNumber != null && customerNumber.trim() != '' && tollNumber != null && tollNumber.trim() != ''){
            List<TFN__c> opCompany = new List<TFN__c>([Select id, Operating_Company__c,Operating_Company__r.Trade__c,DNIS__c from TFN__c where Active__c = true and (Toll_Free_Number__c = :tollNumber or DNIS__c =:tollNumber  )limit 1]);   
            
            if(!opCompany.isEmpty() && opCompany.size() >0){
                String customerType = '';
                tranid = '';
                
                transmgmObj.Operating_Company__c =opCompany[0].Operating_Company__c;
                transmgmObj.Start_Date_Time__c = system.now();
                transmgmObj.TFN__c = opCompany[0].id;
                transmgmObj.ANI__c = customerNumber;
                transmgmObj.ContactChannel__c = System.Label.ContactChannel;
                transmgmObj.CallID__c = ucid;
                if(opCompany[0].Operating_Company__r.Trade__c)
                   customerType = 'Trade Customer';
                else
                   customerType = 'Consumer';
                
                Database.UpsertResult upsRst =  Database.upsert(transmgmObj); 
                
                if(upsRst != null && upsRst.isSuccess())
                    tranid = upsRst.getId();
                    
                if(tranid != null && tranid != ''){
                    //Set the transaction data in Cookie
                    Cookie counter = new Cookie('tranid', tranid ,null,-1,true);
                    ApexPages.currentPage().setCookies(new Cookie[]{counter});    
                    if(customerType == 'Consumer'){
                        counter = new Cookie('customerRecType', 'consumer',null,-1,true);
                        ApexPages.currentPage().setCookies(new Cookie[]{counter});
                        pgRef = new pagereference('/apex/ConsumerSearch?tranid='+tranid+ '&customerNumber='+customerNumber);
                        
                    }else if(customerType == 'Trade Customer'){
                        //Set the custmer type (Consumer or Trade) flag in Cookie
                        counter = new Cookie('customerRecType', 'trade',null,-1,true);
                        ApexPages.currentPage().setCookies(new Cookie[]{counter});
                        pgRef = new pagereference('/apex/TradeSearch?tranid='+tranid+ '&customerNumber='+customerNumber);
                    }
                }    
            }   
        } 
        return pgRef;
    }

    public PageReference search(){
        PageReference pgRef = null; 
        
        String customerType = '';
        tranid = '';
        if(opCompany == null || opCompany == '--Select DNIS--'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Operating Company');
            ApexPages.addMessage(myMsg);
            return null;
        }else{
            System.debug('Test opCompany'+opCompany);
            System.debug('Test opMap'+opMap);
            Operating_Company__c opObj = opMap.get(opCompany);
            
            transmgmObj.Operating_Company__c =opObj.id;
            transmgmObj.Start_Date_Time__c = system.now();
            transmgmObj.TFN__c = opObj.Default_TFN__c;
            if(opObj.Trade__c)
               customerType = 'Trade Customer';
            else
               customerType = 'Consumer';
            
            Database.UpsertResult upsRst =  Database.upsert(transmgmObj); 
            
            if(upsRst != null && upsRst.isSuccess())
                tranid = upsRst.getId();
             
        }
        if(tranid != null && tranid != ''){
        	System.debug('Here tranid : ' + tranid);
            //Set the transaction data in Cookie
            Cookie counter = new Cookie('tranid', tranid ,null,-1,true);
            ApexPages.currentPage().setCookies(new Cookie[]{counter});  
            if(customerType == 'Consumer'){
                counter = new Cookie('customerRecType', 'consumer',null,-1,true);
                ApexPages.currentPage().setCookies(new Cookie[]{counter});
                pgRef = new pagereference('/apex/ConsumerSearch?tranid=' + tranid);
                
            }else if(customerType == 'Trade Customer'){
                //Set the custmer type (Consumer or Trade) flag in Cookie
                counter = new Cookie('customerRecType', 'trade',null,-1,true);
                ApexPages.currentPage().setCookies(new Cookie[]{counter});
                pgRef = new pagereference('/apex/TradeSearch?tranid=' + tranid);
            }
        }
        return pgRef;        
    }
}