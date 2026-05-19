/* Created By: Infogain Pvt. Ltd.
   Created Date: 11/25/2016
   Purpose: Test Class for DateCodeHelper Controller
*/
@isTest
public class DateCodeHelperTest {
    
    @testSetup static void testData() {
        List<Financial_Week__c> fwList = new List<Financial_Week__c>();
        
        Financial_Week__c fw = new Financial_Week__c();
        fw.PRODUCTION_DATE__c = '03/10/2014';
        fw.FISCAL_WEEK_YEAR__c = '1114';
        
        Financial_Week__c fw2 = new Financial_Week__c();
        fw2.PRODUCTION_DATE__c = '12/29/2014';
        fw2.FISCAL_WEEK_YEAR__c = '0115';
        
        Financial_Week__c fw3 = new Financial_Week__c();
        fw3.PRODUCTION_DATE__c = '03/24/2014';
        fw3.FISCAL_WEEK_YEAR__c = '1314';
        
        Financial_Week__c fw4 = new Financial_Week__c();
        fw4.PRODUCTION_DATE__c = '04/21/2014';
        fw4.FISCAL_WEEK_YEAR__c = '1714';
        
        Financial_Week__c fw5 = new Financial_Week__c();
        fw5.PRODUCTION_DATE__c = '03/14/2016';
        fw5.FISCAL_WEEK_YEAR__c = '1116';
        
        Financial_Week__c fw6 = new Financial_Week__c();
        fw6.PRODUCTION_DATE__c = '08/25/2014';
        fw6.FISCAL_WEEK_YEAR__c = '3514';
        
        Financial_Week__c fw7 = new Financial_Week__c();
        fw7.PRODUCTION_DATE__c = '01/02/2017';
        fw7.FISCAL_WEEK_YEAR__c = '0117';
        
        insert new List<Financial_Week__c> {fw, fw2, fw3, fw4, fw5, fw6, fw7};
            
        Tracecode_Matrix_Table__c tmt = new Tracecode_Matrix_Table__c();
        tmt.Character_Length__c = 9;
        tmt.Position_1__c = 'X';
        tmt.Product_Line_Code__c = 'GP';
        tmt.COLD_STORAGE__c = 'N';
        tmt.Factory__c = 'TestFactory';
        tmt.POPUP_UPC_CODE__c = 'N';
        tmt.Production_Location__c = 'Test Location';
        tmt.Product_Line_Name__c = 'Cigars';
        insert tmt;
        
        Tracecode_Matrix_Table__c tmt2 = new Tracecode_Matrix_Table__c();
        tmt2.Character_Length__c = 12;
        tmt2.Position_1__c = 'X';
        tmt2.Product_Line_Code__c = 'GP';
        tmt2.COLD_STORAGE__c = 'N';
        tmt2.Factory__c = 'TestFactory';
        tmt2.POPUP_UPC_CODE__c = 'N';
        tmt2.Production_Location__c = 'Test Location';
        tmt2.Product_Line_Name__c = 'Cigars';
        insert tmt2;    
        
        Tracecode_Matrix_Table__c tmt3 = new Tracecode_Matrix_Table__c();
        tmt3.Character_Length__c = 9;
        tmt3.Position_1__c = 'A';
        tmt3.Product_Line_Code__c = 'GP';
        tmt3.COLD_STORAGE__c = 'N';
        tmt3.Factory__c = 'TestFactory';
        tmt3.POPUP_UPC_CODE__c = 'Y';
        tmt3.Production_Location__c = 'Test Location';
        tmt3.Product_Line_Name__c = 'Cigars';
        insert tmt3;
        
        Tracecode_Matrix_Table__c tmt4 = new Tracecode_Matrix_Table__c();
        tmt4.Character_Length__c = 12;
        tmt4.Position_1__c = 'A';
        tmt4.Product_Line_Code__c = 'GP';
        tmt4.COLD_STORAGE__c = 'N';
        tmt4.Factory__c = 'TestFactory';
        tmt4.POPUP_UPC_CODE__c = 'Y';
        tmt4.Production_Location__c = 'Test Location';
        tmt4.Product_Line_Name__c = 'Cigars';
        insert tmt4;
        
        Tracecode_Matrix_Table__c tmt5 = new Tracecode_Matrix_Table__c();
        tmt5.Character_Length__c = 11;
        tmt5.Position_1__c = 'H';
        tmt5.Product_Line_Code__c = 'GP';
        tmt5.COLD_STORAGE__c = 'N';
        tmt5.Factory__c = 'TestFactory';
        tmt5.POPUP_UPC_CODE__c = 'N';
        tmt5.Production_Location__c = 'Test Location';
        tmt5.Product_Line_Name__c = 'Cigars';
        insert tmt5;
    }
    
