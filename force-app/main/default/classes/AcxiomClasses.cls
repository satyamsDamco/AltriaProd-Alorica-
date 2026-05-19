//Acxiom Request and Response classes

Public class AcxiomClasses{

    public class TokenInfo{
        public string access_token;
        public string token_type;
        public string expires_in; 
    }
    
    public class ConsumerFinalResponse{
        public string RequestId;
        public string CCN;
        public string WinningCCN;
        public string intTransactionId;        
        public string OpCo;
        public string DateOfBirth;
        public string AVCode;
        public string AVOwner;
        public string Title;
        public string Fname;
        public string Lname;
        public string Addr1;
        public string Addr2;
        public string City;
        public string State;
        public string Zip;
        public string Zip4; 
        public string PID;
        public string ConsumerAuthCd;
        public string StatusCode;
        public string StatusMessage;
        public string ConsumerMessage;   
    }
    
    
    public class ConsumerFullSearchResponse{
        public List<AuthenticationData> AuthenticationData;
        public string RequestId;
        public List<StatusData> StatusData;
        public string CCN;
        public string WinningCCN;
        public QualificationData QualificationData;
        public ChannelData ChannelData;	
        
        public ConsumerFullSearchResponse(){
            AuthenticationData = new List<AuthenticationData>();
            StatusData = new List<StatusData>();
			QualificationData = new QualificationData();
            ChannelData = new ChannelData();

        }
    }
    
    public class StatusData{
        public string StatusCode;
        public string StatusMessage;
        public string ConsumerMessage;
    }
    
    
	public class QualificationData{
        public List<OpCoQualification> OpCoQualification;
        
        public QualificationData(){
            OpCoQualification = new List<OpCoQualification>();
        }
    }

    public class OpCoQualification{
        public string AVCode;
        public string AVOwner;
        public string ConsumerAuthCD;
       	public string OpCo;
        public string DateOfBirth;
    }
    
    public class ChannelData{
        public List<Channel> Channel;
        
        public ChannelData(){
            Channel = new List<Channel>();
        }
    }
    
    public class Channel{
        public List<ChannelLevel> ChannelLevel;
        
        public Channel(){
            ChannelLevel =  new List<ChannelLevel>();
        } 
    }
    
    public class ChannelLevel{
        public List<AddressType> AddressType;
        public ChannelLevel(){
            AddressType = new List<AddressType>();
        }
    }
       
    public class AddressType{
        public List<ContactInfo> ContactInfo;
        
        public AddressType(){
            ContactInfo = new List<ContactInfo>();
        }
    }    
     
    public class ContactInfo{
        public  string Name;
        public  string Value;
    }
    
    public class AuthenticationData{
        public string PID;
        public string ConsumerAuthCd;
    }
    
    public class CCNLookupFinalResponse{
        public string RequestId;
        public string CCN;
        public string WinningCCN;
        public string intTransactionId;        
        public string OpCo;
        public string DateOfBirth;
        public string AVCode;
        public string AVOwner;
        public string Title;
        public string Fname;
        public string Lname;
        public string Addr1;
        public string Addr2;
        public string City;
        public string State;
        public string Zip;
        public string Zip4; 
        public string PID;
        public string ConsumerAuthCD;
        public string StatusCode;
        public string StatusMessage;
        public string ConsumerMessage;
        public boolean showLocalData;   
    }
    
    public class CCNLookupResponse{
        public string RequestId;
        public List<StatusData> StatusData;
        public string WinningCCN;
        public string CCN;
       	public Individual Individual;
        public QualificationData QualificationData;
        public ChannelData ChannelData;
        
        public CCNLookupResponse(){
            StatusData = new List<StatusData>();
            Individual = new Individual();
            QualificationData = new QualificationData();
            ChannelData = new ChannelData();
        }
     }
     
    public class Individual{
    	public string PID;
    }   
}