log.info("Started executing 'fb-cloud:azure:operation:list_security_groups.groovy' flintbit");

try {
    //Flintbit Input Parameters
    //Mandatory
    connector_name = input.get('connector_name') //name of Azure connector
    action = 'list-security-groups' //Specifies the name of the operation:list-security-groups
    key = input.get('key') //Azure account key
    tenant_id = input.get('tenant-id') //Azure account tenant-id
    subscription_id = input.get('subscription-id') //Azure account subscription-id
    client_id = input.get('client-id') //Azure client-id
    request_timeout = input.get('timeout')

    if (connector_name == null || connector_name == "") {
        throw new Exception('Please provide "MS Azure connector name (connector_name)" to list security group')
    }
    else {
        connector_call = call.connector(connector_name).set('action', action)
    }

    if (key == null || key == "") {
        throw new Exception('Please provide "MS Azure (key)" to list security group')
    }
    else {
        connector_call.set('key', key)
    }

    if (tenant_id == null || tenant_id == "") {
        throw new Exception('Please provide "MS Azure (tenant_id)" to list security group')
    }
    else {
        connector_call.set('tenant-id', tenant_id)
    }

    if (subscription_id == null || subscription_id == "") {
        throw new Exception('Please provide "MS Azure (subscription_id)" to list security group')
    }
    else {
        connector_call.set('subscription-id', subscription_id)
    }

    if (client_id == null || client_id == "") {
        throw new Exception('Please provide "MS Azure (client_id)" to list security group')
    }
    else {
        connector_call.set('client-id', client_id)
    }

    if (request_timeout == null || request_timeout instanceof String) {
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else {
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }


    log.debug("This is output : ${response}")
    response_exitcode = response.exitcode()
    response_message = response.message()
    security_group_list = response.get('security-group-list')

    if (response_exitcode == 0) {
        log.debug("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        log.debug("security-group-list: ${response}")
        output.set('exit-code', 0).set('message', response_message).set('security-group-list', security_group_list)
    }
    else {
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch (Exception  e) {
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}
log.info("Finished execution of 'fb-cloud:azure:operation:list_security_groups.groovy'")
