/*
Zip-Age mapping implementation
07/25/2016 Infogain – Created.
*/

public class ageMapping{
    
    public class ageData{
        public boolean AgeVerify;
        public long ConsumerAge;
        public Decimal StateAge;
    }
    
    /* Method for Getting Zip, State, DOB and Calculate age mapping.*/
    Public ageData FetchDataZip(String IntZip,string entState, date DOB){
        List<Age_Mapping__c> QResults = new List<Age_Mapping__c>();
        ageData ageDataObj = new ageData();
        if(IntZip !=null){ // Condition if caller will provide Zip 
            QResults = [select Age__c from Age_Mapping__c where Active__c = true  AND Zip__c =: IntZip limit 1];
            system.debug('=================QResults========='+QResults);
            
        }
        if((QResults.isEmpty() || QResults.size() == 0) && entState!=null){ //Condition if caller will provide state not zip
            
            QResults = [select Age__c from Age_Mapping__c where Active__c = true AND Name =: entState limit 1];
            system.debug('=================QResults1========='+QResults);
        }
    
        System.debug('QResults'+QResults);  
        long age = ageCal(DOB); 
       // Condition to verify age provided by caller is greater than or equal to age fetched from databse.

        ageDataObj.ConsumerAge = age;
         
        
        if(QResults!= null && QResults.size() > 0){
            ageDataObj.StateAge = QResults[0].Age__c;
            if(age >= QResults[0].Age__c)
                ageDataObj.AgeVerify = true;
            else
                ageDataObj.AgeVerify = false;   
        }else
            ageDataObj.AgeVerify = false;
        
        return ageDataObj;    
    }
    
    // Age calculation on the basis of today's date and date of birth
    public long ageCal(date DOB){    
        long age;
        if(DOB != null){
            age = ((DOB.daysBetween(system.TODAY())/365.2425)).round(System.RoundingMode.FLOOR);  
            
        }
        system.debug ('age'+age);
        return age;
    }
}