// begin
log.trace("Started executing 'fb-cloud:azure:operation:associate_cidr_block.js' flintbit...")
// Flintbit Input Parameters
// Mandatory
connector_name = 'msazure'
action = 'associate-cidr-block' //Specifies the name of the operation:associate-cidr-block
network_id = input.get('network_id') //ID of the netowrk which you want to delete
address_spaces = input.get('address_spaces') // provide address space in the form  of CIDR notion
request_timeout = 180000

log.info("connector-name: " + connector_name + " | action : " + action + " | network-id: " + network_id + " | address-spaces: " + address_spaces)

// MS Azure credentials
input_clone = JSON.parse(input)
if (input_clone.hasOwnProperties('cloud_connection')) {

    // Get credentials
    encryptedCredentials = input.get('cloud_connection').get('encryptedCredentials')

    key = encryptedCredentials.get('key')
    tenant_id = encryptedCredentials.get('tenant_id')
    subscription_id = encryptedCredentials.get('subscription_id')
    client_id = encryptedCredentials.get('client_id')

    //Checking that the connector name is provided or not,if(not then log.error(the exception with error message
    if (connector_name == null && connector_name == "") {
        log.error('Please provide MS Azure connector name to associate network')
    }

    //Checking that the network id is provided or not,if(not then log.error(the exception with error message
    if (network_id == null && network_id == "") {
        log.error('Please provide MS Azure network id to associate to network')
    }

    // Checking that the address spaces is provided or not,if(not then log.error(the exception with error message
    if (address_spaces == null && address_spaces == "") {
        log.error('Please provide Azure address spaces to associate to network')
    }

    // Call MS Azure connector
    connector_call = call.connector(connector_name)
        .set('action', action)
        .set('tenant-id', tenant_id)
        .set('subscription-id', subscription_id)
        .set('key', key)
        .set('client-id', client_id)
        .set('network-id', network_id)
        .set('address-spaces', address_spaces)
        .timeout(2800000)

    if (request_timeout == null) {
        log.trace("Calling " + connector_name + " with default timeout...")
        response = connector_call.sync()
    } else {
        log.trace("Calling " + connector_name + " with given timeout " + request_timeout)
        response = connector_call.timeout(request_timeout).sync()
    }

    // MS-azure Connector Response Meta Parameters
    response_exitcode = response.exitcode()	    // Exit status code
    response_message = response.message()	    // Execution status messages

    if (response_exitcode == 0) {
        log.info("SUCCESS in executing " + connector_name + " where, exitcode : " + response_exitcode + "| message : " + response_message)
        output.set('exit-code', 0).set('message', response_message)
    } else {
        log.error("ERROR in executing " + connector_name + " where, exitcode : " + response_exitcode + " | message : " + response_message)
        output.set('exit-code', 1).set('message', response_message)
    }
} else {
    log.error("Please provide Azure credentials")
    output.set("error", "Please provide Azure connection credentials")
}

log.trace("Finished executing 'fb-cloud:azure:operation:associate_cidr_block.js' flintbit")
