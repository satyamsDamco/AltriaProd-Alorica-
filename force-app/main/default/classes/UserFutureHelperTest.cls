/*
  Test Class for Trace Code
  11/23/2016 Infogain – Created.
   */

@isTest
public class UserFutureHelperTest
{
    //Method to create test users with unique name.
    public static User createTestUser(Id profID, String fName, String lName) {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User tuser = new User(  firstname = fName,
                                lastName = lName,
                                email = uniqueName + '@test' + orgId + '.org',
                                Username = uniqueName + '@test' + orgId + '.org',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profId
                                );
        return tuser;
    }

    // validate UserFutureHelper method 
    public static testmethod void UserFutureHelperMethodTest(){
        
        
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = createTestUser(p.Id,'Testing','Testing');

        System.runAs(u) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        
        /*Skip_Trigger_Validation_Rule__c tt = new Skip_Trigger_Validation_Rule__c();
        tt.Skip__c = true;
        tt.Name = 'test123';
        insert tt;*/
        
         User u1 = createTestUser(p.Id,'Testing1','Testing1');

        System.runAs(u1) {
            // The following code runs as user 'u' 
            System.debug('Current User: ' + UserInfo.getUserName());
            System.debug('Current Profile: ' + UserInfo.getProfileId()); 
        }
        
    }
    
}