trigger NewLineCharCase on Case (before insert, before update) {
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        // Date Code must always persist in UPPER CASE, whatever wrote the record - the Issue
        // Entry / Edit / Clone pages, a data load, the API, Flow or other Apex. Run first so
        // everything below sees the normalised value.
        helperObj.upperCaseDateCode(Trigger.new);
        //helperObj.newlineCase(trigger.new);
        //New Changes as per RITM3562938 and RITM3595316
        helperObj.newlineCase(Trigger.new, Trigger.isInsert, Trigger.isUpdate, Trigger.oldMap);

    }

}