/*
*   @Author: Gian Carlo Cutchon
*   @Date: 12/12/2018
*   @Apex Name: LexisNexisResponseClass
*   @Description: This class is use to handle the response from LexisNexis Callout.
*
*/
public class LexisNexisResponseClass{
    
    //Age Verification  send request to LexisNexis
    public class AgeVerificationRequest{
        public jsonWrapper_Settings Settings;
        public jsonWrapper_Person Person;
    }
    
    public class jsonWrapper_Settings{
        public string Mode;
        public string Reference;
        public string Locale;
        public string Venue;
    }
    
    public class jsonWrapper_Person{
        public jsonWrapper_Name Name;
        public List<jsonWrapper_Addresses> Addresses;
        public jsonWrapper_DOB DateOfBirth;
    }
    
    public class jsonWrapper_Name{
        public string FirstName;
        public string LastName;
    }
    
    public class jsonWrapper_Addresses{
        public string StreetAddress1;
        public string StreetAddress2;
        public string City;
        public string State;
        public string Zip5;
        public string Country;
        public string Context;
    }
    
    public class jsonWrapper_DOB{
        public Integer Year;
        public Integer Month;
        public Integer Day;
    }
    //End
    
    //Age Verification response from LexisNexis
    public class AgeVerificationResponse{
        public jsonWrapper_Status Status;
    }
    
    public class jsonWrapper_Status{
        public string ConversationId;
        public string RequestId;
        public string TransactionStatus;
        public jsonWrapper_TransactionReasonCode TransactionReasonCode;
        public string Reference;
        public string LexID;
    }
    
    public class jsonWrapper_TransactionReasonCode{
        public string Code;
    }
    //End
}