# Create a byte array containing random values and save it to the file system.
$NewArray = New-Object -TypeName byte[](32)
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($NewArray)
$ArrayFilePath = "C:\Users\USERNAME\Desktop\Bytes"
Set-Content -Path $ArrayFilePath -Value $NewArray

# Get the contents of the previously saved file and create a new byte array with it.
$ArrayFileContent = Get-Content -Path $ArrayFilePath
$RecoveredArray = New-Object -TypeName byte[]($ArrayFileContent.Count)
for($i = 0; $i -lt $ArrayFileContent.Count; $i++){$RecoveredArray.Set($i, $ArrayFileContent.GetValue($i))}
Write-Output -InputObject $RecoveredArray

# Create a secure string and encipher it with the previously recovered byte array before saving it to the file system.
$NewString = ConvertTo-SecureString "My phrase" -AsPlainText -Force
$StoreString = ConvertFrom-SecureString -SecureString $NewString -Key $RecoveredArray
$StoreFilePath = "C:\Users\USERNAME\Desktop\Store"
Set-Content -Path $StoreFilePath -Value $StoreString

# Get the contents of the previously saved file.
$RecoveredStore = Get-Content -Path $StoreFilePath
Write-Output -InputObject $RecoveredStore

# Create a secure string using the recovered string and byte array before creating a credential.
$RecoveredString = ConvertTo-SecureString -String $RecoveredStore -Key $RecoveredArray
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "My name", $RecoveredString

Write-Output $Credential.GetNetworkCredential().UserName
Write-Output $Credential.GetNetworkCredential().Password
