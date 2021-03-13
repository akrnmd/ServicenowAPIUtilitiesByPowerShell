# https://arm-lab.blogspot.com/2021/03/servicenowpowershell.html
# Parameters
$user = "admin"
$pass = "admin"
$instansname = "dev00000"
$SysID = "8180046a2fba601033e449e72799b680"
$BasePath = "C:\"

# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','*/*')

# Specify endpoint uri
$MetaUri = "https://$instansname.service-now.com/api/now/attachment/$SysID"
$FileUri = "https://$instansname.service-now.com/api/now/attachment/$SysID/file"

# Send HTTP request Get FileName from MetaData
$response = Invoke-RestMethod -Headers $headers -Method "GET" -Uri $MetaUri
$FileFullPath = $BasePath + $response.result.file_name

# Send HTTP request GetFile
Invoke-RestMethod -Headers $headers -Method "GET" -Uri $FileUri -OutFile $FileFullPath
