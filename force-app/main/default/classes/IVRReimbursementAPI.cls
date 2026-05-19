/*
Created by: Jannel Dacayo
Created Date: 9/9/2020
Description: Rest API for Reimbursement Follow up via IVR
*/

@RestResource(urlMapping='/IVRReimbursementAPI/')
global class IVRReimbursementAPI {

    public class requestBodyPOST{
        public date dob;
        public string zip;
    }
    
    public static void createLog(String request, String response, String message, Boolean success, Id tranId){
        IntegrationLog__c il = new IntegrationLog__c();
        il.Callout__c = 'IVR Reimbursements';
        il.FormName__c = 'Non-Form';
        il.Request__c = request;
        il.Response__c = response;
        il.Message__c = message;
        il.Success__c = success;
        il.Type__c = 'Alorica';
        il.Transaction_Management__c = tranId;
        insert il;
        
    }
    
    @HttpPost
    global static void doPost(){
        try{
            Contact conObj = new Contact();
            TransactionMgmtHelper mgmtHelper = new TransactionMgmtHelper();
            Transaction_Management__c tranObj = new Transaction_Management__c();
            tranObj.Operating_Company__c = [SELECT id FROM Operating_Company__c WHERE OperatingCompany__c = 'PMUSA' LIMIT 1].id;   
            if(Test.isRunningTest()){
            	tranObj.TFN__c = [SELECT id FROM TFN__c LIMIT 1].id;     
            }else{
            	tranObj.TFN__c = [SELECT id FROM TFN__c WHERE Name = 'TFN-0002' LIMIT 1].id;  
            }
            String statusCode = '302'; //Updated to String
            String rCreatedDate = '';
            String rShipDate = '';
            String rCardNumber = '';
            String rAmount = ''; //RITM0843946 - SCR 20-10-21 2020 Reimbursement IVR API ver 3
            
            requestBodyPOST reqBody = (requestBodyPOST)Json.deserialize(RestContext.request.requestBody.toString(),requestBodyPOST.class);
             
            //Format date for Transaction Management History
           	String dobFormat = String.valueOf(reqBody.dob);
           	dobFormat = dobFormat.substring(5, 7)+'/'+ dobFormat.substring(8, 10) +'/'+ dobFormat.substring(0, 4);
			
            String SOSLQuery = 'FIND \''+reqBody.dob+' AND '+reqBody.zip+ '\' IN ALL FIELDS RETURNING Contact(id,AVF_GIID_Received__c)';
            System.debug('Query: '+ SOSLQuery);
            List<List <sObject>> searchList = search.query(SOSLQuery);
            System.debug('Search Object: ' + searchList);
            List<Contact> conList = ((List<contact>)searchList[0]);
            if(!conList.isEmpty()){
                if(conList.size() > 1) //Check if multiple customers
                {
                    //Multiple customers found
                    conList.clear();
                    SOSLQuery = 'FIND {IVR REIMBURSEMENTS AND MULTIPLE CONSUMERS}  IN ALL FIELDS RETURNING Contact(id,AVF_GIID_Received__c)';
                    System.debug('Query: '+ SOSLQuery);
                    searchList = search.query(SOSLQuery);
            		System.debug('Search Object: ' + searchList);
                    conList = ((List<contact>)searchList[0]);
                    for(Contact c: conList)
                    {
                        conObj = c;
                        tranObj.Contact__c = c.id;
                    }
                  	tranObj.Comments__c = 'DOB: '+dobFormat+'   ZIP: '+reqBody.zip+'';
					insert tranObj; 
					if(!Test.isRunningTest()){
                    	mgmtHelper.createTransactionMgmtHistoryRecord('MULTIPLE CONSUMERS FOUND',tranObj.id);
                    }
                    conObj.id = null;
                }
                else{
                    for(Contact c: conList){
                        conObj = c;
                    } 
                }
                
            }else if(conList.isEmpty()){
                //No Consumer Found
                conList.clear();
                SOSLQuery = 'FIND {IVR REIMBURSEMENTS AND NO CONSUMER FOUND}  IN ALL FIELDS RETURNING Contact(id,AVF_GIID_Received__c)';
                System.debug('Query: '+ SOSLQuery);
                searchList = search.query(SOSLQuery);
                System.debug('Search Object: ' + searchList);
                conList = ((List<contact>)searchList[0]);
                for(Contact c: conList)
                {
                    conObj = c;
                    tranObj.Contact__c = c.id;
                }
                tranObj.Comments__c = 'DOB: '+dobFormat+'   ZIP: '+reqBody.zip+'';
                insert tranObj;   
                if(!Test.isRunningTest()){
                	mgmtHelper.createTransactionMgmtHistoryRecord('NO CONSUMER FOUND',tranObj.id);
               	}
                conObj.id = null;
            }
            
            if(conObj.id != null){
                
                if(conObj.AVF_GIID_Received__c == false){//Check if Consumer Age is verified
                    //Age not verified
                    tranObj.Contact__c = conObj.id;
                    tranObj.Comments__c = 'DOB: '+dobFormat+'   ZIP: '+reqBody.zip+'';
                    insert tranObj;  
                    if(!Test.isRunningTest()){
                        mgmtHelper.createTransactionMgmtHistoryRecord('CONSUMER IS NOT AGE VERIFIED',tranObj.id);
                    }
                }
                else{
                    Reimbursement__c reI = new Reimbursement__c();
                        
                    for(Reimbursement__c r :  [SELECT CreatedDate,Ship_Date__c,Card_Number__c, Cheque_Amount__c FROM Reimbursement__c 
                                            WHERE Consumer__c =: conObj.id ORDER BY CreatedDate DESC LIMIT 1])
                    {
                        reI = r;
                    }
                    
                    System.debug('Reimbursement: ' + reI);
                    if(reI.id != null){
                        statusCode = '301';
                        rCreatedDate = String.valueOf(reI.CreatedDate);
                        if(reI.Ship_Date__c!=null){
                            rShipDate = String.valueOf(reI.Ship_Date__c);
                            statusCode = '300';
                        }
                        if(reI.Card_Number__c!=null){
                                String tmpCN = reI.Card_Number__c;
                                for(integer i=4;i>0;i--){
                                 	tmpCN = tmpCN.substring(tmpCN.length()-i,tmpCN.length()); 
                                    if(tmpCN.isNumeric()){
                                        rCardNumber = tmpCN;
                                    	break;
                                    }
                                }
                            }
                        if(reI.Cheque_Amount__c!=null){ //RITM0843946 - SCR 20-10-21 2020 Reimbursement IVR API ver 3
                        	rAmount = String.valueOf(reI.Cheque_Amount__c);    
                        }
                        tranObj.Contact__c = conObj.id;
                        tranObj.Comments__c = 'DOB: '+dobFormat+'   ZIP: '+reqBody.zip+'';
                        insert tranObj;  
                        if(!Test.isRunningTest()){
                           mgmtHelper.createTransactionMgmtHistoryRecord('REIMBURSEMENT FOUND',tranObj.id);
                        }
                    }
                    else{
                        //No Reimbursement Info Available
                        tranObj.Contact__c = conObj.id;
                        tranObj.Comments__c = 'DOB: '+dobFormat+'   ZIP: '+reqBody.zip+'';
                        insert tranObj;  
						if(!Test.isRunningTest()){	
							mgmtHelper.createTransactionMgmtHistoryRecord('NO REIMBURSEMENT FOUND FOR CONSUMER',tranObj.id);
                        }
                    }
                }
            }
        
            JSONGenerator bodyJSON = JSON.createGenerator(true);
            
            bodyJSON.writeStartObject();
                bodyJSON.writeStringField('Status code', statusCode);
                if(!String.isEmpty(rCreatedDate)){bodyJSON.writeStringField('RequestDate', rCreatedDate);}
                else {bodyJSON.writeNullField('RequestDate');}
                if(!String.isEmpty(rShipDate)){bodyJSON.writeStringField('ShipDate', rShipDate);}
                else {bodyJSON.writeNullField('ShipDate');}
                if(!String.isEmpty(rCardNumber)){bodyJSON.writeStringField('MasterCardEnd',rCardNumber);}
                else {bodyJSON.writeNullField('MasterCardEnd');}
            	if(!String.isEmpty(rAmount)){bodyJSON.writeStringField('Amount',rAmount);}
                else {bodyJSON.writeNullField('Amount');}
            	bodyJSON.writeNullField('Error');
            bodyJSON.writeEndObject();
            
            String response = bodyJSON.getAsString();
            RestContext.response.addheader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(response); 
            
            String message;
            //300 - Reimbursement Shipped, 301 - Reimbursement Requested, 302 - No information found (Default)
            if(statusCode == '300'){
            	message = '300 - Reimbursement Shipped';   
            }
            else if(statusCode == '301'){
                message = '301 - Reimbursement Requested';
            }
            else{
            	message = '302 - No information found';    
            }
            
           	createLog(RestContext.request.requestBody.toString(),response, message, true,tranObj.id);
        }
        catch(Exception e){
            JSONGenerator bodyJSON = JSON.createGenerator(true);
     
            bodyJSON.writeStartObject();
           		bodyJSON.writeStringField('Status code', '900');//Status code error value
            	bodyJSON.writeNullField('RequestDate');
            	bodyJSON.writeNullField('ShipDate');
            	bodyJSON.writeNullField('MasterCardEnd');
            	bodyJSON.writeNullField('Amount');
            	bodyJSON.writeStringField('Error',String.valueOf(e));
            bodyJSON.writeEndObject();
            
            String response = bodyJSON.getAsString();
            RestContext.response.addheader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(response);
            
            createLog(RestContext.request.requestBody.toString(),response, '900 - Error', false,null);
          } 
    }
}