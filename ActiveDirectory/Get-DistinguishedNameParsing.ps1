<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2021 v5.8.195
	 Created on:   	22/10/2021 09:09
	 Created by:   	Portelly
	 Organization: 	Portelly
	 Filename:     	Get-DistinguishedNameParsing.ps1
	===========================================================================
	.DESCRIPTION
		Parsing organizational unit names from a distinguished name.
	

	.LINK
		https://jdhitsolutions.com/blog/powershell/7817/distinguished-parsing-with-powershell-and-regex/

#>


######################
#region Function Declaration 
######################


#endregion


#######################
#region Classes
#######################



#endregion


######################
#region Global Declaration 
######################
$DN = @("OU=Foo,OU=Top,DC=Company,DC=pri",
	"OU=Foo123,OU=FooBar,DC=Company,DC=pri",
	"ou=Foo,ou=Top,dc=Company,dc=pri",
	"OU=Gladys Kravitz Monitors,OU=Top,DC=Company,DC=pri",
	"OU=A723-Test,OU=Top,OU=Middle,DC=Company,DC=pri",
	"OU=JEA_Operators,DC=Company,DC=Pri",
	"CN=Users,DC=Company,DC=pri",
	"CN=ArtD,OU=IT,DC=Company,DC=Pri",
	"cn=johnd,ou=sales,dc=company,dc=pri",
	"CN=SamS,OU=This,OU=That,DC=Company,DC=Pri",
	"OU=Domain Controllers,DC=Company,DC=Pri"
)


#endregion 


##############################
# region Main
##############################

#Greed

[regex]$rx = "^(ou|OU)=.*(?=,)"
$rx.Match($dn[1])
<#
Groups   : {0, 1}                                
Success  : True                                  
Name     : 0                                     
Captures : {0}                                   
Index    : 0                                     
Length   : 30                                    
Value    : OU=Foo123,OU=FooBar,DC=Company        
#>


[regex]$rx = "^(ou|OU)=.*?(?=,)"
#The main difference is the "?" inserted after ."*". This makes the pattern stop after the first match.*
$rx.Match($dn[1])
<#
Groups   : {0, 1}        
Success  : True          
Name     : 0             
Captures : {0}           
Index    : 0             
Length   : 9             
Value    : OU=Foo123     
#>

#$DN | ForEach-Object { $rx.Match($_) } | Select-Object -ExpandProperty Value

#Only get value if there is a match
$DN | Where-Object { $rx.IsMatch($_) } | ForEach-Object { $rx.Match($_) } | Select-Object -ExpandProperty Value

<#
OU=Foo                             
OU=Foo123                          
ou=Foo                             
OU=Gladys Kravitz Monitors         
OU=A723-Test                       
OU=JEA_Operators   
OU=Domain Controllers
#>

[regex]$rx = "^(ou|OU)=(?<OUName>.*?(?=,))"
$dn | Where-Object { $rx.IsMatch($_) } | ForEach-Object { $rx.Match($_).groups["OUName"].Value }
<#
Foo                                    
Foo123                                 
Foo                                    
Gladys Kravitz Monitors                
A723-Test                              
JEA_Operators                          
Domain Controllers                     

#>

$rx.Match($DN[1]).Groups
#"OU=Foo123,OU=FooBar,DC=Company,DC=pri"
<#
Groups   : {0, 1, OUName}                     
Success  : True                               
Name     : 0                                  
Captures : {0}                                
Index    : 0                                  
Length   : 9                                  
Value    : OU=Foo123                          
                                              
Success  : True                               
Name     : 1                                  
Captures : {1}                                
Index    : 0                                  
Length   : 2                                  
Value    : OU                                 
                                              
Success  : True                               
Name     : OUName                             
Captures : {OUName}                           
Index    : 3                                  
Length   : 6                                  
Value    : Foo123                             

#>

#Get Top OU Name
$dn | Where-Object { $rx.IsMatch($_) } | ForEach-Object { $rx.Match($_).groups["OUName"].Value }

<#
                                 
Foo                              
Foo123                           
Foo                              
Gladys Kravitz Monitors          
A723-Test                        
JEA_Operators                    
Domain Controllers               

#>


##############################
# parse also Cname
##############################
#Too much load on the ignore case 
#$rx = [System.Text.RegularExpressions.Regex]::new("^(((CN=.*?))?)OU=(?<OUName>.*?(?=,))", "IgnoreCase")
#$dn | Where-Object { $rx.IsMatch($_) } | ForEach-Object { $rx.Match($_).groups["OUName"].Value }


##############################
# parse Better
##############################
$rx = [System.Text.RegularExpressions.Regex]::new("^(?:(?<Cn>CN=(?<CnName>.*?)),)?(?<Ouparent>(?:(?<Oupath>(?:CN|OU).*?),)?(?<Domain>(?:DC=.*)+))$")
$dn | Where-Object { $rx.IsMatch($_) } | ForEach-Object {
	
	$rx.Match($_).groups["Ouparent"].Value
	#Can be splitted easily 
	$split = ($rx.Match($_).groups["Oupath"].Value).Replace('OU=', '').split(',')
	$split
}










#endregion 


