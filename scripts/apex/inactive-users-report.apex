/**
 * =============================================================================
 *  INACTIVE USER AUDIT  --  Anonymous Apex
 * =============================================================================
 *  Returns ACTIVE users who either:
 *    (a) last logged in MORE than INACTIVE_DAYS days ago, or
 *    (b) have NEVER logged in AND were created more than INACTIVE_DAYS ago
 *        (the CreatedDate guard gives brand-new users a grace period so they
 *         are not flagged the day their account is provisioned).
 *
 *  HOW TO RUN
 *    VS Code      : right-click in the editor ->
 *                   "SFDX: Execute Anonymous Apex with Editor Contents"
 *    Dev Console  : Debug -> Open Execute Anonymous Window (CTRL+E) -> paste
 *                   NOTE: tick "Open Log" and set the Apex log level to at
 *                   least ERROR so the System.debug output is captured.
 *
 *  Set OUTPUT_MODE to 'LOG', 'EMAIL' or 'FILE'.
 * =============================================================================
 */

// ------------------------------------------------------------------ CONFIG --
final Integer INACTIVE_DAYS = 30;                      // inactivity threshold
final Boolean INCLUDE_NEVER = true;                    // include never-logged-in users
final Boolean STANDARD_ONLY = true;                    // exclude Chatter/Guest/Portal/system users
final Integer MAX_ROWS      = 5000;                    // heap guard - see notes at bottom
final String  OUTPUT_MODE   = 'LOG';                   // 'LOG' | 'EMAIL' | 'FILE'
final String  EMAIL_TO      = UserInfo.getUserEmail(); // used only when OUTPUT_MODE = 'EMAIL'
// -----------------------------------------------------------------------------

// Bind variable instead of a date literal: unambiguous, and evaluated against
// the org's actual clock rather than the running user's locale/timezone.
final Datetime cutoff = Datetime.now().addDays(-INACTIVE_DAYS);

String whereClause =
    'IsActive = TRUE ' +
    (STANDARD_ONLY ? 'AND UserType = \'Standard\' ' : '') +
    'AND ( LastLoginDate < :cutoff' +
    (INCLUDE_NEVER ? ' OR (LastLoginDate = NULL AND CreatedDate < :cutoff)' : '') +
    ' )';

// Cheap aggregate first, so we know whether MAX_ROWS truncated the export.
Integer totalMatches = Database.countQuery('SELECT COUNT() FROM User WHERE ' + whereClause);

List<User> staleUsers = Database.query(
    'SELECT Id, Name, Email, Username, Profile.Name, IsActive, CreatedDate, LastLoginDate ' +
    'FROM User ' +
    'WHERE ' + whereClause + ' ' +
    'ORDER BY LastLoginDate ASC NULLS FIRST, CreatedDate ASC ' +
    'LIMIT ' + MAX_ROWS
);

// ------------------------------------------------------------ BUILD OUTPUT --
final List<String> HEADERS = new List<String>{
    'Id', 'Name', 'Email', 'Username', 'Profile', 'IsActive',
    'CreatedDate', 'LastLoginDate', 'DaysIdle', 'Category'
};

List<String> csvRows = new List<String>{ String.join(HEADERS, ',') };
List<String> logLines = new List<String>();
Map<String, Integer> byProfile = new Map<String, Integer>();
Integer neverLoggedIn = 0;

for (User u : staleUsers) {
    Boolean isNever   = (u.LastLoginDate == null);
    Datetime baseline = isNever ? u.CreatedDate : u.LastLoginDate;
    Integer daysIdle  = baseline.date().daysBetween(Date.today());
    String  category  = isNever ? 'NEVER_LOGGED_IN' : 'STALE_LOGIN';
    String  profile   = (u.Profile != null) ? u.Profile.Name : '';

    if (isNever) { neverLoggedIn++; }
    byProfile.put(profile, (byProfile.containsKey(profile) ? byProfile.get(profile) : 0) + 1);

    List<String> cells = new List<String>{
        u.Id,
        u.Name,
        u.Email,
        u.Username,
        profile,
        String.valueOf(u.IsActive),
        u.CreatedDate.format('yyyy-MM-dd HH:mm:ss'),
        isNever ? 'NEVER' : u.LastLoginDate.format('yyyy-MM-dd HH:mm:ss'),
        String.valueOf(daysIdle),
        category
    };

    // RFC 4180 escaping: quote everything, double any embedded quote.
    List<String> escaped = new List<String>();
    for (String c : cells) {
        escaped.add('"' + (c == null ? '' : c).replace('"', '""') + '"');
    }
    csvRows.add(String.join(escaped, ','));

    logLines.add(
        (isNever ? 'NEVER ' : 'STALE ') +
        String.valueOf(daysIdle).leftPad(5) + 'd | ' +
        u.Username + ' | ' + profile + ' | ' + u.Email
    );
}

