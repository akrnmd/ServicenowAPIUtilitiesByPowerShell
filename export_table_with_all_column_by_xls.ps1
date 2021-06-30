# https://arm-lab.blogspot.com/2021/03/powershellservicenowapi.html
# Parameters
# Example
# $user = "admin"
# $pass = "admin"
# $instansname = "dev00000"
# $targettablename = "incident"
# $baselocalpath = "C:\snowapi\"
# $outfilename = "incident.xls"
$user = "admin"
$pass = "admin"
$instansname = "dev0000"
$targettablename = "table_name"
$baselocalpath = "C:\"
$outfilename = "table_name.xls"

# Build auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

# Set proper headers
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
$headers.Add('Accept','application/json')

# Set fullpath of outfile
$fullpathofoutfile = $baselocalpath + $outfilename

# Specify endpoint uri
# If you need export with filtered data, use next example.
# $uri = "https://" + $instansname + ".service-now.com/incident_list.do?XLS&sysparm_query=priority=1&sysparm_default_export_fields=all"
$uri = "https://" + $instansname + ".service-now.com/" + $targettablename + "_list.do?XLS&sysparm_default_export_fields=all"

# Specify HTTP method
$method = "GET"

# Send HTTP request
Invoke-RestMethod -Headers $headers -Method $method -Uri $uri -OutFile $fullpathofoutfile
