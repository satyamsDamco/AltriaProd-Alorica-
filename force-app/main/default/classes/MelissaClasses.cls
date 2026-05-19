public class MelissaClasses{ 

     
    /*Response class for Zip lookup API*/
         public class zipLookupResponse{
            public String Version;
            public String ResultCode;
            public String ErrorString;
            public List<AddressOuterClass> Results;
            
            public zipLookupResponse(){
                Results  = new List<AddressOuterClass>(); 
            }
        }
        
        public class AddressOuterClass{
            public AddressInnerClass Address;
            
            public AddressOuterClass(){
                Address = new AddressInnerClass();
            }
        }    
       
        public class AddressInnerClass{
            public String City;
            public String State;
            public String PostalCode;    
        }
    /*Response class for Zip lookup API end here*/
    
    
    /*Request class for Address Verification API*/
    
        public class consumerAddressRequest{
            public String AddressLine1;
            public String AddressLine2;
            public String AddressLine3;
            public String City;
            public String State;
            public String PostalCode;
            public String Country;

        }    
    
    /*Request class for Address Verification API end here*/
    
    
    /*Response class for Address Verification API*/    
        
        public class consumerAddressInnerResponse{
            public string ResultCode;
            public string Message;
            
            public consumerAddressInnerResponse(String ResultCodeVal, String MessageVal){
                ResultCode = ResultCodeVal;
                Message = MessageVal;
            }            
        }         
        
        public class consumerData{
            public List<consumerAddressResponse> Records;
            
            public consumerData(){
                Records = new List<consumerAddressResponse>();
            }
        }
        
        public class consumerAddressResponse{
            public String AddressLine1;
            public String AddressLine2;
            public String City;
            public String State;
            public String PostalCode;
            public string Results;
        }
        
        public class consumerFullAddressInnerResponse{
            public List<consumerAddressInnerResponse> consumerAddressInner;
            public consumerAddressResponse consumerAddress;
            public string status;
            public consumerFullAddressInnerResponse(consumerAddressResponse consumerAddressObj, List<consumerAddressInnerResponse> consumerAddressInnerObj,string statusObj){
                consumerAddressInner = new List<consumerAddressInnerResponse>();
                consumerAddress = new consumerAddressResponse();
                
                consumerAddressInner = consumerAddressInnerObj;
                consumerAddress = consumerAddressObj;
                status = statusObj;
            }            
        }
        
    /*Response class for Address Verification API*/
}