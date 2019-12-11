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
log.trace("Started executing 'fb-cloud:azure-stack:operation:delete_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = config.global('flintcloud-integrations.azure.name')
    action = 'as-delete-instance'
    group_name = input.get('group-name')
    name = input.get('instance-name')
    // Optional
    request_timeout = 480000
    key = input.get('key')
    tenant_id = input.get('tenant-id')
    subscription_id = input.get('subscription-id')
    client_id = input.get('client-id')
    arm_endpoint = input.get('arm-endpoint')

    log.info("Flintbit input parameters are, action : ${action} | Group name : ${group_name} | Name : ${name}")

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('key', key)
                          .set('group-name',group_name)
                          .set('client-id', client_id)

    if (connector_name == null || connector_name ==""){
        throw new Exception( 'Please provide "MS Azure connector name (connector_name)" to delete Instance')
    }

    if (name == null || name ==""){
        throw new Exception( 'Please provide "Azure instance name (name) to delete Instance')
    }
    else{
        connector_call.set('instance-name', name)
    }
    if (arm_endpoint == null || arm_endpoint  ==""){
        throw new Exception('Please provide "Azure ARM Endpoint (arm_endpoint) to delete Instance')
    }
    else{
        connector_call.set('arm-endpoint',arm_endpoint)
    }
    if( request_timeout == null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        user_message=("Azure Virtual Machine deleted successfully")
        output.set('exit-code', 0).set('message', response_message).set('user_message', user_message)
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        user_message=("Error in deleting Virtual Machine")
        output.set('exit-code', 1).set('user_message', user_message)
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure-stack:operation:delete_instance.groovy' flintbit")
// end
