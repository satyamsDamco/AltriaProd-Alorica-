/**
 * PLProductLineHelper
 * SCR 2026-05-01: Trace Codes - PLOOM Devices          (12-character codes)
 * SCR 2026-07-07: Trace Codes - PLOOM Heatsticks       (9- and 1-character codes)
 *
 * Extracted from DateCodeHelper and TraceCodeHelper to avoid
 * "Class compilation requires too much metadata" error on UAT org.
 * Both classes delegate PL product-line logic here.
 */
public class PLProductLineHelper {

    // ----------------------------------------------------------------
    // Return type used by DateCodeHelper.DateCodeFields()
    // shift/militaryTime/coldStorage/bay/line are only populated by the
    // 9-character heatstick code; the 12-character device code leaves them null.
    // ----------------------------------------------------------------
    public class PLResult {
        public String productionDate;
        public String location;
        public String factory;
        public String serialNumber;
        public String unit;
        public String shift;
        public String militaryTime;
        public String coldStorage;
        public String bay;
        public String line;
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

    // SCR 2026-07-07: 9-character heatstick code - Char1 identifies Factory,
    // Location and Cold Storage. Char7-9 identify Module, Line and Bay.
    private static Set<String> buildValid9CharPosition1() {
        return new Set<String>{ 'R', 'V' };
    }

    private static Set<String> buildValid9CharModules() {
        return new Set<String>{ '5B1', '5C1' };
    }

    // SCR 2026-07-07: heatstick codes produced before this date are invalid.
    private static Date buildEarliestProductionDate() {
        return Date.newInstance(2026, 1, 1);
    }

