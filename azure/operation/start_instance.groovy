// begin
log.trace("Started executing 'fb-cloud:azure:operation:start_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'start-instance'
    group_name = input.get('group-name')
    name = input.get('instance-name')

    // Optional
    request_timeout = 180000
    key = input.get('key')
    tenant_id = input.get('tenant-id')
    subscription_id = input.get('subscription-id')
    client_id = input.get('client-id')
    log.info("Flintbit input parameters are, action : ${action} | Group name : ${group_name} | Name : ${name}")

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('key', key)
                          .set('group-name',group_name)
                          .set('client-id', client_id)

    if (connector_name == null || connector_name  ==""){
        throw new Exception('Please provide "MS Azure connector name (connector_name)" to start Instance')
    }

    if (name == null || name  ==""){
        throw new Exception('Please provide "Azure instance name (name) to start Instance')
    }
    else{
        connector_call.set('instance-name', name)
    }

    if (request_timeout == null || request_timeout instanceof String){
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
        output.set('exit-code', 0).set('message', response_message)
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
        // output.exit(1,response_message)														//Use to exit from flintbit
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure:operation:start_instance.groovy' flintbit")
// end
