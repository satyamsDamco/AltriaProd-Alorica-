@isTest
private class DateCodeHelperMethodsTest {

    /* CigTransDateCalculator: when Test.isRunningTest() is true the class
       overrides the CIG transition labels to 2019-10-18 .. 2019-10-20,
       so all assertions below are deterministic. */

    @isTest
    static void testCigTransDateCalculator_beforeWindow() {
        Test.startTest();
        Map<String,String> retVal = DateCodeHelperMethods.CigTransDateCalculator('AAAAWAAAA', '10/01/2019');
        Test.stopTest();
        System.assertEquals('W', retVal.get('lv_shift'), 'Before the transition window the raw 5th character is the shift');
    }

    @isTest
    static void testCigTransDateCalculator_duringWindow() {
        Test.startTest();
        Map<String,String> rW = DateCodeHelperMethods.CigTransDateCalculator('AAAAWAAAA', '10/19/2019');
        Map<String,String> rZ = DateCodeHelperMethods.CigTransDateCalculator('AAAAZAAAA', '10/19/2019');
        Map<String,String> rB = DateCodeHelperMethods.CigTransDateCalculator('AAAABAAAA', '10/19/2019');
        Map<String,String> rG = DateCodeHelperMethods.CigTransDateCalculator('AAAAGAAAA', '10/19/2019');
        Map<String,String> rN = DateCodeHelperMethods.CigTransDateCalculator('AAAANAAAA', '10/19/2019');
        Map<String,String> rO = DateCodeHelperMethods.CigTransDateCalculator('AAAAOAAAA', '10/19/2019');
        Map<String,String> rV = DateCodeHelperMethods.CigTransDateCalculator('AAAAVAAAA', '10/19/2019');
        Map<String,String> rX = DateCodeHelperMethods.CigTransDateCalculator('AAAAXAAAA', '10/19/2019');
        Map<String,String> r1 = DateCodeHelperMethods.CigTransDateCalculator('AAAA1AAAA', '10/19/2019');
        Test.stopTest();

        System.assertEquals('Z', rW.get('lv_shift'));
        System.assertEquals('2300', rW.get('lv_military_time'));
        System.assertEquals('Z', rZ.get('lv_shift'));
        System.assertEquals('0000', rZ.get('lv_military_time'));
        System.assertEquals('Z', rB.get('lv_shift'));
        System.assertEquals('0200', rB.get('lv_military_time'));
        System.assertEquals('X', rG.get('lv_shift'));
        System.assertEquals('0700', rG.get('lv_military_time'));
        System.assertEquals('X', rN.get('lv_shift'));
        System.assertEquals('1400', rN.get('lv_military_time'));
        System.assertEquals('Y', rO.get('lv_shift'));
        System.assertEquals('1500', rO.get('lv_military_time'));
        System.assertEquals('Y', rV.get('lv_shift'));
        System.assertEquals('2200', rV.get('lv_military_time'));
        System.assertEquals('X', rX.get('lv_shift'), 'Alpha character outside all shift lists keeps its own value');
        System.assertEquals(null, rX.get('lv_military_time'));
        System.assertEquals(null, r1.get('lv_shift'), 'Numeric 5th character produces no shift');
    }

    @isTest
    static void testCigTransDateCalculator_afterWindow() {
        Test.startTest();
        Map<String,String> rX = DateCodeHelperMethods.CigTransDateCalculator('AAAAXAAAA', '10/25/2019');
        Map<String,String> rW = DateCodeHelperMethods.CigTransDateCalculator('AAAAWAAAA', '10/25/2019');
        Map<String,String> rZ = DateCodeHelperMethods.CigTransDateCalculator('AAAAZAAAA', '10/25/2019');
        Map<String,String> rC = DateCodeHelperMethods.CigTransDateCalculator('AAAACAAAA', '10/25/2019');
        Map<String,String> rJ = DateCodeHelperMethods.CigTransDateCalculator('AAAAJAAAA', '10/25/2019');
        Map<String,String> rP = DateCodeHelperMethods.CigTransDateCalculator('AAAAPAAAA', '10/25/2019');
        Test.stopTest();

        System.assertEquals('Post', rX.get('lv_shift'), 'After the window an alpha char outside all lists maps to Post');
        System.assertEquals('Z', rW.get('lv_shift'));
        System.assertEquals('2300', rW.get('lv_military_time'));
        System.assertEquals('0000', rZ.get('lv_military_time'));
        System.assertEquals('Z', rC.get('lv_shift'));
        System.assertEquals('0300', rC.get('lv_military_time'));
        System.assertEquals('X', rJ.get('lv_shift'));
        System.assertEquals('1000', rJ.get('lv_military_time'));
        System.assertEquals('Y', rP.get('lv_shift'));
        System.assertEquals('1600', rP.get('lv_military_time'));
    }