// ---------------------------------------------------------------- SUMMARY ---
System.debug(LoggingLevel.ERROR, '===== INACTIVE USER AUDIT =====');
System.debug(LoggingLevel.ERROR, 'Threshold      : ' + INACTIVE_DAYS + ' days (cutoff ' + cutoff.format('yyyy-MM-dd HH:mm:ss') + ')');
System.debug(LoggingLevel.ERROR, 'Scope          : active users' + (STANDARD_ONLY ? ', UserType = Standard' : ', all user types'));
System.debug(LoggingLevel.ERROR, 'Total matching : ' + totalMatches);
System.debug(LoggingLevel.ERROR, 'Exported       : ' + staleUsers.size());
System.debug(LoggingLevel.ERROR, '  never logged in : ' + neverLoggedIn);
System.debug(LoggingLevel.ERROR, '  stale login     : ' + (staleUsers.size() - neverLoggedIn));
System.debug(LoggingLevel.ERROR, 'By profile     : ' + byProfile);
System.debug(LoggingLevel.ERROR, 'SOQL rows used : ' + Limits.getQueryRows() + '/' + Limits.getLimitQueryRows());

if (totalMatches > staleUsers.size()) {
    System.debug(LoggingLevel.ERROR,
        '*** TRUNCATED: ' + (totalMatches - staleUsers.size()) + ' rows not exported. ' +
        'Raise MAX_ROWS or move to Batch Apex. ***');
}

// ----------------------------------------------------------------- OUTPUT ---
if (staleUsers.isEmpty()) {
    System.debug(LoggingLevel.ERROR, 'No inactive users found.');

} else if (OUTPUT_MODE == 'LOG') {
    // Chunked so each debug statement stays well under the log line limit.
    final Integer CHUNK = 40;
    for (Integer i = 0; i < logLines.size(); i += CHUNK) {
        List<String> slice = new List<String>();
        for (Integer j = i; j < Math.min(i + CHUNK, logLines.size()); j++) {
            slice.add(logLines[j]);
        }
        System.debug(LoggingLevel.ERROR, '\n' + String.join(slice, '\n'));
    }

} else {
    // Leading U+FEFF (65279) BOM so Excel opens the CSV as UTF-8, not ANSI.
    String bom = String.fromCharArray(new List<Integer>{ 65279 });
    Blob csv = Blob.valueOf(bom + String.join(csvRows, '\n'));
    String fileName = 'inactive-users-' + INACTIVE_DAYS + 'd-' +
                      Datetime.now().format('yyyyMMdd_HHmm') + '.csv';

    if (OUTPUT_MODE == 'EMAIL') {
        Messaging.EmailFileAttachment att = new Messaging.EmailFileAttachment();
        att.setFileName(fileName);
        att.setContentType('text/csv');
        att.setBody(csv);

        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setToAddresses(new List<String>{ EMAIL_TO });
        msg.setSubject('Inactive User Audit - ' + staleUsers.size() + ' user(s) idle ' + INACTIVE_DAYS + '+ days');
        msg.setPlainTextBody(
            'Active users with no login in the last ' + INACTIVE_DAYS + ' days.\n' +
            'Total matching: ' + totalMatches + '\n' +
            'Attached rows : ' + staleUsers.size() + '\n' +
            'Never logged in: ' + neverLoggedIn
        );
        msg.setFileAttachments(new List<Messaging.EmailFileAttachment>{ att });
        msg.setSaveAsActivity(false);

        Messaging.SendEmailResult[] res = Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{ msg }, false);
        System.debug(LoggingLevel.ERROR, res[0].isSuccess()
            ? 'Emailed ' + fileName + ' to ' + EMAIL_TO
            : 'Email FAILED: ' + res[0].getErrors());

    } else if (OUTPUT_MODE == 'FILE') {
        ContentVersion cv = new ContentVersion(
            Title          = fileName,
            PathOnClient   = fileName,
            VersionData    = csv,
            IsMajorVersion = true
        );
        insert cv;
        System.debug(LoggingLevel.ERROR,
            'Saved to Files (Salesforce -> Files -> Owned by Me). ContentVersion Id: ' + cv.Id);

    } else {
        System.debug(LoggingLevel.ERROR, 'Unknown OUTPUT_MODE: ' + OUTPUT_MODE);
    }
}

/*
 * -----------------------------------------------------------------------------
 * NOTES / LIMITS
 * -----------------------------------------------------------------------------
 * - Heap: anonymous Apex gets 6 MB. Each CSV row is ~300 bytes, so ~5,000 rows
 *   is a safe ceiling. Above that, port this to a Batch Apex class
 *   (Database.Batchable<sObject> with the same query string) and email the CSV
 *   from finish().
 *
 * - LastLoginDate updates on UI, API and mobile logins, but NOT on session
 *   resumption. For login-channel or IP detail, query LoginHistory instead --
 *   it retains only the last 6 months.
 *
 * - Datetime.format() renders in the RUNNING USER's timezone. Swap to
 *   formatGmt('yyyy-MM-dd HH:mm:ss') if the export must be timezone-neutral.
 *
 * - Deactivating the results is a separate, deliberate step. If you add it,
 *   exclude yourself (UserInfo.getUserId()), integration users, and anyone who
 *   owns records or sits in an approval hierarchy -- deactivation fails on
 *   users who are the sole recipient of an active approval request.
 * -----------------------------------------------------------------------------
 */
