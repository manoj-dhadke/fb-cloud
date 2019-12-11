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

log.trace("Started executing 'fb-cloud:azure:operation:add_private_frontend_pool.js' flintbit...")
// Flintbit Input Parameters
// Mandatory
connector_name = 'msazure'
group_name = input.get('group_name')
load_balancer_name = input.get('load_balancer_name')
frontend_pool_name = input.get('frontend_pool_name')
network_name = input.get('network_name')
subnet_name = input.get('subnet_name')
action = 'add-private-frontend-pool'

request_timeout = 180000
input_clone = JSON.parse(input)
if (input_clone.hasOwnProperty('cloud_connection')) {

    // Get credentials
    encryptedCredentials = input.get('cloud_connection').get('encryptedCredentials')

    key = encryptedCredentials.get('key')
    tenant_id = encryptedCredentials.get('tenant_id')
    subscription_id = encryptedCredentials.get('subscription_id')
    client_id = encryptedCredentials.get('client_id')

    log.info("Flintbit input parameters are,connector-name: " + connector_name + " | action :  " + action + "| group - name : " + group_name + " | load - balancer - name : " + load_balancer_name + " | frontend - pool - name: " + frontend_pool_name + " | network - name: " + network_name + " | subnet - name : " + subnet_name)


    if (connector_name == null && connector_name == "") {
        log.error("Please provide MS Azure connector name to add private frontend pool to load balancer")
    }


    if (group_name == null && group_name == "") {
        log.error('Please provide MS Azure group name to add private frontend pool to load balancer')
    }


    if (load_balancer_name == null && load_balancer_name == "") {
        log.error('Please provide MS Azure load balancer name to add private frontend pool to load balancer')
    }


    if (frontend_pool_name == null && frontend_pool_name == "") {
        log.error('Please provide MS Azure frontend pool name to add private frontend pool to load balancer')
    }

    if (network_name == null && network_name == "") {
        log.error('Please provide MS Azure network name to add private frontend pool to load balancer')
    }

    if (subnet_name == null && subnet_name == "") {
        log.error('Please provide MS Azure subnet name to add private frontend pool to load balancer')
    }

    connector_call = call.connector(connector_name)
        .set('action', action)
        .set('tenant-id', tenant_id)
        .set('subscription-id', subscription_id)
        .set('group-name', group_name)
        .set('load-balancer-name', load_balancer_name)
        .set('frontend-pool-name', frontend_pool_name)
        .set('network-name', network_name)
        .set('subnet-name', subnet_name)
        .set('key', key)
        .set('client-id', client_id)

    if (request_timeout == null) {
        log.trace("Calling  " + connector_name + " with default timeout...")
        response = connector_call.sync()
    } else {
        log.trace("Calling  " + connector_name + " with given timeout  " + request_timeout + "...")
        response = connector_call.timeout(request_timeout).sync()
    }

    // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0) {
        log.info("SUCCESS in executing  " + connector_name + " where, exitcode :  " + response_exitcode + " | message :  " + response_message)
        output.set('exit-code', 0).set('message', response_message)
    } else {
        log.error("ERROR in executing  " + connector_name + " where, exitcode :  " + response_exitcode + " | message :  " + response_message)
        output.set('exit-code', 1).set('message', response_message)
    }
} else {
    log.error("Please provide Azure credentials")
    output.set("error", "Please provide Azure connection credentials")
}

log.trace("Finished executing 'fb-cloud:azure:operation:add_private_frontend_pool.js' flintbit")