    @isTest
    static void testCigTransDateCalculator_wrongLengthReturnsEmpty() {
        Test.startTest();
        Map<String,String> retVal = DateCodeHelperMethods.CigTransDateCalculator('AAAAWAAAAA', '10/19/2019');
        Test.stopTest();
        System.assert(retVal.isEmpty(), 'Trace codes that are not 9 characters return an empty map');
    }

    @isTest
    static void testNextDay() {
        Test.startTest();
        Date nextMonday   = DateCodeHelperMethods.nextDay('07/01/2026', 'MONDAY');
        Date followingMon = DateCodeHelperMethods.nextDay('07/06/2026', 'MONDAY');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2026, 7, 6), nextMonday, '07/01/2026 is a Wednesday; next Monday is 07/06');
        System.assertEquals(Date.newInstance(2026, 7, 13), followingMon, 'Starting on a Monday returns the following Monday');
    }

    @isTest
    static void testMondayDate() {
        Test.startTest();
        String week1 = DateCodeHelperMethods.mondayDate('2015', '1');
        String week2 = DateCodeHelperMethods.mondayDate('2015', '2');
        Test.stopTest();
        System.assertEquals(Date.newInstance(2014, 12, 29).format(), week1, 'Fiscal week 1 of 2015 starts Monday 12/29/2014');
        System.assertEquals(Date.newInstance(2015, 1, 5).format(), week2, 'Fiscal week 2 of 2015 starts Monday 01/05/2015');
    }

    @isTest
    static void testMonthNumber() {
        System.assertEquals(1, DateCodeHelperMethods.monthNumber('Y'));
        System.assertEquals(9, DateCodeHelperMethods.monthNumber('Q'));
        System.assertEquals(12, DateCodeHelperMethods.monthNumber('N'));
        System.assertEquals(null, DateCodeHelperMethods.monthNumber('B'), 'Unmapped character returns null');
    }

    @isTest
    static void testYearNumber() {
        System.assertEquals(2014, DateCodeHelperMethods.yearNumber('L'));
        System.assertEquals(2025, DateCodeHelperMethods.yearNumber('A'));
        System.assertEquals(2027, DateCodeHelperMethods.yearNumber('Y'));
        System.assertEquals(null, DateCodeHelperMethods.yearNumber('Q'), 'Unmapped character returns null');
    }

    @isTest
    static void testGetTraceCodeValuesForNC_8CharValid() {
        Test.startTest();
        DateCodeHelperCore.TraceCodeValue tcv =
            DateCodeHelperMethods.getTraceCodeValuesForNC('12345678', '12', '30', '15', 'Y', 'C', '');
        Test.stopTest();
        System.assertEquals('1/15/2023', tcv.ProductionDate, 'Y=January and C=2023 must produce 1/15/2023');
        System.assertEquals('1230', tcv.lvMilitaryTime);
        System.assert(tcv.lnDays > 0, 'Production date must be in the past');
    }

    @isTest
    static void testGetTraceCodeValuesForNC_8CharInvalidChar() {
        Test.startTest();
        DateCodeHelperCore.TraceCodeValue tcv =
            DateCodeHelperMethods.getTraceCodeValuesForNC('12345678', 'AB', '30', '15', 'A', 'C', '');
        Test.stopTest();
        System.assertEquals('FAIL', tcv.ProductionDate, 'Invalid month character must fail');
    }

    @isTest
    static void testGetTraceCodeValuesForNC_9CharValid() {
        Test.startTest();
        DateCodeHelperCore.TraceCodeValue tcv =
            DateCodeHelperMethods.getTraceCodeValuesForNC('123456789', '10', '45', '20', 'N', 'X', 'B');
        Test.stopTest();
        System.assertEquals('12/20/2024', tcv.ProductionDate, 'N=December and B=2024 must produce 12/20/2024');
        System.assertEquals('1045', tcv.lvMilitaryTime);
    }

    @isTest
    static void testGetTraceCodeValuesForNC_9CharInvalidChar() {
        Test.startTest();
        DateCodeHelperCore.TraceCodeValue tcv =
            DateCodeHelperMethods.getTraceCodeValuesForNC('123456789', '10', '45', '20', 'N', 'X', 'Q');
        Test.stopTest();
        System.assertEquals('FAIL', tcv.ProductionDate, 'Invalid year character must fail');
    }

    @isTest
    static void testGetTraceCodeValuesForNC_OtherLength() {
        Test.startTest();
        DateCodeHelperCore.TraceCodeValue tcv =
            DateCodeHelperMethods.getTraceCodeValuesForNC('1234567', '10', '45', '20', 'N', 'X', 'B');
        Test.stopTest();
        System.assertEquals(null, tcv.ProductionDate, 'Unsupported lengths return an empty value object');
    }

    @isTest
    static void testPTtraceCode4nonNumeric_validCode() {
        DateCodeHelperCore h = new DateCodeHelperCore();
        h.lv_cur_year = String.valueOf(System.today().year());

        Test.startTest();
        DateCodeHelperMethods.PTtraceCode4nonNumeric('BLBL', h);
        Test.stopTest();

        System.assertEquals('Limerick', h.lv_location);
        System.assertEquals('Limerick', h.lv_date_code_rpt_factory);
        System.assertEquals('12', h.lv_day, 'BL decodes to day 12');
        System.assertEquals('01', h.lv_month, 'B decodes to month 01');

        // Expected year = current decade digit + '2' (from year char L -> 02)
        String yy = h.lv_cur_year.substring(2, 3) + '2';
        Date derived = Date.newInstance(Integer.valueOf('20' + yy), 1, 12);
        if (derived < System.today()) {
            System.assertEquals('01/12/20' + yy, h.production_date);
        } else {
            System.assertEquals('FAIL', h.production_date);
        }
    }

    @isTest
    static void testPTtraceCode4nonNumeric_futureYear() {
        DateCodeHelperCore h = new DateCodeHelperCore();
        h.lv_cur_year = String.valueOf(System.today().year());

        Test.startTest();
        DateCodeHelperMethods.PTtraceCode4nonNumeric('BMBL', h);
        Test.stopTest();

        // Year char M -> 07; derived year = current decade digit + '7'
        String yy = h.lv_cur_year.substring(2, 3) + '7';
        Date derived = Date.newInstance(Integer.valueOf('20' + yy), 1, 12);
        if (derived >= System.today()) {
            System.assertEquals('FAIL', h.production_date, 'A derived date in the future must fail');
        } else {
            System.assertEquals('01/12/20' + yy, h.production_date);
        }
    }

    @isTest
    static void testPTtraceCode4Numeric_allLocations() {
        // Same data pattern as TraceCodeTest: Financial_Week__c keyed by fiscal week + 2-digit year
        String yr = String.valueOf(System.today().year());
        Date past = System.today().addDays(-30);
        Financial_Week__c fw = new Financial_Week__c(
            FISCAL_WEEK_YEAR__c = '10' + yr.substring(2, 4),
            PRODUCTION_DATE__c  = past.format()
        );
        insert fw;

        String code = '10' + yr.substring(3, 4); // week 10 of the current year

        Test.startTest();
        DateCodeHelperCore hL = new DateCodeHelperCore();
        DateCodeHelperMethods.PTtraceCode4Numeric('L' + code, hL);
        DateCodeHelperCore hJ = new DateCodeHelperCore();
        DateCodeHelperMethods.PTtraceCode4Numeric('J' + code, hJ);
        DateCodeHelperCore hP = new DateCodeHelperCore();
        DateCodeHelperMethods.PTtraceCode4Numeric('P' + code, hP);
        DateCodeHelperCore hW = new DateCodeHelperCore();
        DateCodeHelperMethods.PTtraceCode4Numeric('W' + code, hW);
        Test.stopTest();

        System.assertEquals('LIMERICK', hL.lv_location);
        System.assertEquals('N', hL.lv_date_code_cold_storage);
        System.assertEquals(past.format(), hL.production_date, 'Production date comes from the Financial Week record');

        System.assertEquals('LIMERICK', hJ.lv_location);
        System.assertEquals('Y', hJ.lv_date_code_cold_storage);

        System.assertEquals('COLONIAL HEIGHTS', hP.lv_location);
        System.assertEquals('PRECON_JMC', hP.lv_date_code_rpt_factory);
        System.assertEquals('N', hP.lv_date_code_cold_storage);

        System.assertEquals('COLONIAL HEIGHTS', hW.lv_location);
        System.assertEquals('Y', hW.lv_date_code_cold_storage);
    }

    @isTest
    static void testPTtraceCode4Numeric_invalidFails() {
        DateCodeHelperCore h = new DateCodeHelperCore();
        Test.startTest();
        DateCodeHelperMethods.PTtraceCode4Numeric('X996', h);
        Test.stopTest();
        System.assertEquals('fail', h.production_date, 'Week above 53 and an invalid first character must fail');
    }

    @isTest
    static void testMethodOne_TPSubloopNashville() {
        // With lv_year1 shortened to '/2' the derived year is 4 digits and the
        // date-derivation branch completes end to end.
        DateCodeHelperCore h = new DateCodeHelperCore();
        h.ProductLineCode = 'TP';
        h.Check2 = 'Subloop';
        h.traceCode = 'NSH506142';
        h.lv_year1 = '/2';

        Test.startTest();
        DateCodeHelperMethods.methodOne(h);
        Test.stopTest();

        System.assertEquals('Nashville', h.lv_location);
        System.assertEquals('NS', h.lv_date_code_rpt_factory);
        System.assertEquals('0614', h.lv_military_time);
        // second_number '14' -> year 2014, first_number 5 -> Jan 5 2014
        System.assertEquals(Date.newInstance(2014, 1, 5).format(), h.production_date);
    }

    @isTest
    static void testMethodOne_TPSubloopDefaultYearPrefixThrows() {
        // With the default lv_year1 ('/20') the class builds a 5-digit year
        // ('01/01/20014') and Date.parse throws - assert that actual behavior.
        DateCodeHelperCore h = new DateCodeHelperCore();
        h.ProductLineCode = 'TP';
        h.Check2 = 'Subloop';
        h.traceCode = 'NSH506142';

        Boolean threw = false;
        Test.startTest();
        try {
            DateCodeHelperMethods.methodOne(h);
        } catch (System.TypeException e) {
            threw = true;
        }
        Test.stopTest();

        System.assert(threw, 'Default year prefix produces an unparseable 5-digit year');
        System.assertEquals('Nashville', h.lv_location, 'Location is set before the date derivation throws');
        System.assertEquals('0614', h.lv_military_time);
    }

    @isTest
    static void testMethodOne_nonNumericFails() {
        DateCodeHelperCore h = new DateCodeHelperCore();
        h.ProductLineCode = 'TP';
        h.Check2 = 'Subloop';
        h.traceCode = 'NSHA0614B';

        Test.startTest();
        DateCodeHelperMethods.methodOne(h);
        Test.stopTest();

        System.assertEquals('FAIL', h.production_date, 'Non-numeric positions must fail');
    }

    @isTest
    static void testMethodOne_firstNumberOutOfRangeFails() {
        DateCodeHelperCore h = new DateCodeHelperCore();
        h.ProductLineCode = 'TP';
        h.Check2 = 'Subloop';
        h.traceCode = 'NSH906142';

        Test.startTest();
        DateCodeHelperMethods.methodOne(h);
        Test.stopTest();

        System.assertEquals('FAIL', h.production_date, 'First number 9 is outside the 1-8 range');
    }

    @isTest
    static void testMethodOne_nonTPDoesNothing() {
        DateCodeHelperCore h = new DateCodeHelperCore();
        h.ProductLineCode = 'GP';
        h.Check2 = 'Subloop';
        h.traceCode = 'NSH506142';

        Test.startTest();
        DateCodeHelperMethods.methodOne(h);
        Test.stopTest();

        System.assertEquals('', h.production_date, 'methodOne only processes TP Subloop codes');
    }
}