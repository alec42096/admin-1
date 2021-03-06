#
# Creates a local user and run as script
#    Creates a user and then runs either a script or sub process as that same user
#
# TODO:
#   *Add functionality to capture and reset winrm settings
#   *Add functionality to reinstate the firewall if it was unconfigured before
#   *Add functionality to use SSL and to generate the certificates needed to verify and
#       secure these.
#   *Add option to pull the script to run from a ROS location.
#
#######################################################################################


# set the computername to the local name of the server unless another name is specified
$comp = if ( ${env:COMPUTER}.Length -gt 0 ) { ${env:COMPUTER} } else { $env:COMPUTERNAME }

# Turn on the basics of remoting
Enable-PSRemoting -force

# Now we need to set a few settings to allow the remote session to connect.
# We may need to explicitly use strings for winrm arguments. This script could be improved to
# fetch, retain and reset the various changes made for security such as firewall changes.
$argsString = "@{TrustedHosts = `"$comp`"}"
winrm set winrm/config/client $argsString
winrm set winrm/config/service '@{AllowUnencrypted = "true"}'

$sec_pass =  convertto-securestring -asplaintext -string ${env:PASSWORD} -force

$cred = new-object System.Management.Automation.PSCredential( ${env:USERNAME}, ${sec_pass})
invoke-command -Computername $comp -ScriptBlock {whoami} -Credential $cred

# This is the barest of efforts to re-disable powershell remoting. There are other functions
# that would make this more secure.
Disable-PSRemoting -force -WarningAction SilentlyContinue