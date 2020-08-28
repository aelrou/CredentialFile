# Get the contents of a previously saved file and create a new byte array with it.
$ArrayFilePath = "C:\Users\USERNAME\Desktop\Bytes"
$ArrayFileContent = Get-Content -Path $ArrayFilePath
$RecoveredArray = New-Object -TypeName byte[]($ArrayFileContent.Count)
for($i = 0; $i -lt $ArrayFileContent.Count; $i++){$RecoveredArray.Set($i, $ArrayFileContent.GetValue($i))}
Write-Output -InputObject $RecoveredArray

# Get the contents of a previously saved file.
$StoreFilePath = "C:\Users\USERNAME\Desktop\Store"
$RecoveredStore = Get-Content -Path $StoreFilePath
Write-Output -InputObject $RecoveredStore

# Create a secure string using the recovered string and byte array before creating a credential.
$RecoveredString = ConvertTo-SecureString -String $RecoveredStore -Key $RecoveredArray
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "My name", $RecoveredString

Write-Output $Credential.GetNetworkCredential().UserName
Write-Output $Credential.GetNetworkCredential().Password
