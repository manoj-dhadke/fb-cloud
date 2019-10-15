/**
** Creation Date: 11th Oct 2019
** Summary: Create Azure instance flintbit.
** Description: This flintbit is developed to create an Azure instance.
**/

log.trace("Started executing 'fb-cloud:azure:operation:workflow:azure_create_instance_wf.js' flintbit...")
log.info("Input:: " + input)
input_clone = JSON.parse(input)
connector_name = "msazure"
//Input from JSON Params
azure_service_parameters = input.get('azure_service_parameters')
if (typeof azure_service_parameters == "string") {
    log.trace("Template is given as a JSON string. Coverting to JSON object")
    azure_service_parameters = util.json(azure_service_parameters)
} else if (typeof azure_service_parameters == "object") {
    log.trace("Template JSON is given")
}
instance_name= input.get('instance_name')
region= azure_service_parameters.get('region')
resource_group= azure_service_parameters.get('resource_group')
network_name= azure_service_parameters.get('network_name')
public_ip= instance_name+ '_ip'
subnet_id= azure_service_parameters.get('subnet_id')
username= azure_service_parameters.get('username')
password= azure_service_parameters.get('password')
size= azure_service_parameters.get('size')
image=""
os_type=""

//Fetching from Azure Connection 
key= input.get("cloud_connection.encryptedCredentials.key")
tenant_id= input.get("cloud_connection.encryptedCredentials.tenant_id")
subscription_id= input.get("cloud_connection.encryptedCredentials.subscription_id")
client_id= input.get("cloud_connection.encryptedCredentials.client_id")
        
//Input from Service Form
os_name = input.get('operating_system')
log.info("OS Name:: "+os_name)

// Getting OS Name
//os_type = azure_service_parameters.get('os_mapping').get(os_name)

if (os_name="Ubuntu 16.04 LTS"){
    image= azure_service_parameters.get("os_mapping").get('linux').get("Ubuntu 16.04 LTS")
    os_type=azure_service_parameters.get("os_mapping").get('linux').get("os_type")

}
else{
    image= azure_service_parameters.get("os_mapping").get('windows').get("Windows 2012")
    os_type=azure_service_parameters.get("os_mapping").get('windows').get("os_type")
}
log.trace("Valid OS Type is: " + os_type + " and Image Name is: "+image) 

log.trace(instance_name)
log.trace(region)
log.trace(resource_group)
log.trace(network_name)
log.trace(public_ip)
log.trace(subnet_id)
log.trace(username)
log.trace(password)
log.trace(size)
log.trace(image)
log.trace(os_type)
log.trace(key)
log.trace(tenant_id)
log.trace(subscription_id)
log.trace(client_id)

create_azure_instance_response= call.bit("fb-cloud:azure:operation:create_instance.groovy")
                                    .set("connector_name", connector_name)
                                    .set('tenant-id', tenant_id)
                                    .set('subscription-id', subscription_id)
                                    .set('client-id', client_id)
                                    .set('key', key)
                                    .set('instance-name', instance_name)
                                    .set('region', region)
                                    .set('resource-group', resource_group)
                                    .set('public-ip', public_ip)
                                    .set('subnet-id', subnet_id)
                                    .set('username', username)
                                    .set('password', password)
                                    .set('os-type', os_type)
                                    .set('size', size)
                                    .set('image', image)
                                    .set('network-name', network_name)
                                    .set('network-id', '1')
                                    .timeout(2800000)
                                    .sync()

log.trace("Called connector")
// Getting exit-code for create instance flinbit call
create_instance_exit_code = create_azure_instance_response.get("exit-code")
log.trace("Exit code: "+create_instance_exit_code)
log.info(create_azure_instance_response)

if(create_instance_exit_code == 0){
    log.trace("Instance created successfully with instance Name: " +instance_name + "and Size: " +size)
    output.set('Instance-Name', instance_name)
}
else{
    // Setting user message (will be visible on CMP)
    output.set('exit-code', -1).set('error', create_azure_instance_response)
}

log.trace("Finished executing 'fb-cloud:azure:operation:workflow:azure_create_instance_wf.js' flintbit.")