Set-Location C:\
Clear-Host

#We need the cmdlets
Install-Module AzureADPreview -AllowClobber -Verbose -Force

#Import the Module
Import-Module AzureADPreview

#Connect to Azure
Connect-AzureAD

#Retrieve the current group settings for your Azure AD organization
$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | Where-Object -Property DisplayName -Value "Group.Unified" -EQ).id
<#
 If no group settings have been created for your Azure AD organization, you will get an error that reads “Cannot bind argument to parameter ‘Id’ 
 because it is null”. In this case, you’ll need to first create the settings. You can configure group settings using PowerShell
#>

#If you don't get an error message go to the end of this script, otherwise follow the next steps.

#Create settings at the directory level
#Directory Settings cmdlets, you must specify the ID of the SettingsTemplate you want to use
Get-AzureADDirectorySettingTemplate

#To add a usage guideline URL, first you need to get the SettingsTemplate object that defines the usage guideline URL value; that is, the Group.Unified template
$TemplateId = (Get-AzureADDirectorySettingTemplate | Where-Object { $_.DisplayName -eq "Group.Unified" }).Id

$Template = Get-AzureADDirectorySettingTemplate | Where-Object -Property Id -Value $TemplateId -EQ

#Next, create a new settings object based on that template
$Setting = $Template.CreateDirectorySetting()

#Then update the settings object with a new value
$Setting["UsageGuidelinesUrl"] = "https://guideline.tomrocks.ch"
$Setting["EnableMIPLabels"] = "True"

#Then apply the setting
New-AzureADDirectorySetting -DirectorySetting $Setting

#You can read the values using
$Setting.Values

#If you want to Update the directory level settings

#Update settings at the directory level
$Setting = Get-AzureADDirectorySetting | Where-Object { $_.DisplayName -eq "Group.Unified"}

#Check the current settings
$Setting.Values

#To remove the value of UsageGuideLinesUrl
$Setting["UsageGuidelinesUrl"] = ""

#Save update to the directory:
Set-AzureADDirectorySetting -Id $Setting.Id -DirectorySetting $Setting

#Check the current settings
$Setting.Values


####
#If you do not get an error message go through the following steps!
####

#Retrieve the current group settings for your Azure AD organization
$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id

#Check the current settings
$Setting.Values

#Enable the feature
$Setting["EnableMIPLabels"] = "True"

#Finally, save the changes and apply the settings
Set-AzureADDirectorySetting -Id $Setting.Id -DirectorySetting $Setting

#Check the current settings
$Setting.Values

#Synchronize your sensitivity labels to Azure Active Directory 

#We need the cmdlets
Install-Module ExchangeOnlineManagement -Verbose -AllowClobber -Force

#Import the module
Import-Module ExchangeOnlineManagement

#Let's connect
Connect-IPPSSession

#Did it work?
Get-DlpSensitiveInformationType

#Next, run the following command to ensure your sensitivity labels can be used with Microsoft 365 groups
Execute-AzureAdLabelSync

#Disconnect
Disconnect-AzureAD
Disconnect-ExchangeOnline
