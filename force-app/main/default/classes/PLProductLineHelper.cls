/**
 * PLProductLineHelper
 * SCR 2026-05-01: Trace Codes - PLOOM Devices
 *
 * Extracted from DateCodeHelper and TraceCodeHelper to avoid
 * "Class compilation requires too much metadata" error on UAT org.
 * Both classes delegate PL product-line logic here.
 */
public class PLProductLineHelper {

    // ----------------------------------------------------------------
    // Return type used by DateCodeHelper.DateCodeFields()
    // ----------------------------------------------------------------
    public class PLResult {
        public String productionDate;
        public String location;
        public String factory;
        public String serialNumber;
        public String unit;
    }

    // ----------------------------------------------------------------
    // Shared lookup tables (built once per transaction)
    // ----------------------------------------------------------------
    private static Map<String, Integer> buildYearMapping() {
        return new Map<String, Integer>{
            '5' => 2025, '6' => 2026, '7' => 2027, '8' => 2028, '9' => 2029,
            'A' => 2030, 'B' => 2031, 'C' => 2032
        };
    }

    private static Map<String, Integer> buildMonthMapping() {
        return new Map<String, Integer>{
            'A' => 1,  'B' => 2,  'C' => 3,  'D' => 4,
            'E' => 5,  'F' => 6,  'G' => 7,  'H' => 8,
            'I' => 9,  'J' => 10, 'K' => 11, 'L' => 12
        };
    }

    private static Map<String, Integer> buildDayMapping() {
        // 'd' intentionally lowercase — SCR critical implementation note
        return new Map<String, Integer>{
            '1' => 1,  '2' => 2,  '3' => 3,  '4' => 4,  '5' => 5,
            '6' => 6,  '7' => 7,  '8' => 8,  '9' => 9,
            'A' => 10, 'B' => 11, 'C' => 12, 'd' => 13, 'E' => 14,
            'F' => 15, 'G' => 16, 'H' => 17, 'J' => 18, 'K' => 19,
            'L' => 20, 'M' => 21, 'N' => 22, 'P' => 23, 'R' => 24,
            'T' => 25, 'U' => 26, 'V' => 27, 'W' => 28, 'X' => 29,
            'Y' => 30, '0' => 31
        };
    }

    private static Set<String> buildValidModules() {
        return new Set<String>{ 'E', 'F', 'G', 'H', 'J', 'K', 'L' };
    }

    // ----------------------------------------------------------------
    // calculateProductionDate
    //   Called by TraceCodeHelper.traceCodeValidation (returns String)
    //   traceCodeUpper : already uppercased trace code
    //   traceCodeOrig  : original (not uppercased) to preserve lowercase 'd'
    // ----------------------------------------------------------------
    public static String calculateProductionDate(String traceCodeUpper, String traceCodeOrig) {
        if (traceCodeUpper == null || traceCodeOrig == null) { return 'fail'; }
        if (traceCodeUpper.length() != 12) { return 'fail'; }

        String char1     = traceCodeUpper.substring(0, 1);
        String char2     = traceCodeUpper.substring(1, 2);
        String serialNum = traceCodeUpper.substring(2, 9);
        String yearChar  = traceCodeUpper.substring(9, 10);
        String monthChar = traceCodeUpper.substring(10, 11);
        // Position 12 must come from the ORIGINAL string to keep lowercase 'd'
        String dayChar   = traceCodeOrig.substring(11, 12);

        if (char1 != 'U') { return 'fail'; }

        Set<String> validModules = buildValidModules();
        if (!validModules.contains(char2)) { return 'fail'; }

        if (!serialNum.isNumeric()) { return 'fail'; }
        Integer serialInt = Integer.valueOf(serialNum);
        if (serialInt < 2000000 || serialInt > 3200000) { return 'fail'; }

        Map<String, Integer> yearMap  = buildYearMapping();
        Map<String, Integer> monthMap = buildMonthMapping();
        Map<String, Integer> dayMap   = buildDayMapping();

        if (!yearMap.containsKey(yearChar))   { return 'fail'; }
        if (!monthMap.containsKey(monthChar)) { return 'fail'; }
        if (!dayMap.containsKey(dayChar))     { return 'fail'; }

        try {
            Date dateToProcess = System.today();
            if (Label.Override_date != 'yyyy-mm-dd') {
                dateToProcess = Date.valueOf(Label.Override_date);
            }

            Integer prodMonth = monthMap.get(monthChar);
            Integer prodDay   = dayMap.get(dayChar);
            Date prodDate = Date.newInstance(yearMap.get(yearChar), prodMonth, prodDay);

            // Date.newInstance is lenient: an out-of-range day (e.g. Feb 31) rolls
            // over into the next month (Feb 31, 2025 -> Mar 3, 2025) instead of
            // throwing. Reject the trace code if the constructed date's month/day
            // no longer match the values encoded in Char11/Char12 - this enforces
            // the full leap-year-aware day-restraints matrix (Feb 29 valid only in
            // leap years, 30-day months reject day 31, etc.) without a separate table.
            if (prodDate.month() != prodMonth || prodDate.day() != prodDay) {
                return 'fail';
            }

            return (prodDate < dateToProcess) ? prodDate.format() : 'fail';
        } catch (Exception ex) {
            return 'fail';
        }
    }

    // ----------------------------------------------------------------
    // calculateDateCode
    //   Called by DateCodeHelper.DateCodeFields (returns PLResult)
    //   Populates location, factory, serial, unit, and productionDate.
    // ----------------------------------------------------------------
    public static PLResult calculateDateCode(String traceCodeUpper, String traceCodeOrig) {
        PLResult res = new PLResult();
        // Location & Factory are always INDONESIA per SCR, regardless of validity
        res.location = 'INDONESIA';
        res.factory  = 'INDONESIA';

        if (traceCodeUpper == null || traceCodeOrig == null
                || traceCodeUpper.length() != 12) {
            res.productionDate = 'FAIL';
            return res;
        }

        String char2     = traceCodeUpper.substring(1, 2);
        String serialNum = traceCodeUpper.substring(2, 9);

        res.serialNumber = serialNum;

        Set<String> validModules = buildValidModules();
        if (validModules.contains(char2)) {
            res.unit = char2;
        }

        // Re-use the validation method; normalise casing of result
        String prodDate = calculateProductionDate(traceCodeUpper, traceCodeOrig);
        res.productionDate = (prodDate == 'fail') ? 'FAIL' : prodDate;

        return res;
    }
}