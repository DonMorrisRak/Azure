# Metadata
$Headers = @{"Metadata-Flavor" = "Google";}
$metadata = Invoke-RestMethod -Uri "http://metadata.google.internal/computeMetadata/v1/instance/attributes/" -Headers $Headers

foreach ($i in $metadata.Split()) {
Invoke-RestMethod -Uri "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$i" -Headers $Headers
}



Get-Date | Select-Object -Property * | ConvertTo-Json

"Hello World" | ConvertFrom-String