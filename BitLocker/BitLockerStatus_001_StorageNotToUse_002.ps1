<#
      .SYNOPSIS
      Searches Active Directory for stored BitLocker recovery passwords
         
      .EXAMPLE
      Search for BitLocker recovery password for a single computer:
      .\BitLocker-Query.ps1 -computer computer001
    
      .EXAMPLE
      Search for BitLocker recovery passwords for all computers in an OU, active within 30 days:
      .\BitLocker-Query.ps1 -OU "myOU,dc=domain,dc=com" -activeDays 30

      .EXAMPLE
      Search for BitLocker recovery passwords for all computers in an OU, active within 30 days; only show results for online computers:
      .\BitLocker-Query.ps1 -OU "myOU,dc=domain,dc=com" -activeDays 30 | where { $_.Online -eq "Yes" } | ft -AutoSize

      .EXAMPLE
      Search for BitLocker recovery passwords for all computers in an OU, active within 30 days; only show results for computers with passwords stored:
      .\BitLocker-Query.ps1 -OU "myOU,dc=domain,dc=com" -activeDays 30 | where { ($_.Online -eq "Yes") -and ($_.BitLockerKey -ne "none") } | ft -AutoSize
    
  #>
  
  # source https://4sysops.com/archives/find-bitlocker-recovery-passwords-in-active-directory-with-powershell/
  
param(
    [parameter(ParameterSetName='pc')]
    [ValidateNotNull()]
    [string]$computer,
    [parameter(ParameterSetName='domain')]
    [ValidateNotNull()]
    [string]$ou,
    [int]$activeDays
)
$date = [datetime]::Now
$lastUsed = $date.AddDays(-$activeDays)
$computerObjs = @()
$padVal = 35
$pcNameLabel = "Computer Name".PadRight($padVal," ")
$dateLabel = "Computers Active Since".PadRight($padVal," ")
$ouLabel = "Computer Accounts".PadRight($padVal," ")
Write-Output "Searching Active Directory Computer Objects for stored BitLocker Recovery Passwords."
Write-Output "v0.1 Robert Pearman, November 2018"
Write-Output ""
if($computer)
{
    # Search PC Only
    Write-Output "$pcNameLabel : $computer"
    $obj = get-adcomputer $computer -properties *
}
if($ou)
{
    Write-Output "$ouLabel : $ou"
    Write-Output "$dateLabel : $lastUsed"
    # Search Domain
    $obj = get-adcomputer -filter {LastLogonDate -ge $lastUsed -and OperatingSystem -eq "Windows 10 Pro" } -Properties OperatingSystem -searchbase $ou
}
Write-Output ""
Write-Output "Searching.."
foreach ($pc in $obj)
{
    # build object
    $pcName = $pc.Name
    $pcObj = New-Object System.Object
    # store os, name, chasis
    # if offline look for key anyway
    $pcObj | Add-Member -Type NoteProperty -Name Name -Value $pcName
    $pcObj | Add-Member -Type NoteProperty -Name OS -Value $pc.OperatingSystem
    # online / offline
    try{
        $onLine = Test-Connection $pcName -Count 1 -ErrorAction Stop
        # mobile / desktop
        $pcObj | Add-Member -Type NoteProperty -Name Online -Value "Yes"
        try{
            $chasisType = (Get-WmiObject Win32_ComputerSystem -ComputerName $pcName -ErrorAction Stop).PCSystemType 
            if(($chasisType) -eq "2")
            {
                $pcObj | Add-Member -Type NoteProperty -Name Type -Value "Mobile"
            }
            else
            {
                $pcObj | Add-Member -Type NoteProperty -Name Type -Value "Desktop"
            }
        }
        catch{
            $pcObj | Add-Member -Type NoteProperty -Name Type -Value "-"
        }
    }
    catch{
        $pcObj | Add-Member -Type NoteProperty -Name Online -Value "No"
        $pcObj | Add-Member -Type NoteProperty -Name Type -Value "-"
    }
    # key stored
    $dn = $pc.DistinguishedName
    $ldPath = "AD:\",$dn -join ""
    $ldObj = Get-ChildItem $ldPath | where {$_.objectClass -eq "msFVE-RecoveryInformation" } | select -First 1
    if($ldObj)
    {
        $ldObj = "AD:\",$ldObj.DistinguishedName -join ""
        $btPass = Get-Item $ldObj -properties "msFVE-RecoveryPassword"
        if($btPass)
        {
            $pcObj | Add-Member -Type NoteProperty -Name BitLockerKey -Value $btPass.'msFVE-RecoveryPassword'
        }
    }
    else
    {
        # no key
        $pcObj | Add-Member -Type NoteProperty -Name BitLockerKey -Value "None"
    }
    $computerObjs += $pcObj
}
$computerObjs