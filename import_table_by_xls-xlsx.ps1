# https://arm-lab.blogspot.com/2021/03/powershellrest-apicsvservicenow.html
# Params @ Local
$XLSXFileName = "xxxx.xls/xlsx"
$XLSXFilePath = "C:\"

# Params @ SNOW
$InstanceName = "dev00000"
$User = "admin"
$Pass = "admin"
$ImportTableName = 'u_inport_incident_by_xls/xlsx'

# Merge Params
$URI = "https://$InstanceName.service-now.com/sys_import.do?sysparm_import_set_tablename=$ImportTableName&sysparm_transform_after_load=true"
$XLSXFileFullPath = $XLSXFilePath + $XLSXFileName

# Make Params Const
$CODEPAGE = "iso-8859-1"
$enc = [System.Text.Encoding]::GetEncoding($CODEPAGE)
$FileBin = [System.IO.File]::ReadAllBytes($XLSXFileFullPath)
$FileEnc = $enc.GetString($FileBin)

# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $Pass)))
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$Headers.Add('Accept','*/*')

# Boundary
  $Boundary = [System.Guid]::NewGuid().ToString()
	
# Linefeed character
  $LF = "`r`n"
  $BodyLines = (
      "--$Boundary",
      "Content-Disposition: form-data; name=`"file`"; filename=`"$XLSXFileName`"",
      "Content-Type: application/octet-stream$LF",
      $FileEnc,
      "--$Boundary--$LF"
   ) -join $LF

# Post File
try {
    Invoke-RestMethod -Uri $URI -Method POST -ContentType "multipart/form-data; boundary=`"$boundary`"" -Headers $Headers -Body $BodyLines -ErrorAction Stop
} catch {
    $_
    throw "Unable to import Data"
}
