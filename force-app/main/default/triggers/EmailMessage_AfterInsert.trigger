trigger EmailMessage_AfterInsert on EmailMessage (after insert) 
{
    
    for(EmailMessage message : trigger.new)
    {
    	if(message.Incoming == true)
    	{
    		Case myCase = [Select Id, Status from Case Where Id =: message.ParentId];
    		
    		myCase.Status = 'Email Pending';
    		
    		update myCase;
    	}
    }
}