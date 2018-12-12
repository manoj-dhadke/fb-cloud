# Flint arguments

$sr_request_id=$args[0]
$title=$args[1]
$description=$args[2]

# Flint API Key

$apiKey = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJvcmNoZXN0cmF0aW9uX3NlcnZlcl9kZXRhaWxzIjoie1widGVuYW50LWRvbWFpblwiOlwiY2xvdWRpZnlhc2lhXCIsXCJ0ZW5hbnQtaWRcIjo1LFwiZGVzY3JpcHRpb25cIjpcIkZsaW50IE9yY2hlc3RyYXRpb24gU2VydmVyXCIsXCJuYW1lXCI6XCJPU1ItS0xcIixcImlkZW50aWZpZXJcIjpcIk9TUi0yXCIsXCJ1c2VybmFtZVwiOlwiNDkzMTMyZDktZTM0MS00MjcyLTg0NTAtZGQ2OWM3ZWZlZDNhXCJ9IiwiaXNzIjoiZmxpbnQifQ.n0G7CA9wrW5X6xhBghI52ESSf6K3hO-wykphRirDfow"
$resource = "https://cloudifyasia.flintcloud.io/api/v1/orchestrationserver/493132d9-e341-4272-8450-dd69c7efed3a/run/fb-cloud:azure-stack:operation:create_azurestack_vm_scsm_wrapper_oldasdk.groovy"
$body = @{
    sr_request_id = $sr_request_id
    title = $title
    description = $description
}
Invoke-RestMethod -Method Post -Uri $resource -Body (ConvertTo-Json $body) -Headers @{"flint-security-key"=$apiKey}

