trigger NewLineCharCase on Case (before insert, before update) {
    if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert)){
        NewLineCharHelper helperObj = new NewLineCharHelper();
        //helperObj.newlineCase(trigger.new);
        //New Changes as per RITM3562938 and RITM3595316
        helperObj.newlineCase(Trigger.new, Trigger.isInsert, Trigger.isUpdate, Trigger.oldMap);

    }

}