    //Test method for Product Line "EV".
    private static testMethod void dateCodeFieldTestEV() {
        string ProductLineCodeObj='EV';
        string traceCodeObj='0A11141';
        string oprCompanyObj='KIT';
        string TraceCodeLocation='3';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EV".
    private static testMethod void dateCodeFieldTestEVB() {
        string ProductLineCodeObj='EV';
        string traceCodeObj='0B11141';
        string oprCompanyObj='KIT';
        string TraceCodeLocation='3';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EV".
    private static testMethod void dateCodeFieldTestEVC() {
        string ProductLineCodeObj='EV';
        string traceCodeObj='0C11141';
        string oprCompanyObj='KIT';
        string TraceCodeLocation='3';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EV".
    private static testMethod void dateCodeFieldTestEVD() {
        string ProductLineCodeObj='EV';
        string traceCodeObj='0D11141';
        string oprCompanyObj='KIT';
        string TraceCodeLocation='3';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EV".
    private static testMethod void dateCodeFieldTestEVG() {
        string ProductLineCodeObj='EV';
        string traceCodeObj='0G11141';
        string oprCompanyObj='KIT';
        string TraceCodeLocation='3';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EV".
    private static testMethod void dateCodeFieldTestEVS() {
        string ProductLineCodeObj='EV';
        string traceCodeObj='0S11141';
        string oprCompanyObj='KIT';
        string TraceCodeLocation='3';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EV".
    private static testMethod void dateCodeFieldTestEVX() {
        string ProductLineCodeObj='EV';
        string traceCodeObj='0X11141';
        string oprCompanyObj='KIT';
        string TraceCodeLocation='3';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "GP".
    private static testMethod void dateCodeFieldTestGP() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='01tl2ls';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
    
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        DateCodeHelperObj.DateCodeFields('AS','add','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('SP','add','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('GP','add','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('PT','q','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('MD','DADAF','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('CD','DA','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('SN','DA','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('SN','DA','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('WB','DA','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('EC','DA','PMUSA','CAR','','',null);
        DateCodeHelperObj.DateCodeFields('AS','V078x51b5','PMUSA','CAR','','',null);
        Test.stopTest();
    }
    
    //Test method for Product Line "AS".
    private static testMethod void dateCodeFieldAS() {
        string ProductLineCodeObj='AS';
        string traceCodeObj='v030x44a1';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAR';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "AS" with different Date Code.
    private static testMethod void dateCodeFieldAS1() {
        string ProductLineCodeObj='AS';
        string traceCodeObj='r038y63b1';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "AS" where datecode length is 11.
    private static testMethod void dateCodeFieldAS11() {
        string ProductLineCodeObj='AS';
        string traceCodeObj='p039x4b0510';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAR';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "SP".
    private static testMethod void dateCodeFieldSP() {
        string ProductLineCodeObj='SP';
        string traceCodeObj='fbb40749g';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='SB';
        string ustDateCodeObj='aug172014';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "TP".
    private static testMethod void dateCodeFieldTP() {
        string Check2='Subloop';
        string ProductLineCodeObj='TP';
        string traceCodeObj='f050y3x09';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "TP" where DateCode's first char is 'W'.
    private static testMethod void dateCodeFieldTPw() {
        string Check2='Subloop';
        string ProductLineCodeObj='TP';
        string traceCodeObj='w279z0r62';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "TP" to cover method One.
    private static testMethod void dateCodeFieldTPl() {
        string Check2='Subloop';
        string ProductLineCodeObj='TP';
        string traceCodeObj='L012Y2000';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        
        Test.stopTest();
    }
    
    
    //Test method for Product Line "TP".
    private static testMethod void dateCodeFieldTP2() {
        string Check2='Subloop';
        string ProductLineCodeObj='TP';
        string traceCodeObj='y10405z10';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "TP" where Check2 = 'Subloop' for method one.
    private static testMethod void dateCodeFieldTP3() {
        string Check2='Subloop';
        string ProductLineCodeObj='TP';
        string traceCodeObj='n259y1x40';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        DateCodeHelperObj.DateCodeFields('TP','w279z0r62','PMUSA','PAC','','',null);
        DateCodeHelperObj.DateCodeFields('TP','n349FDSAFx1x52','PMUSA','CAN','','',null);
        Test.stopTest();
    }
    
    //Test method for Product Line "GP".
    private static testMethod void dateCodeFieldGP() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='BL2AB';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "GP" where date code length is 8.
    private static testMethod void dateCodeFieldGP8() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='j004y624';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        DateCodeHelperObj.DateCodeFields('GP', 'S068Z601','JMC','PAC','','',null);
        Test.stopTest();
    }
    
    
    //Test method for Product Line "GP" where date code length is 11. Updated 3/2/2021
    private static testMethod void dateCodeFieldGP11() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='Z127X6A1300';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
       
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='H127X6A1300';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PT" where date code length is 4.
    private static testMethod void dateCodeFieldPT4() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='L427';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 4 & first char is J.
    private static testMethod void dateCodeFieldPT4J() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='J017';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 4 & first char is P.
    private static testMethod void dateCodeFieldPT4P() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='P119';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 4 & first char is W.
    private static testMethod void dateCodeFieldPT4W() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='W358';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 4.
    private static testMethod void dateCodeFieldPT4Error() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='LJK7';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 4.
    private static testMethod void dateCodeFieldPT4Error2() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='L547';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 4.
    private static testMethod void dateCodeFieldPT4Error3() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='E358';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PT" where date code length is 6 & first char is L.
    private static testMethod void dateCodeFieldPT6L() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='L12365';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 6 & first char is J.
    private static testMethod void dateCodeFieldPT6J() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='J35084';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 6 & first char is P.
    private static testMethod void dateCodeFieldPT6P() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='P12395';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "PT" where date code length is 6 & first char is W.
    private static testMethod void dateCodeFieldPT6W() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='W05975';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PT" where date code length is 6.
    private static testMethod void dateCodeFieldPT6Error() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='WABC75';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PT" where date code length is 6.
    private static testMethod void dateCodeFieldPT6Error2() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='W36875';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    
    //Test method for Product Line "PT" where date code length is 7.
    private static testMethod void dateCodeFieldPT7() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='EAHAASG';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PT" where date code length is 5.
    private static testMethod void dateCodeFieldPT5() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='hbbt2';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PT" where date code length is 2.
    private static testMethod void dateCodeFieldPT2() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='BL';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        DateCodeHelperObj.DateCodeFields('PT', 'AS','JMC','PAC','','',null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PT" where date code length is 2 and it is leap year.
    private static testMethod void dateCodeFieldPT2LeepYear() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='CL';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 8.
    private static testMethod void dateCodeFieldEC8() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='C0214A08';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" date code length is 8.
    private static testMethod void dateCodeFieldEC8X() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='X4013A01';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" date code length is 8.
    private static testMethod void dateCodeFieldEC8A() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='A4013A01';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" date code length is 8.
    private static testMethod void dateCodeFieldEC8B() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='B4013A01';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" date code length is 8.
    private static testMethod void dateCodeFieldEC8C() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='C4013A01';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" date code length is 8.
    private static testMethod void dateCodeFieldEC8D() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='D4013A01';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" date code length is 8.
    private static testMethod void dateCodeFieldEC8G() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='G4013A01';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" date code length is 8.
    private static testMethod void dateCodeFieldEC8S() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='S4013A01';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "NC" date code length is 8.
    private static testMethod void dateCodeFieldNC8_1() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531YJ';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_2() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531XI';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_3() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531WH';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_4() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531VG';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_5() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531UF';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_6() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531TE';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_7() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531SD';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_8() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531RC';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_9() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531QB';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_10() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531PA';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_11() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531OZ';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldNC8_12() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='234531NY';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "NC" date code length is 8.
    private static testMethod void dateCodeFieldNC9() {
        string ProductLineCodeObj='NC';
        string traceCodeObj='085229Y/I';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 6 & Starting code is A.
    private static testMethod void dateCodeFieldEC6() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='A11814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 6 & Starting code is B.
    private static testMethod void dateCodeFieldEC6B() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='B11814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 6 & Starting code is C.
    private static testMethod void dateCodeFieldEC6C() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='C11814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 6 & Starting code is D.
    private static testMethod void dateCodeFieldEC6D() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='D11814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 6 & Starting code is G.
    private static testMethod void dateCodeFieldEC6G() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='G11814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 6 & Starting code is S.
    private static testMethod void dateCodeFieldEC6S() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='S11814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 6 & Starting code is X.
    private static testMethod void dateCodeFieldEC6X() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='X11814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 11 & Starting code is A.
    private static testMethod void dateCodeFieldEC11() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='A1234511814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 11 & Starting code is B.
    private static testMethod void dateCodeFieldEC11B() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='B1234511814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 11 & Starting code is C.
    private static testMethod void dateCodeFieldEC11C() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='C1234511814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 11 & Starting code is D.
    private static testMethod void dateCodeFieldEC11D() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='D1234511814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 11 & Starting code is G.
    private static testMethod void dateCodeFieldEC11G() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='G1234511814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 11 & Starting code is S.
    private static testMethod void dateCodeFieldEC11S() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='S1234511814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //Test method for Product Line "EC" where date code length is 11 & Starting code is X.
    private static testMethod void dateCodeFieldEC11X() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='X1234511814';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 7.
    private static testMethod void dateCodeFieldEC7() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='BA11141';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length 7.
    private static testMethod void dateCodeFieldEC7A() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='BB01156';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 7 and second char is C.
    private static testMethod void dateCodeFieldEC7C() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='BC13145';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 7 and second char is D.
    private static testMethod void dateCodeFieldEC7D() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='BD17146';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 7 and second char is S.
    private static testMethod void dateCodeFieldEC7S() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='BS11161';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "EC" where date code length is 7 and second char is X.
    private static testMethod void dateCodeFieldEC7X() {
        string ProductLineCodeObj='EC';
        string traceCodeObj='BX35144';
        string oprCompanyObj='NUMRK';
        string TraceCodeLocation='KIT';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "DS".
    private static testMethod void dateCodeFieldDS() {
        string ProductLineCodeObj='DS';
        string traceCodeObj='021101815';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PC".
    private static testMethod void dateCodeFieldPC() {
        string ProductLineCodeObj='PC';
        string traceCodeObj='fbb40523x';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='SB';
        string ustDateCodeObj='apr272014';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PC" with different ustDateCode.
    private static testMethod void dateCodeFieldPC1() {
        string ProductLineCodeObj='PC';
        string traceCodeObj='hch419403';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='SB';
        string ustDateCodeObj='jan182015';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PC" where ustDateType is CD.
    private static testMethod void dateCodeFieldPC2() {
        string ProductLineCodeObj='PC';
        string traceCodeObj='rbb41317w';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='CD';
        string ustDateCodeObj='sep142014';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PC" where ustDateType is 'WB'.
    private static testMethod void dateCodeFieldPC2WB() {
        string ProductLineCodeObj='PC';
        string traceCodeObj='rbb41317w';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='WB';
        string ustDateCodeObj='04/26/2015';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PC" where ustDateType is 'SN'.
    private static testMethod void dateCodeFieldPC2SN() {
        string ProductLineCodeObj='PC';
        string traceCodeObj='rbb41317w';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='SN';
        string ustDateCodeObj='04/26/2015';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "PC" where ustDateType is 'WB'.
    private static testMethod void nextDayTest() {
        string vDate='06/26/2014';
        string vDay='mon';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.nextDay(vDate,vDay);
        Test.stopTest();
    }
    //Test method for Method one.
    private static testMethod void MethodOneTest() 
    {
        string Check2='Subloop';
        string ProductLineCodeObj='TP';
        string traceCodeObj='y10410110';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
        //Test method for Product Line "GP" where date code length is 12.
    private static testMethod void dateCodeFieldGP12() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='R133X6R17151';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "GP" where date code length is 9.
    private static testMethod void dateCodeFieldGP9() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='A200X88P4';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "GP" where date code length is 9.
    private static testMethod void dateCodeFieldGP9_2() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='X200X88P4';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    private static testMethod void dateCodeFieldGP12_2() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='H133X6R17151';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeFieldGP12_3() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='A133X6R17151';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeFieldGP12_4() {
        string ProductLineCodeObj='GP';
        string traceCodeObj='X133X6R17151';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //=======================================================
    //2017 USST Trace Codes Test
    //=======================================================
    //Test method.
    private static testMethod void dateCodeUSST2017_1() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='N057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }

    private static testMethod void dateCodeUSST2017_R() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='R057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeUSST2017_C() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='C057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeUSST2017_M() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='M057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }

    private static testMethod void dateCodeUSST2017_D() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='D057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }

    private static testMethod void dateCodeUSST2017_S() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='S057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeUSST2017_H() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='H057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeUSST2017_V() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='V057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeUSST2017_Y() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='Y057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeUSST2017_T() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='T057E0912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeUSST2017_T_Existing() 
    {
        Account testAccount = TestDataSetup.createAccount('Testing Tracecode Account 001');
        insert testAccount;
        
        Contact testContact = TestDataSetup.createContact('Testing Tracecode Contact 001', testAccount.Id, true);
        testContact.firstName = 'firstName';
        testContact.Street_Address__c = 'Street_Address__c';
        testContact.Zip_Code__c = '1930';
        insert testContact;
        
        Operating_Company__c  testOc = TestDataSetup.createOpCo('Test Channel', 'Test Description', 'Test Direction', 'USST', true);
        insert testOc;
        
        Case testCase = TestDataSetup.createTraceCode(testAccount, 200.00, testContact.Id, 'CAN', 'King Size', 'T112Z2008', Date.newInstance(2017, 06, 14), '06/14/2017', 'Virginia', '2', 'Z', '', '', 'MC_USSTC', '2008', testOc.Id);

        insert testCase;
        
        Datetime validDate = Date.newInstance(2017, 06, 14);
        Test.setCreatedDate(testCase.Id, validDate);
        
        string ProductLineCodeObj='SP';
        string traceCodeObj='T112X2008';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,testCase);
        Test.stopTest();
    }
    
    //10/19/2019 - JD - Increase test coverage
    private static testMethod void PTtraceCode4nonNumeric(){
       string ProductLineCodeObj='PT';
        string traceCodeObj='ACBA';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
        
    //=======================================================
    //=======================================================
        
    //Test method for Product Line "TDNP"
    private static testMethod void dateCodeFieldTDNP() {
        string ProductLineCodeObj='TDNP';
        string traceCodeObj;
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
         traceCodeObj='WA001Q2';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
         traceCodeObj='UA001Q2';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
         traceCodeObj='YA001Q2';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
         traceCodeObj='ZA001Q2';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='AA001Q2'; //Invalid POS 1 
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='W0001Q2'; //Invalid Pos 2
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='W3651Q2'; //Invalid Future Date
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='UA0Q1Q2 '; //Invalid Shift     
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D032U0715';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='R032U0715';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='C032U0715';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='M032U0715';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='A032U0715'; //Invalid Pos 1
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D365U0715'; //future date
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D367U0715'; //Invalid Julian day
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D000U0715'; //Invalid Julian day
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='DA65U0715'; //Invalid Julian day
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D060U2415'; //Invalid Shift
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D060X2315'; //Invalid Module
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        //Add Test for 1 Char
        traceCodeObj='M'; //Valid char M
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='S'; //Valid char S
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='J'; //All others chars other than M ans S are invalid for 1 char
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    //RITM0370406 - SCR 20-04-16 Trace Codes - USSTC 9-Character and Helix ON 7-Character
    private static testMethod void dateCodeUSST_RITM0370406() 
    {
        string ProductLineCodeObj='SP';
        string traceCodeObj='S05720912';
        string oprCompanyObj='USST';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='S05730912';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='C090D1042';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "AS" for CIG transition
    private static testMethod void dateCodeFieldAS_RITM0691496() {
        string ProductLineCodeObj='AS';
        string traceCodeObj='C291A02C3';
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAR';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N028A02E3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='P366A02K3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='W291A02P3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D228A92P3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N291A02K3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N291A92P3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N298A92A3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D291G92P3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D291M92P3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D291U92P3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D291Y92P3';
         DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D291W92P3';
         DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='D291Z92P3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N298G92A3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N298M92A3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N298U92A3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N298X92A3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N298W92A3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='N298Z92A3';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    private static testMethod void dateCodeFieldPT12() {
        string ProductLineCodeObj='PT';
        string traceCodeObj='S175Y0011621';
        string oprCompanyObj='JMC';
        string TraceCodeLocation='PAC';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        traceCodeObj='X003X0011313';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);
        Test.stopTest();
    }
    
    //Test method for Product Line "SNP"
    private static testMethod void dateCodeFieldSNP() {
        string ProductLineCodeObj='SNP';
        string traceCodeObj;
        string oprCompanyObj='PMUSA';
        string TraceCodeLocation='CAN';
        string ustDateTypeObj='';
        string ustDateCodeObj='';
        
        Test.startTest();
        DateCodeHelper DateCodeHelperObj=new DateCodeHelper();
        traceCodeObj='D261N0912';
        DateCodeHelperObj.DateCodeFields(ProductLineCodeObj, traceCodeObj,oprCompanyObj,TraceCodeLocation,ustDateTypeObj,ustDateCodeObj,null);

        Test.stopTest();
    }
    
}