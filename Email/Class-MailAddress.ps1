<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.194
	 Created on:   	29/09/2021 10:09
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Class-MailAddress
	===========================================================================
	.DESCRIPTION
		Class to test mail address and strong type 
#>


Class Email{
	#use to control and type email 
	[String]$Email
	
	Email([String]$emailAddress)
	{
		If ([string]::IsNullOrWhiteSpace($emailAddress))
		{
			Throw [System.Exception]::new("Email address is empty", [System.ArgumentException])
		}
		
		if ($this.TestEmail($emailAddress))
		{
			$this.Email = $emailAddress
		}
		else
		{
			Throw [System.Exception]::new("Email {$($emailAddress)} format is invalid")
		}
		
	}
	
	[bool] TestEmail([string]$addressToTest)
	{
		return $addressToTest -match "^(?("")("".+?""@)|(([0-9a-zA-Z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-zA-Z])@))(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,6}))$"
	}
}



$TestCase = @(
	"foobar@exampleserver",
	"jsmith@[192.168.2.1]", 
	"niceandsimple@example.com",
	"very.common@example.com", 
	"a.little.lengthy.but.fine@dept.example.com", 
	"disposable.style.email.with+symbol@example.com", 
	"other.email-with-dash@example.com", 
	"user-test-hyphens@example-domain.com",
	"" 
)

foreach ($test in $TestCase)
{
	$mailAddress = [Email]::new($test)
}
