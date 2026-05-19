/* Created By: Infogain Pvt. Ltd.
   Created Date: 11/23/2016
   Purpose: Test Class for Trace Code class
*/
@isTest
public class TraceCodeTest
{
    //JD - Build test data
    @testSetup static void testData() {
        List<Financial_Week__c> fwList = new List<Financial_Week__c>();
        
        Financial_Week__c fw = new Financial_Week__c();
        fw.PRODUCTION_DATE__c = '03/10/2014';
        fw.FISCAL_WEEK_YEAR__c = '1114';
        
        insert new List<Financial_Week__c> {fw};
            
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
        tmt3.Character_Length__c = 11;
        tmt3.Position_1__c = 'H';
        tmt3.Product_Line_Code__c = 'GP';
        tmt3.COLD_STORAGE__c = 'N';
        tmt3.Factory__c = 'TestFactory';
        tmt3.POPUP_UPC_CODE__c = 'N';
        tmt3.Production_Location__c = 'Test Location';
        tmt3.Product_Line_Name__c = 'Cigars';
        insert tmt3;
        
        TraceCodeHelperSecondClass.ProductDateCalculator('S363K49S3', 'AS');
        TraceCodeHelperSecondClass.sixCharacterProductDate('AA1234');
    }
    //JD - Build test data
     @testSetup
    static void setupData() {
        Financial_Week__c fw = new Financial_Week__c(
            PRODUCTION_DATE__c = '03/10/2014',
            FISCAL_WEEK_YEAR__c = '1114'
        );
        insert fw;

        List<Tracecode_Matrix_Table__c> listTmt = new List<Tracecode_Matrix_Table__c>();

        listTmt.add(new Tracecode_Matrix_Table__c(
            Character_Length__c = 9,
            Position_1__c = 'X',
            Product_Line_Code__c = 'GP',
            COLD_STORAGE__c = 'N',
            Factory__c = 'TestFactory',
            POPUP_UPC_CODE__c = 'N',
            Production_Location__c = 'Test Location',
            Product_Line_Name__c = 'Cigars'
        ));

        listTmt.add(new Tracecode_Matrix_Table__c(
            Character_Length__c = 12,
            Position_1__c = 'X',
            Product_Line_Code__c = 'GP',
            COLD_STORAGE__c = 'N',
            Factory__c = 'TestFactory',
            POPUP_UPC_CODE__c = 'N',
            Production_Location__c = 'Test Location',
            Product_Line_Name__c = 'Cigars'
        ));

        listTmt.add(new Tracecode_Matrix_Table__c(
            Character_Length__c = 11,
            Position_1__c = 'H',
            Product_Line_Code__c = 'GP',
            COLD_STORAGE__c = 'N',
            Factory__c = 'TestFactory',
            POPUP_UPC_CODE__c = 'N',
            Production_Location__c = 'Test Location',
            Product_Line_Name__c = 'Cigars'
        ));

        insert listTmt;
    }

    // ---------------- validateTraceCode ----------------
    @IsTest
    static void test_validateTraceCode() {
        String valid = TraceCodeHelperSecondClass.validateTraceCode('K365G2359');
        String invalid = TraceCodeHelperSecondClass.validateTraceCode('Z000A9999');
    }

    // ---------------- ProductDateCalculator ----------------
    @IsTest
    static void test_ProductDateCalculator() {
        TraceCodeHelperSecondClass.ProductDateCalculator('S120K4A12', 'AS');
        TraceCodeHelperSecondClass.ProductDateCalculator('S120K4A12', 'GP');
        TraceCodeHelperSecondClass.ProductDateCalculator('S999K4A12', 'GP');
        TraceCodeHelperSecondClass.ProductDateCalculator('S120K4A12', 'TDNS');
    }

