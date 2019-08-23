log.trace("Started executing 'fb-cloud:azure:operation:create_resource_group.js' flintbit...")
log.info("Flintbit inputs: "+input)
// Flintbit Input Parameters
// Mandatory
connector_name = 'msazure' //input.get('connector_name')
region = input.get('region')
group_name = input.get('group_name')
action = 'create-resource-group'

// Optional
request_timeout = 120000
input_clone = JSON.parse(input)
if (input_clone.hasOwnProperty('cloud_connection')) {

    // Get credentials
    encryptedCredentials = input.get('cloud_connection').get('encryptedCredentials')
    log.trace("Encrypted:: "+encryptedCredentials)

    key = encryptedCredentials.get('key')
    tenant_id = encryptedCredentials.get('tenant_id')
    subscription_id = encryptedCredentials.get('subscription_id')
    client_id = encryptedCredentials.get('client_id')

    log.info("Flintbit input parameters are, action : " + action + " | Group name : " + group_name + " | Region : " + region)

    connector_call = call.connector(connector_name)
        .set('action', action)
        .set('tenant-id', tenant_id)
        .set('subscription-id', subscription_id)
        .set('key', key)
        .set('client-id', client_id)
        .set('group-name', group_name)
        .set('region', region)

    if (connector_name == null && connector_name == "") {
        log.error('Please provide MS Azure connector name to create resource group')
    }

    if (request_timeout != null) {
        log.trace("Calling " + connector_name + " with default timeout...")
        response = connector_call.sync()
    } else {
        log.trace("Calling " + connector_name + " with given timeout " + request_timeout + "...")
        response = connector_call.timeout(request_timeout).sync()
    }

    // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()   // Execution status messages

    if (response_exitcode == 0) {
        log.info("SUCCESS in executing " + connector_name + " where, exitcode : " + response_exitcode + " | message : " + response_message)
        output.set('exit-code', 0).set('message', response_message).set('id', response.get('id'))
    } else {
        log.error("ERROR in executing " + connector_name + " where, exitcode : " + response_exitcode + " | message : " + response_message)
        output.set('exit-code', 1).set('message', response_message)
    }
} else {
    log.error("Please provide Azure credentials")
    output.set("error", "Please provide Azure connection credentials")
}
log.trace("Finished executing 'fb-cloud:azure:operation:create_resource_group.js' flintbit")
