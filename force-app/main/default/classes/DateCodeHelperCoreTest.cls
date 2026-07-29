@isTest
private class DateCodeHelperCoreTest {

    @isTest
    static void testConstructorInitialisesDefaults() {
        Test.startTest();
        DateCodeHelperCore core = new DateCodeHelperCore();
        Test.stopTest();

        System.assertNotEquals(null, core.DateCodeObj, 'Constructor must initialise the DateCode object');
        System.assertEquals('/201', core.lv_year, 'Default lv_year must be /201');
        System.assertEquals('/20', core.lv_year1, 'Default lv_year1 must be /20');
        System.assertEquals('/202', core.lv_year_new, 'Default lv_year_new must be /202');
        System.assertEquals('20', core.lv_year_new1, 'Default lv_year_new1 must be 20');
        System.assertEquals('20', core.lv_leap_year, 'Default lv_leap_year must be 20');
        System.assertEquals('0', core.ln_leap, 'Default ln_leap must be 0');
        System.assertEquals(0, core.ln_cnt, 'Default ln_cnt must be 0');
        System.assertEquals(0, core.ln_days, 'Default ln_days must be 0');
        System.assertEquals(0, core.Retcode, 'Default Retcode must be 0');
        System.assertEquals('SUCCESS', core.RetDesc, 'Default RetDesc must be SUCCESS');
        System.assertEquals(0, core.CHECK, 'Default CHECK must be 0');
        System.assertEquals('', core.Check2, 'Default Check2 must be empty');
        System.assertEquals('', core.production_date, 'Default production_date must be empty');
        System.assertEquals('', core.fiscal_week, 'Default fiscal_week must be empty');
        System.assertNotEquals(null, core.charSet, 'charSet must be initialised');
        System.assertNotEquals(null, core.intSet, 'intSet must be initialised');
        System.assertNotEquals(null, core.fw, 'Financial week record holder must be initialised');
    }

    @isTest
    static void testDateCodeInnerClassHoldsValues() {
        DateCodeHelperCore.DateCode dc = new DateCodeHelperCore.DateCode();
        dc.ProductionDate        = '01/15/2023';
        dc.DateCodeLocation      = 'Limerick';
        dc.DateCodeShift         = 'X';
        dc.DateCodeUnit          = '01';
        dc.DateCodeColdStorage   = 'N';
        dc.DateCodeRptBay        = 'Bay 9';
        dc.DateCodeRptFactory    = 'LIMERICK';
        dc.DateCodeMilitaryTime  = '1230';
        dc.UstDateCode           = 'U123';
        dc.SerialNumber          = '2500000';

        System.assertEquals('01/15/2023', dc.ProductionDate);
        System.assertEquals('Limerick', dc.DateCodeLocation);
        System.assertEquals('X', dc.DateCodeShift);
        System.assertEquals('01', dc.DateCodeUnit);
        System.assertEquals('N', dc.DateCodeColdStorage);
        System.assertEquals('Bay 9', dc.DateCodeRptBay);
        System.assertEquals('LIMERICK', dc.DateCodeRptFactory);
        System.assertEquals('1230', dc.DateCodeMilitaryTime);
        System.assertEquals('U123', dc.UstDateCode);
        System.assertEquals('2500000', dc.SerialNumber);
    }

    @isTest
    static void testTraceCodeValueInnerClassHoldsValues() {
        DateCodeHelperCore.TraceCodeValue tcv = new DateCodeHelperCore.TraceCodeValue();
        tcv.ProductionDate          = '1/15/2023';
        tcv.lvLocation              = 'Nashville';
        tcv.lvDateCodeRptFactory    = 'NS';
        tcv.lvMilitaryTime          = '1230';
        tcv.lvDateCodeColdStorage   = 'Y';
        tcv.lnDays                  = 10;

        System.assertEquals('1/15/2023', tcv.ProductionDate);
        System.assertEquals('Nashville', tcv.lvLocation);
        System.assertEquals('NS', tcv.lvDateCodeRptFactory);
        System.assertEquals('1230', tcv.lvMilitaryTime);
        System.assertEquals('Y', tcv.lvDateCodeColdStorage);
        System.assertEquals(10, tcv.lnDays);
    }
}