    // ---------------- sixCharacterProductDate ----------------
    @IsTest
    static void test_sixCharacterProductDate() {
        TraceCodeHelperSecondClass.sixCharacterProductDate('AB1234');
        TraceCodeHelperSecondClass.sixCharacterProductDate('ZZ0000');
    }

    // ---------------- JulianDateChecker ----------------
    @IsTest
    static void test_JulianDateChecker() {
        TraceCodeHelperSecondClass.JulianDateChecker('365', 2024);
        TraceCodeHelperSecondClass.JulianDateChecker('366', 2024);
        TraceCodeHelperSecondClass.JulianDateChecker('400', 2024);
        TraceCodeHelperSecondClass.JulianDateChecker('abc', 2024);
    }

    // ---------------- NjoyTraceCode ----------------
    @IsTest
    static void test_NjoyTraceCode() {
        String todayYear = String.valueOf(System.today().year());
        String lastDigit = todayYear.substring(3,4);

        String validCode = '120A102345' + lastDigit;
        String invalidCode = '9990000000' + lastDigit;

        TraceCodeHelperSecondClass.NjoyTraceCode(validCode);
        TraceCodeHelperSecondClass.NjoyTraceCode(invalidCode);
    }

    // ---------------- validateTDNP10CharTraceCode ----------------
    /*@IsTest
    static void test_validateTDNP10CharTraceCode() {

        // VALID CASE
        String valid = '6234U10301';  // 2026 + valid julian + valid shift + valid module + valid machine
        TraceCodeHelperSecondClass.validateTDNP10CharTraceCode(valid);

        // INVALID LENGTH
        TraceCodeHelperSecondClass.validateTDNP10CharTraceCode('123');

        // INVALID YEAR CODE
        TraceCodeHelperSecondClass.validateTDNP10CharTraceCode('X234U10301');

        // INVALID JULIAN
        TraceCodeHelperSecondClass.validateTDNP10CharTraceCode('6367U10301');

        // INVALID SHIFT
        TraceCodeHelperSecondClass.validateTDNP10CharTraceCode('6234U99991');

        // INVALID MODULE
        TraceCodeHelperSecondClass.validateTDNP10CharTraceCode('6234Z10301');

        // INVALID MACHINE CODE
        TraceCodeHelperSecondClass.validateTDNP10CharTraceCode('6234U10309');
    }*/
    
