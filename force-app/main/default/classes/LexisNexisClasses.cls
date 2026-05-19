Public class LexisNexisClasses{

    public class AgeVerificationRequest{
        public string Prefix;
        public string FirstName;
        public string MiddleName;
        public string LastName;   
        public string Suffix;             
        public string DOBYear;
        public string DOBMonth;
        public string DOBDay;  
        public string AddressLine1;
        public string AddressLine2;
        public string City;
        public string State;
        public string Zip;       
    }
    
    public class AgeVerificationResponse{
        public string Status;
        public string Message;
        
    }
}