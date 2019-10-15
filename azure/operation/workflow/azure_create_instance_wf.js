

/**
** Creation Date: 11th Oct 2019
** Summary: Create Azure instance flintbit.
** Description: This flintbit is developed to create an Azure instance.
**/

log.trace("Started executing 'fb-cloud:azure:operation:azure_create_instance_wf.js' flintbit...")

log.info("Input:: " + input)

//Input from JSON Params
azure_service_params = input.get('azure_service_params')

name = azure_service_params.get('instance_name')

region = azure_service_params.get('region')

resource_group = azure_service_params.get('resource_group')

network_name = azure_service_params.get('network_name')

public_ip = name + '_ip'

subnet_id = azure_service_params.get('subnet_id')

username = azure_service_params.get('username')

password = azure_service_params.get('password')

size = azure_service_params.get('size')

image = azure_service_params.get('image')

//Fetching from Azure Connection 
key = input.get("cloud_connection.encryptedCredentials.key")

tenant_id = input.get("cloud_connection.encryptedCredentials.tenant_id")

subscription_id = input.get("cloud_connection.encryptedCredentials.subscription_id")

client_id = input.get("cloud_connection.encryptedCredentials.client_id")

//Input from Service Form
os_name = input.get('os_name')

// Getting OS Name
os_type = azure_service_params.get('os_mapping').get(os_name)

log.trace("Valid OS Name is" + os_type)

create_azure_instance_response = call.bit("fb-cloud:azure:operation:create_instance.groovy")

    .set('tenant-id', tenant_id)

    .set('subscription-id', subscription_id)

    .set('client-id', client_id)

    .set('key', key)

    .set('group-name', group_name)

    .set('instance-name', name)

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

log.trace("Exit code: " + create_instance_exit_code)

log.info(create_azure_instance_response)

if (create_instance_exit_code == 0) {

    log.trace("Instance created successfully with instance Name: " + name + "and Size: " + size)

    output.set('Instance-Name', name)

}
else {

    // Setting user message (will be visible on CMP)

    output.set('exit-code', -1).set('error', create_azure_instance_response)

}
log.trace("Finished executing 'fb-cloud:azure:operation:azure_create_instance_wf.js' flintbit.")

