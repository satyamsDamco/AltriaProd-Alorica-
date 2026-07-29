@isTest
private class PLProductLineHelperTest {

    // ----------------------------------------------------------------
    // Day-restraints matrix verification for calculateProductionDate
    // Base prefix "UE2500000" = U (location) + E (module) + 2500000 (serial)
    // Char10='5' => 2025, Char11 => month, Char12 => day
    //
    // calculateProductionDate(traceCodeUpper, traceCodeOrig) takes the
    // uppercased code plus the original-case code (so lowercase 'd',
    // day 13, is preserved).
    // ----------------------------------------------------------------

    @isTest
    static void testCalculateProductionDate_31DayMonth_Day31_Valid() {
        // Char11='A'(Jan, 31-day month), Char12='0'(31) -> Date(2025,1,31)
        String code = 'UE25000005A0';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals(Date.newInstance(2025, 1, 31).format(), result);
    }

    @isTest
    static void testCalculateProductionDate_30DayMonth_Day31_Fails() {
        // Char11='D'(Apr, 30-day month), Char12='0'(31) -> Date(2025,4,31) is calendar-impossible
        String code = 'UE25000005D0';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_Feb_Day28_Valid() {
        // Char11='B'(Feb), Char12='W'(28) -> Date(2025,2,28)
        String code = 'UE25000005BW';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals(Date.newInstance(2025, 2, 28).format(), result);
    }

    @isTest
    static void testCalculateProductionDate_Feb29_NonLeapYear_Fails() {
        // Char11='B'(Feb), Char12='X'(29), Char10='5'(2025, non-leap) -> calendar-impossible
        String code = 'UE25000005BX';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_Feb30_Fails() {
        // Char11='B'(Feb), Char12='Y'(30) -> Date(2025,2,30) is calendar-impossible
        String code = 'UE25000005BY';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_Feb31_Fails() {
        // Char11='B'(Feb), Char12='0'(31) -> Date(2025,2,31) is calendar-impossible
        String code = 'UE25000005B0';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    @isTest
    static void testCalculateProductionDate_LowercaseD_Day13_Valid() {
        // Char11='A'(Jan), Char12='d' (lowercase, day 13) -> Date(2025,1,13)
        String traceCodeOrig  = 'UE25000005Ad';
        String traceCodeUpper = traceCodeOrig.toUpperCase();
        String result = PLProductLineHelper.calculateProductionDate(traceCodeUpper, traceCodeOrig);
        System.assertEquals(Date.newInstance(2025, 1, 13).format(), result);
    }

    @isTest
    static void testCalculateProductionDate_UppercaseD_DayChar_Fails() {
        // Char12='D' (uppercase) is not present in the day mapping (only lowercase 'd' is)
        String code = 'UE25000005AD';
        String result = PLProductLineHelper.calculateProductionDate(code, code);
        System.assertEquals('fail', result);
    }

    // ----------------------------------------------------------------
    // calculateDateCode regression coverage
    // ----------------------------------------------------------------

    @isTest
    static void testCalculateDateCode_ValidCode_PopulatesFields() {
        String code = 'UE25000005A0';
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculateDateCode(code, code);
        System.assertEquals('INDONESIA', res.location);
        System.assertEquals('INDONESIA', res.factory);
        System.assertEquals('2500000', res.serialNumber);
        System.assertEquals('E', res.unit);
        System.assertEquals(Date.newInstance(2025, 1, 31).format(), res.productionDate);
    }

    @isTest
    static void testCalculateDateCode_InvalidCalendarDate_ReturnsFAIL() {
        // Char11='B'(Feb), Char12='Y'(30) -> calendar-impossible
        String code = 'UE25000005BY';
        PLProductLineHelper.PLResult res = PLProductLineHelper.calculateDateCode(code, code);
        System.assertEquals('FAIL', res.productionDate);
    }
}