    // Honours the Override_date custom label the same way the 12-character
    // logic does, so QA can validate future-dated trace codes.
    private static Date buildDateToProcess() {
        Date dateToProcess = System.today();
        if (Label.Override_date != 'yyyy-mm-dd') {
            dateToProcess = Date.valueOf(Label.Override_date);
        }
        return dateToProcess;
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

    // ================================================================
    // SCR 2026-07-07: PLOOM HEATED TOBACCO - 9 character (Packs & Cartons)
    //
    //   Char 1     Factory / Location / Cold Storage  - R or V
    //   Char 2-4   Julian day                         - 001 to 366
    //   Char 5     Hourly code (PMUSA mapping)        - not a validity gate
    //   Char 6     Production year digit
    //   Char 7-9   Module / Line / Bay                - 5B1 or 5C1
    //
    // The positional layout is identical to the PMUSA cigarette (AS) 9-character
    // code, so the Julian/year date maths and the hourly code mapping are reused
    // rather than reimplemented.
    // ================================================================

    // ----------------------------------------------------------------
    // calculate9CharProductionDate
    //   Returns the formatted production date, or 'fail' when any position
    //   or date rule is violated.
    // ----------------------------------------------------------------
    public static String calculate9CharProductionDate(String traceCode) {
        if (traceCode == null || traceCode.length() != 9) { return 'fail'; }

        String code = traceCode.toUpperCase();

        // Char 1 - Factory, Location and Cold Storage
        if (!buildValid9CharPosition1().contains(code.substring(0, 1))) { return 'fail'; }

        // Char 7-9 - Module, Line and Bay
        if (!buildValid9CharModules().contains(code.substring(6, 9))) { return 'fail'; }

        // Char 2-4 (Julian day) and Char 6 (year digit) must be numeric before the
        // shared calculator is called - it runs Integer.valueOf() on both and would
        // throw a TypeException on anything else.
        String julianDay = code.substring(1, 4);
        String yearChar  = code.substring(5, 6);
        if (!julianDay.isNumeric() || !yearChar.isNumeric()) { return 'fail'; }
        Integer julianDayInt = Integer.valueOf(julianDay);
        if (julianDayInt < 1 || julianDayInt > 366) { return 'fail'; }

        try {
            // Shared Julian + year-digit calculator: resolves the year digit against
            // the rolling ten-year window, rejects day 366 in a non-leap year and
            // rejects a production date that is not before today.
            String prodDate = TraceCodeHelperCore.ProductDateCalculator(code, 'PL');
            if (prodDate == null || prodDate.toUpperCase() == 'FAIL') { return 'fail'; }

            Date productionDate = Date.parse(prodDate);

            // SCR: dates prior to 01/01/2026 are invalid
            if (productionDate < buildEarliestProductionDate()) { return 'fail'; }

            // SCR: production date must be less than the system date. Repeated here
            // because ProductDateCalculator only ever compares against System.today()
            // and cannot see the Override_date label.
            if (productionDate >= buildDateToProcess()) { return 'fail'; }

            return productionDate.format();
        } catch (Exception ex) {
            return 'fail';
        }
    }

    // ----------------------------------------------------------------
    // calculate9CharDateCode
    //   Populates every manufacturing field for a 9-character heatstick code.
    //   Production Location and Factory are set for valid AND invalid codes.
    // ----------------------------------------------------------------
    public static PLResult calculate9CharDateCode(String traceCode) {
        PLResult res = new PLResult();
        // Location & Factory are always populated per SCR, regardless of validity
        res.location = 'Virginia';
        res.factory  = 'MC_HORIZON';

        String prodDate = calculate9CharProductionDate(traceCode);
        if (prodDate == 'fail') {
            res.productionDate = 'FAIL';
            return res;
        }

        String code = traceCode.toUpperCase();
        res.productionDate = prodDate;

        // Char 1 - Cold Storage. R = cold stored, V = not cold stored.
        res.coldStorage = (code.substring(0, 1) == 'R') ? 'Y' : 'N';

        // Char 7-9 - Module/Unit, Line and Bay. '5B1' -> unit 5B1, line "Line 5B", bay 5
        res.unit = code.substring(6, 9);
        res.line = code.substring(6, 8);
        res.bay  = code.substring(6, 7);

        // Char 5 - Shift and Military Time, reusing the PMUSA hourly code mapping.
        // An unmapped character returns nothing, which leaves both fields blank
        // without invalidating the trace code.
        Map<String, String> hourly = DateCodeHelperMethods.CigTransDateCalculator(code, prodDate);
        String shift = hourly.get('lv_shift');
        // 'Post' is the PMUSA marker for "no shift for this character" - blanked the
        // same way the cigarette path blanks it.
        res.shift        = (shift == 'Post') ? '' : shift;
        res.militaryTime = hourly.get('lv_military_time');

        return res;
    }

    // ================================================================
    // SCR 2026-07-07: PLOOM HEATED TOBACCO - 1 character
    //   H -> Virginia  / MC_HORIZON
    //   D -> INDONESIA / INDONESIA
    // A 1-character code carries no production date, so a valid one returns
    // 'NODATE' - the established contract for "valid, but no date to store".
    // ================================================================

    public static String calculate1CharProductionDate(String traceCode) {
        if (traceCode == null || traceCode.length() != 1) { return 'fail'; }

        String char1 = traceCode.toUpperCase();
        return (char1 == 'H' || char1 == 'D') ? 'NODATE' : 'fail';
    }

    public static PLResult calculate1CharDateCode(String traceCode) {
        PLResult res = new PLResult();

        String prodDate = calculate1CharProductionDate(traceCode);
        if (prodDate == 'fail') {
            // Unlike the 9-character code there is no default Location/Factory to
            // fall back on - both are derived from the character itself.
            res.productionDate = 'FAIL';
            return res;
        }

        res.productionDate = prodDate;
        if (traceCode.toUpperCase() == 'H') {
            res.location = 'Virginia';
            res.factory  = 'MC_HORIZON';
        } else {
            res.location = 'INDONESIA';
            res.factory  = 'INDONESIA';
        }

        return res;
    }
}