/*
  Test Class for Trace Code
  11/23/2016 Infogain – Created.
   */

@isTest
public class NewLineTest
{
    // validate NewLine method 
    public static testmethod void NewLineMethodTest(){
        
            Operating_Company__c testOpCo= new Operating_Company__c();
            testOpCo.OperatingCompany__c = 'PMUSA';
            testOpCo.OpCo_Description__c = 'Test123';
            testOpCo.Active__c = true;
            insert testOpCo;
            
            TFN__c testTFN= new TFN__c();
            testTFN.Operating_Company__c = testOpCo.id;
            testTFN.Toll_Free_Number__c = '1234';
            testTFN.DNIS__c = String.valueOf(123);
            insert testTFN;
            
            Transaction_Management__c testTM= new Transaction_Management__c();
            testTM.Operating_Company__c = testOpCo.Id;
            testTM.TFN__c = testTFN.id;
            insert testTM;
            
            
           Case c = new Case(Comment__c = 'test,',Update_Reason__c =  'test,',MasterId__c = testTM.Name, Op_Company__c = testOpCo.id);
           insert c;
           c.Comment__c = '';
           c.Update_Reason__c = '';
           update c;
           
           Answer__c a = new Answer__c(Answer__c = 'test123');
           insert a;
           
           Attachment_Detail__c ad = new  Attachment_Detail__c(Description__c = 'test123');
           insert ad;
           ad.Description__c  = '';
           update ad;
           
            Product_Line__c testPL= new Product_Line__c();
            testPL.Name = 'SET';
            testPL.Code__c = 'Se';
            testPL.isActive__c = true;
            testPL.isValidDateCode__c = true;
            testPL.Op_Company__c = testOpCo.id;
            testPL.Trace_Code_Location__c =  'CAN';
            insert testPL;
            
            Brand__c testBrand= new Brand__c();
            testBrand.Description__c = 'Brand';
            testBrand.BrandCode__c = 'VR';
            testBrand.Product_Line__c = testPL.id;
            testBrand.Op_Company__c = testOpCo.id;
            insert testBrand;
           
           Brand_Hierarchy__c b= new Brand_Hierarchy__c(Vantive_Id__c = '11', Brand_Code__c = testBrand.id, Product_Line_Code__c = testPL.id , Price_Category__c = 'test123', Product_Desc__c = 'Test123',Product_Type__c = 'test123');
           insert b;
           
           Question__c  q=  new  Question__c(Question__c = 'test123',Type__c = 'Comment');
           insert q;
           
           Store_type__c testStoty = new Store_type__c();
            testStoty.Description__c= 'test123';
            insert testStoty;
           
           Store__c at = new Store__c(Store_Comment__c = 'test123', Store_Type__c = testStoty.id);
           insert at;
           
           Survey__c testSurvey = new Survey__c();
           testSurvey.Survey_Name__c = 'Test123';
           insert testSurvey;
           
           Survey_Issue__c st = new Survey_Issue__c(Survey__c = testSurvey.id, Transaction__c = testTM.id, Issue__c = c.id,Comment__c = 'test123');
           insert  st;
        
            Case caseRec1 = [SELECT Id, IsReviewed__c FROM Case];
            caseRec1.Product_Line__c = 'Tobacco Derived Nicotine pouch';
            caseRec1.PLCode__c = 'TDNP';
            caseRec1.Trace_Code_Location__c = 'Can';
            caseRec1.Mfg_Trace_code__c = 'AA1234';
            update caseRec1;
        
        	Case caseRec2 = [SELECT Id, IsReviewed__c FROM Case];
            caseRec2.Product_Line__c = 'Tobacco Derived Nicotine pouch';
            caseRec2.PLCode__c = 'TDNP';
            caseRec2.Trace_Code_Location__c = 'Can';
            caseRec2.Mfg_Trace_code__c = 'D023U0823';
            update caseRec2;
        
            Case caseRec3 = [SELECT Id, IsReviewed__c FROM Case];
            caseRec3.Product_Line__c = 'NJOY E-CIG TRACE CODE';
            caseRec3.Mfg_Trace_code__c = '02612651124';
            update caseRec3;
            
            Case caseRec4 = [SELECT Id, IsReviewed__c FROM Case];
            caseRec4.PLCode__c = 'AS';
            caseRec4.Mfg_Trace_code__c = 'S363K49S3';
            update caseRec4;
        
        	test.startTest();
            caseRec4.Mfg_Trace_code__c = 'X';
            update caseRec4;
        	caseRec4.Mfg_Trace_code__c = 'U';
            update caseRec4;
        	caseRec4.Mfg_Trace_code__c = 'V';
            update caseRec4;
        	caseRec4.Mfg_Trace_code__c = 'S363A49S3';
        	update caseRec4;
        	caseRec4.Mfg_Trace_code__c = 'S363P49S3';
        	update caseRec4;
        	caseRec4.Mfg_Trace_code__c = 'S363V49S3';
        	update caseRec4;
        	caseRec4.Mfg_Trace_code__c = 'S363X49S3';
        	update caseRec4;
        	test.StopTest();
			
            for(Integer i=0 ; i<7 ; i++){
                //for Baker One
               Case test1 = [SELECT Id, IsReviewed__c FROM Case];
                test1.Product_Line__c = 'Testing Baker one';
                test1.PLCode__c = 'DS';
                test1.Trace_Code_Location__c = 'Can';
                String firstdigit = (i == 0 ? 'K' : (i == 1 ? 'O' : (i == 2 ? 'B' : 'A')));
                String fifthdigit = (i == 0 ? 'G' :
                                     (i == 1 ? 'O' :
                                     (i == 2 ? 'K' :
                                     (i == 3 ? 'T' :
                                     (i == 4 ? 'Y' :
                                     (i == 5 ? 'U' : 'Z'))))));
                test1.Mfg_Trace_code__c = firstdigit+'360'+fifthdigit+'1210';
                update test1;
            }

    }    
}