    // validate TraceCode method 
    public static testmethod void TraceCodeMethodTest(){
    
        CounterfeitTraceCode__c counterFeit = new CounterfeitTraceCode__c();
        counterFeit.Trace_Code__c = 'xyxx';
        counterFeit.Production_Date__c = date.Today();
        counterFeit.IsActive__c =  true;
        insert counterFeit;
        
        counterFeit = new CounterfeitTraceCode__c();
        counterFeit.Trace_Code__c = 'xx';
        counterFeit.IsActive__c =  true;
        insert counterFeit;
        
        TraceCodeHelper.checkCounterfeitTraceCode('xyxx');
        
        TraceCodeHelper.checkCounterfeitTraceCode('xyx');
        
        Test.startTest();
        TraceCodeHelper tt = new TraceCodeHelper();

        tt.traceCodeValidation('GP','BL2AB','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','BL2AB','','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','xyxx','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','xx','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','BA11141','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','02612651124','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','r364z02a3','PMUSA','CAR',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DS','021101815','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','BL2AB','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','01tl2ls','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','j004y624','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','P145Z3S1108','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','bclm','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','ehla2','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','EAHAASG','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','BA11141','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','C0214A08','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','BA09145','NUMRK','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','A1314A01','NUMRK','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EV','078','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EV','O78','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EV','086','NUMRK','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','r005z62a3','PMUSA','CAR',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','p039x4b0510','PMUSA','CAR',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','R344Z55C4','PMUSA','CAS',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','c008y90l7','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','shn61317l','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('TP','f050y3x09','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('TP','f050x3x09','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('TP','f050x3x09','PMUSA','CAS',null);
        
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DS','021101815','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PC','fbb40523x','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','NDL6320V','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','NDL6320V','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','R326y34c1','USST','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','v326y34c1','USST','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('UU','fbg62147x','USST','CAN',null);
        
        
         tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','BL2A','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','xyx','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','BA111','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','r005z6a3','PMUSA','CAR',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DS','02101815','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','B2AB','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','01l2ls','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','j04y624','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','P5Z3S1108','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','blm','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','ela2','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','EAHASG','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','B11141','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','C014A08','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','B09145','NUMRK','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','A314A01','NUMRK','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EV','0878','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EV','O708','NUMRK','KIT',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EV','0866','NUMRK','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','r05z62a3','PMUSA','CAR',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','p09x4b0510','PMUSA','CAR',null);
        
        
        test.stoptest();
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('AS','c08y90l7','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','sh61317l','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('TP','f00y3x09','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('TP','f50x3x09','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DS','02101815','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PC','fb40523x','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','NDL620V','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','v36y34c1','USST','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('UU','fb62147x','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DNUA','un2014','PMUSA','CAN',null);
        
        
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Dec152013','USST','CAN',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Jan152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Feb152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Mar152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Apr152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','May152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Jun152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Jul152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Aug152013','USST','CAN',null);      
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Sep152013','USST','CAN',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Oct152013','USST','CAN',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','Nov152013','USST','CAN',null);
		
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SB','013','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('CD','13/15','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('CD','115','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('CD','ABCD','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('CD','12CD','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GFU','may112014','USST','CAN',null);
        
       
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GFU','ma12014','USST','CAN',null);
        
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','BL2AB','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','hb2hm','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','ll1hm','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','sl2bt','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','01tl2ls','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','11hi3hi','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','44ab3hb','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','J9EC3LT','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','S3ST2LK','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','x1hl3ht','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','j004y624','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','L002X302','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','s032x501','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','x003x604','JMC','PAC',null);
        
        
    
    }

    // validate TraceCode method 
    public static testmethod void TraceCodeMethodTest2(){
        Test.StartTest();
        TraceCodeHelper tt = new TraceCodeHelper();
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','P145Z3S1108','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','W133X6R1715','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','bclm','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','calt','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','ichm','JMC','PAC',null);
        
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','9145939110811111111','PMUSA','CAS',null);
       tt = new TraceCodeHelper();
                tt.traceCodeValidation('GP','v3673461','USST','CAS',null);
       tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','123X2','JMC','CAS',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DNUA','01012016','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DNUA','21212016','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DNUA','30Jun2014','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('SP','v36y34c1','PMUSA','PAC',null);
        
         tt = new TraceCodeHelper();
        tt.traceCodeValidation('TP','ft0y3x09','PMUSA','CAN',null);
         tt = new TraceCodeHelper();
        tt.traceCodeValidation('TP','z00y3x09','PMUSA','CAN',null);
        Test.StopTest();
    }     
    
        // validate TraceCode method 
    public static testmethod void TraceCodeMethodTest1(){
    
        CounterfeitTraceCode__c counterFeit = new CounterfeitTraceCode__c();
        counterFeit.Trace_Code__c = 'xyxx';
        counterFeit.Production_Date__c = date.Today();
        counterFeit.IsActive__c =  true;
        insert counterFeit;
        
        counterFeit = new CounterfeitTraceCode__c();
        counterFeit.Trace_Code__c = 'xx';
        counterFeit.IsActive__c =  true;
        insert counterFeit;
        
        Test.StartTest();
        TraceCodeHelper tt = new TraceCodeHelper();
                
        tt.traceCodeValidation('PT','khlk','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','mchm','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','CL','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','rchb','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','ehla2','JMC','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','hbbt2','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','ltba2','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','EAHAASG','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PT','JBCMXKN','JMC','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EC','BA11141','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EC','C0214A08','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EC','S0213A99','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EC','X0114A01','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EC','cc42145','NUMRK','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EC','A1314A01','NUMRK','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EV','078','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EV','225','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EV','328','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EV','407','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EV','511','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EV','601','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('EV','100','NUMRK','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('AS','r005z62a3','PMUSA','CAR',null);
        
        tt = new tracecodeHelper();
                tt.traceCodeValidation('AS','S363K49S3','PMUSA','CAR',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('AS','v006x53d1','PMUSA','CAR',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('AS','p039x4b0510','PMUSA','CAR',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('AS','c008y90l7','PMUSA','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('AS','N018Y20E6','PMUSA','PAC',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','shn61317l','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','f050y3x09','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','n020x1x05','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','N021X2X12','PMUSA','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','L021X2000','PMUSA','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','10211201N','PMUSA','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','N102112011','PMUSA','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','111111111111111','PMUSA','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','102112014','PMUSA','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','Y02112X11','PMUSA','CAA',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','Y02112S11','PMUSA','CAA',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','L02112S11','PMUSA','CAA',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','L021X2000','PMUSA','CAA',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','L02112S1N','PMUSA','CAA',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','w122z1r11','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','w12225r14','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','L122z1r14','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','y03605y1q0000000000','PMUSA','CAS',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Jun2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','10Jan2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','22Feb2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Mar2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','10Apr2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','10May2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Jul2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Aug2014','PMUSA','CAN',null);               
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Sep2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Oct2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Nov2014','PMUSA','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DNUA','30Dec2014','PMUSA','CAN',null);
                
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DS','021101815','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DS','157055514','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DS','205093214','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('DS','303054413','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','fbb40523x','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','hcc311002','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','kfb42230x','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','ncd508123','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','pbb31305w','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','rbb40332x','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','scc507033','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('PC','veh203412','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','NDL6320V','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','fbb40749g','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','hcc30020v','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','KFB41152G','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','ncc51344n','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','pbb30149x','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','rbb31427o','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','veh30012n','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('UU','fbg62147x','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('UU','kfb40414x','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('UU','pbf30215x','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('UU','rfb31807','USST','CAS',null);
                tt.nextDay('11/11/2016','Monday');
		Test.StopTest();
        //==============================
        //New 2017 USST Trace Codes
        //==============================
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','N057E0912','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','R063C0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','T063Z0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','Y063Z0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','S123S0110','USST','CAN',null);  
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','H123S0110','USST','CAN',null);      
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','V123S0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','Z123S0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','R123C0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','C123C0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','M123C0110','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','D123C0110','USST','CAN',null);
        //==============================
        //tt.methodOne(); 
        
        //RITM0370406 - SCR 20-04-16 Trace Codes - USSTC 9-Character and Helix ON 7-Character    
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','S05720912','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','S05730912','USST','CAN',null);
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('SP','C090D1042','USST','CAN',null);
        
    }

    public static testmethod void TraceCodeMethodTest3(){
        Test.StartTest();
        TraceCodeHelper tt = new TraceCodeHelper();
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','N1223511N','PMUSA','CAN',null); //35 = second character
                
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','N1223511Q','PMUSA','CAN',null);
                
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','A12235113','PMUSA','CAN',null);

        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','A1A23511A','PMUSA','CAN',null);
                
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','F1A23511A','PMUSA','CAN',null);
                
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','FFA23511A','PMUSA','CAN',null);
                
        tt = new TraceCodeHelper();
                tt.traceCodeValidation('TP','N1223511G','PMUSA','CAN',null);
                
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DNUA','55212016','NUMRK','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('CD','1200','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('CD','1212','USST','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('IQ','ZZ03606009','PMUSA','CAN',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229UH','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229YL','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229XK','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229WJ','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229VI','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229TG','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229SF','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229RE','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229QD','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229PC','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229OB','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229NA','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229UZ','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','062229UY','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715Y/L','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715X/K','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715W/J','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715V/I','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715U/H','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715T/G','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715S/F','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715R/E','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715Q/D','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715P/C','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715O/B','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715N/A','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715Y/Z','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('NC','080715Y/Y','PMUSA','PAC',null);
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','V200X88P4','PMUSA','PAC',null);
        Test.StopTest();
        
    }
    
    
    public static testmethod void TraceCodeMethodTest4(){
        Test.StartTest();
        TraceCodeHelper tt = new TraceCodeHelper();
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','L427','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','J114','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','P119','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','W358','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','LJK7','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','L547','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','E358','JMC','PAC',null);
        
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','L12365','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','J35084','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','P12395','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','W05975','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','WABC75','JMC','PAC',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('PT','W36875','JMC','PAC',null);
		Test.StopTest();
    }
    
    public static testmethod void TraceCodeMethodTest5(){
		Test.StartTest();
        TraceCodeHelper tt = new TraceCodeHelper();
        
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','A1234511814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','B1234511814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','C1234511814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','D1234511814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','G1234511814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','S1234511814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','X1234511814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','A11814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','B11814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','C11814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','D11814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','G11814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','S11814','NUMRK','KIT',null);
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('EC','X11814','NUMRK','KIT',null);
		Test.StopTest();
    }
    
    public static testmethod void TraceCodeMethodTestOld(){
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
        TraceCodeHelper tt = new TraceCodeHelper();
        Test.StartTest();
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('DS','T112X2008','USST','CAN',testCase);
        tt.traceCodeValidation('DS','O011G0923','USST','CAN',null);
        tt.traceCodeValidation('DS','K011G0923','USST','CAN',null);
        tt.traceCodeValidation('DS','B011G0923','USST','CAN',null);
        Test.StopTest();

    }
    

    //10/15/2019 - JD -  Increase test coverage
    public static testmethod void TraceCodeMethodTest6(){
        
        TraceCodeHelper tt = new TraceCodeHelper();
        test.startTest();
        tt = new TraceCodeHelper();
        tt.traceCodeValidation('GP','xx03xp604','JMC','PAC',null);
        tt.traceCodeValidation('GP','xx03xp604ps1','JMC','PAC',null);
        tt.traceCodeValidation('GP','X243Z78P4','JMC','PAC',null);
        tt.traceCodeValidation('GP','X035Z9151722','JMC','PAC',null);
        tt.traceCodeValidation('GP','H127X6A1300','JMC','PAC',null);
        tt.traceCodeValidation('GP','Z127X6A1300','JMC','PAC',null);
        tt.traceCodeValidation('GP','H127B6A1300','JMC','PAC',null);
        tt.traceCodeValidation('GP','H127X6A2400','JMC','PAC',null);        
        tt.traceCodeValidation('GP','H127X6AA400','JMC','PAC',null);
        test.stoptest();
    
    }
    
    public static testmethod void TraceCodeMethodTest7(){
        // Tracecode for Helix 6,7 and 9 characters
      
        TracecodeHelper tt = new TraceCodeHelper();
        test.startTest();
        tt.traceCodeValidation('TDNP','KA2204','HELIX','CAN',null);
        tt.traceCodeValidation('TDNP','WA001Q2','HELIX','CAN',null);
        tt.traceCodeValidation('TDNP','UA001Q2','HELIX','CAN',null);
        tt.traceCodeValidation('TDNP','YA001Q2','HELIX','CAN',null);
        tt.traceCodeValidation('TDNP','ZA001Q2','HELIX','CAN',null);
        tt.traceCodeValidation('TDNP','AA001Q2','HELIX','CAN',null); //Invalid pos 1
        tt.traceCodeValidation('TDNP','W0001Q2','HELIX','CAN',null); //Invalid pos 2
        tt.traceCodeValidation('TDNP','W3651Q2','HELIX','CAN',null); //future date
        tt.traceCodeValidation('TDNP','UA0Q1Q2','HELIX','CAN',null); //invalid Shift
        tt.traceCodeValidation('TDNP','D032U0715','HELIX','CAN',null);
        tt.traceCodeValidation('TDNP','R032U0715','HELIX','CAN',null); 
        tt.traceCodeValidation('TDNP','C032U0715','HELIX','CAN',null); 
        tt.traceCodeValidation('TDNP','M032U0715','HELIX','CAN',null); 
        tt.traceCodeValidation('TDNP','A032U0715','HELIX','CAN',null); //Invalid pos 1
        tt.traceCodeValidation('TDNP','D365U0715','HELIX','CAN',null); //future date
        tt.traceCodeValidation('TDNP','D000U0715','HELIX','CAN',null); //invalid julian date
        tt.traceCodeValidation('TDNP','D367U0715','HELIX','CAN',null); //invalid julian date
        tt.traceCodeValidation('TDNP','DA65U0715','HELIX','CAN',null); //invalid julian date
        tt.traceCodeValidation('TDNP','D060U2415','HELIX','CAN',null); //invalid shift
        tt.traceCodeValidation('TDNP','D060X2315','HELIX','CAN',null); //invalid module
        //Add test for 1 char
        tt.traceCodeValidation('TDNP','M','HELIX','CAN',null); //Valid char M
        tt.traceCodeValidation('TDNP','S','HELIX','CAN',null); //Valid char S
        tt.traceCodeValidation('TDNP','J','HELIX','CAN',null); //Invalid chars other than M and S
        tt.traceCodeValidation('TDNP','JD','HELIX','CAN',null); //Invalid length
        tt.traceCodeValidation('SNP','D024A1856','HELIX','CAN',null);
        tt.traceCodeValidation('TDNS','D024A1856','HELIX','CAN',null);

    	test.stopTest();
    }
    
     public static testmethod void TraceCodeMethodTest8(){
        // Tracecode for PT 12 Characters
      
        TracecodeHelper tt = new TraceCodeHelper();
        test.startTest();
        tt.traceCodeValidation('PT','S175Y0011621','JMC','PAC',null);//Valid tracecode
        tt.traceCodeValidation('PT','Q175Y0011621','JMC','PAC',null);//Invalid 1st Char
        tt.traceCodeValidation('PT','SA75Y0011621','JMC','PAC',null);//Julian Char invalid
        tt.traceCodeValidation('PT','S375Y0011621','JMC','PAC',null);//Julian Char invalid day leap year
        tt.traceCodeValidation('PT','S375Y1011621','JMC','PAC',null);//Julian Char invalid day
        tt.traceCodeValidation('PT','S175Y1111621','JMC','PAC',null);//Future date
        tt.traceCodeValidation('PT','S175Q0011621','JMC','PAC',null);//Invalid 5th char
        tt.traceCodeValidation('PT','S175YA011621','JMC','PAC',null);//year char invalid
        tt.traceCodeValidation('PT','S175Y00S1621','JMC','PAC',null);//module char invalid
        tt.traceCodeValidation('PT','S175Y001A621','JMC','PAC',null);//Military char invalid - hour
        tt.traceCodeValidation('PT','S175Y00116A1','JMC','PAC',null);//Military char invalid - min
        tt.traceCodeValidation('PT','S175Y0012621','JMC','PAC',null);//Military char exceeded hour
        tt.traceCodeValidation('PT','S175Y0011661','JMC','PAC',null);//Military char exceeded min
    	test.stopTest();
    }
    
         public static testmethod void TraceCodeMethodTest10(){
        // Tracecode for PT 12 Characters
      
       // TraceCodeHelperSecondClass tt = new TraceCodeHelperSecondClass();
        test.startTest();
       TraceCodeHelperSecondClass.validateTDNP10CharTraceCode('D365U07151');
    	test.stopTest();
    }
}