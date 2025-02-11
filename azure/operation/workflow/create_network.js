/*************************************************************************
 * 
 * INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
 * __________________
 * 
 * (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
 * All Rights Reserved.
 * Product / Project: Flint IT Automation Platform
 * NOTICE:  All information contained herein is, and remains
 * the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
 * The intellectual and technical concepts contained
 * herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
 * Dissemination of this information or any form of reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
 */

log.trace("Started executing 'fb-cloud:azure:operation:create_network.js' flintbit...")

//Flintbit Input Parameters
//Mandatory
connector_name = 'msazure'
region = input.get('region') //name of the region in which the the network will be located
resource_group = input.get('resource_group') //name of the resource group in which you want to create the network
network_name = input.get('network_name')     //name of network which you want to create
address_spaces = input.get('address_spaces') //provide address space in the form  of CIDR notion
action = 'create-network' //Specifies the name of the operation:create-network

input_clone = JSON.parse(input)
if (input_clone.hasOwnProperty('cloud_connection')) {

    // Get credentials
    encryptedCredentials = input.get('cloud_connection').get('encryptedCredentials')

    key = encryptedCredentials.get('key')
    tenant_id = encryptedCredentials.get('tenant_id')
    subscription_id = encryptedCredentials.get('subscription_id')
    client_id = encryptedCredentials.get('client_id')
    request_timeout = 180000

    log.info("connector_name : " + connector_name + " | action: " + action + " |  region : " + region + " | resource_group : " + resource_group + " |  network_name :  " + network_name + " | address - spaces : " + address_spaces)


    //Checking that the connector name is provided or not,if(not then log.error(the exception with error message
    if (connector_name == null) {
        log.error('Please provide Azure connector name to create  virtual network')
    }

    //Checking that the region name is provided or not,if(not then log.error(the exception with error message
    if (region == null && region == "") {
        log.error('Please provide Azure region name to create  virtual network')
    }

    //Checking that the resource group name is provided or not,if(not then log.error(the exception with error message
    if (resource_group == null && resource_group == "") {
        log.error('Please provide Azure resource group name to create  virtual network')
    }

    //Checking that the network name is provided or not,if(not then log.error(the exception with error message
    if (network_name == null && network_name == "") {
        log.error('Please provide Azure network name to create  virtual network')
    }

    //Checking that the adderess spaces is provided or not,if(not then log.error(the exception with error message
    if (address_spaces == null && address_spaces == "") {
        log.error('Please provide Azure address spaces to create  virtual network')
    }

    connector_call = call.connector(connector_name)
        .set('action', action)
        .set('tenant-id', tenant_id)
        .set('subscription-id', subscription_id)
        .set('key', key)
        .set('client-id', client_id)
        .set('region', region)
        .set('resource-group', resource_group)
        .set('network-name', network_name)
        .set('address-spaces', address_spaces)
        .timeout(300000)

    if (request_timeout == null) {
        log.trace("Calling  " + connector_name + " with default timeout...")
        response = connector_call.sync()
    } else {
        log.trace("Calling  " + connector_name + " with given timeout  " + request_timeout)
        response = connector_call.timeout(request_timeout).sync()
    }

    //MS-azure Connector Response Meta Parameters
    response_exitcode = response.exitcode()	//Exit status code
    response_message = response.message()	//Execution status messages

    network_details = response.get('network-details') // getting created network details
    network_details = util.json(network_details)
    if (response_exitcode == 0) {
        log.info("SUCCESS in executing  " + connector_name + " where, exitcode :  " + response_exitcode + " | message :  " + response_message)
        output.set('exit-code', 0).set('message', response_message).set('network-details', network_details)
    } else {
        log.error("ERROR in executing  " + connector_name + " where, exitcode :  " + response_exitcode + " | message :  " + response_message)
        output.set('exit-code', 1).set('message', response_message)
    }
} else {
    log.error("Please provide Azure credentials")
    output.set("error", "Please provide Azure connection credentials")
}
log.trace("Finished executing 'fb-cloud:azure:operation:create_network.js' flintbit")
