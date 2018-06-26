# Flint arguments

$sr_request_id=$args[0]
$title=$args[1]
$description=$args[2]

# Flint API Key

$apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJvcmNoZXN0cmF0aW9uX3NlcnZlcl9kZXRhaWxzIjoie1widGVuYW50LWRvbWFpblwiOlwiY2xvdWRpZnlhc2lhXCIsXCJ0ZW5hbnQtaWRcIjo1LFwiZGVzY3JpcHRpb25cIjpcIkZsaW50IE9yY2hlc3RyYXRpb24gc2VydmVyIEtMLTFcIixcIm5hbWVcIjpcIk9TUi1LTC0xXCIsXCJpZGVudGlmaWVyXCI6XCJPU1ItM1wiLFwidXNlcm5hbWVcIjpcImUwMDJkOTc0LTgyYmMtNGUwYi1hMDA0LTBmMDg0MDRlYjY3YVwifSIsImlzcyI6ImZsaW50In0.EydRvd72pSk-3y0-lpuKTKsgH0U6V5qjPR48JmdY1zQ"
$resource = "https://cloudifyasia.flintcloud.io/api/v1/orchestrationserver/e002d974-82bc-4e0b-a004-0f08404eb67a/run/fb-cloud:azure-stack:operation:create_azurestack_vm_scsm_wrapper.groovy"
$body = @{
    sr_request_id = $sr_request_id
    title = $title
    description = $description
}
Invoke-RestMethod -Method Post -Uri $resource -Body (ConvertTo-Json $body) -Headers @{"flint-security-key"=$apiKey}
