# Params @ Local
$CSVFileName = "xxxx.csv"
$CSVFilePath = "C:\"

# Params @ SNOW
$InstanceName = "dev00000"
$User = "admin"
$Pass = "admin"
$ImportTableName = 'u_inport_incident_by_csv'

# Merge Params
$URI = "https://$InstanceName.service-now.com/sys_import.do?sysparm_import_set_tablename=$ImportTableName&sysparm_transform_after_load=true"
$CSVFileFullPath = $CSVFilePath + $CSVFileName

# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $User, $Pass)))
$Headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$Headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$Headers.Add('Accept','application/json')

# Read CSV File
$FileBytes = [System.IO.File]::ReadAllBytes($CSVFileFullPath)
$FileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($FileBytes)

# Set Boundary
$Boundary = [System.Guid]::NewGuid().ToString()
$LF = "`r`n"

# Make Body
$BodyLines = (
    "--$Boundary",
    "Content-Disposition: form-data; name=`"csvfile`"; filename=`"$CSVFileName`"",
    "Content-Type: text/csv$LF",
    $FileEnc,
    "--$Boundary--$LF"
) -join $LF

# Post File
try {
    Invoke-Restmethod -Method POST -Headers $Headers -ContentType "multipart/form-data; boundary=`"$Boundary`"" -Uri $URI -Body $BodyLines -ErrorAction Stop
} catch {
    $_
    throw "Unable to import Data"
}
