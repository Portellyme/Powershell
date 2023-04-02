# Security identifiers
The security identifier (SID) is an account identifier.  
It is variable in length and encapsulates the hierarchical notion of issuer and identifier. It consists of a 6- byte identifier authority field that is followed by one to fourteen 32-bit subauthority values and ends in a single 32-bit relative identifier (RID). 

The following diagram shows an example of a two-subauthority SID
![SID with subauthorities](images/Windows-SID-with-subauthorities.png?raw=true)

## SID Allocation
Whenever a new issuing authority under Windows is created, (for example, a new machine deployed or a domain is created), it is assigned a SID with an arbitrary value of 5 as the identifier authority. A fixed value of 21 is used as a unique value to root this set of subauthorities, and a 96-bit random number is created and parceled out to the three subauthorities with each subauthority that receives a 32-bit chunk. When the new issuing authority for which this SID was created is a domain, this SID is known as a "domain SID".

### Reserved RIDs
Windows allocates RIDs starting at 1,000; RIDs that have a value of less than 1,000 are considered reserved and are used for special accounts. For example, all Windows accounts with a RID of 500 are considered built-in administrator accounts in their respective issuing authorities.
A SID that is associated with an account appears as shown in the following figure.
![SID with account association](images/SID-with-account-association.png?raw=true)


___

## Security identifier structure
SID Standard notation : `S-R-X-Y1-Y2-Yn-1-Yn`

| Comment | Description |
| --- | --- |
| S | Indicates that the string is a SID |
| R | Indicates the revision level |
| X | Indicates the identifier authority value. <br/>For example, the identifier authority value in the SID for the Everyone group is 1 (World Authority). <br/>The identifier authority value in the SID for a specific Windows Server account or group is 5 (NT Authority) |
| Y | Represents a series of subauthority values, where *n* is the number of values |


### Examples

| | SID with four components | SID for Contoso\Domain Admins | Creator Group ID |
| --- | --- | --- | --- |
| SID | `S-1-5-32-544` | `S-1-5-21-1004336348-1177238915-682003330-512` | `S-1-3-1`
| Revision level | 1 | (1) | 1 |
| Identifier Authority value | 5 <br/> NT_AUTHORITY | 5 <br/> NT_AUTHORITY | 3 <br/> CREATOR_SID_AUTHORITY
| Relative Identifier <br/> First subauthority | 32 <br/> Builtin | 21 <br/> SECURITY_NT_NON_UNIQUE | 1 <br/> CREATOR_GROUP
| Additional Sub Authorities |  | 1004336348-1177238915-682003330 |  |
| Relative Identifier | 544 <br/> BUILTIN_ADMINISTRATORS | 512 <br/> DOMAIN_ADMINS |  |


> **Note:** The first subauthority 21 (SECURITY_NT_NON_UNIQUE) serves as the base portion of the SID for all domain accounts and for all non-alias local accounts. The SID is uniquely identified by 3 additional sub-authority followed then by a RID.  
> For example, the domain global group "Domain Users" has the SID value "S-1-5-21-a-b-c-513", where "S-1-5-21-a-b-c" is the domain SID and "513" is the RID portion of the SID.



### Sources
- [Understand Security Identifiers (Git)](https://github.com/MicrosoftDocs/windowsserverdocs/blob/main/WindowsServerDocs/identity/ad-ds/manage/understand-security-identifiers.md)
- [Understand Security Identifiers (Web)](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers)

- [Well known SID (Web)](https://learn.microsoft.com/en-us/windows/win32/secauthz/well-known-sids)

- [Well-Known SID Structures (Windows Protocols)](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp/81d92bba-d22b-4a8c-908a-554ab29148ab)
- [Domain RID Values (Windows Protocols)](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/b9475e91-f00f-4c25-9117-a48e70584625)

#### MS Open Specifications Windows Protocols
- [Windows Protocols](https://learn.microsoft.com/en-us/openspecs/windows_protocols/MS-WINPROTLP)
- [[MS-AZOD]: Authorization Protocols Overview](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-azod)
- [[MS-DTYP]: Windows Data Types](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-dtyp)
- [[MS-ADTS]: Active Directory Technical Specification](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-adts)







