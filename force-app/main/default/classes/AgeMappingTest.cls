/*
  Test Class for Brand Hierarchy Controller
   09/02/2016 Infogain – Created.
 */
 @isTest
 public class AgeMappingTest
 {
    //validate FetchDataZip method 
    //Apply asserts - Meena 
    public static testmethod void FetchDataZipTest()
    {
        list<Age_Mapping__c> lstAgeMapping = new list<Age_Mapping__c>();
        Age_Mapping__c ageMappingObj1 = TestDataSetup.createAgeMapping('NY', 18, '14219', true);
        lstAgeMapping.add(ageMappingObj1);
        Age_Mapping__c ageMappingObj2 = TestDataSetup.createAgeMapping('NY', 21, '12345', true);
        lstAgeMapping.add(ageMappingObj2);
        insert lstAgeMapping;
        ageMappingObj1.Zip__c ='12345';
        update ageMappingObj1;
        
        ageMapping age = new ageMapping();
        
        Date d = date.today().addYears(-50);
        Date d1 = date.today();
        
        age.FetchDataZip('14219','NY',d);
        
        age.FetchDataZip('14299','NY',d);
        
        age.FetchDataZip('14219','NY',d1);
        
        age.FetchDataZip('14299','NY',d1);
        
        age.FetchDataZip('14299','PA',d1);
    }
 }