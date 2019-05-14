// begin
log.trace("Started executing 'fb-cloud:azure-stack:operation:delete_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = config.global('flintcloud-integrations.azure.name')
    action = 'as-delete-instance'
    group_name = input.get('group-name')
    name = input.get('instance-name')
    provider_details = util.json(input.get('provider_details'))
    // Optional
    request_timeout = 240000
    clientId=provider_details.get('credentials').get('client_id')
    key=provider_details.get('credentials').get('key')
    subscriptionId=provider_details.get('credentials').get('subscription_id')
    tenantId = provider_details.get('credentials').get('tenant_id')
    subtype=provider_details.get('subtype')
    arm_endpoint = input.get('arm-endpoint')

    log.info("Flintbit input parameters are, action : ${action} | Group name : ${group_name} | Name : ${name}")

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenantId)
                          .set('subscription-id', subscriptionId)
                          .set('key', key)
                          .set('group-name',group_name)
                          .set('client-id', clientId)

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
        output.set('exit-code', 0).set('user_message', user_message)
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
