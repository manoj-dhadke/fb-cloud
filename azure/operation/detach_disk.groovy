log.trace("Started executing 'fb-cloud:azure:operation:detach_disk.groovy' flintbit...")
try{
// Flintbit Input Parameters
    // Mandatory      
    connector_name = input.get('connector_name') //name of Azure connector
    action = 'detach-volume' //Specifies the name of the operation: detach-volume
    instance_id = input.get("instance-id") //name of the subnet which you want to create
    data_disk_name = input.get("data-disk-name")
    key = input.get('key') //Azure accountid
    tenant_id = input.get('tenant-id') //Azure account tenant-id
    subscription_id = input.get('subscription-id') //Azure account subscription-id
    client_id = input.get('client-id') //Azure client-id
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

   //Checking that the connector name is provided or not,if not then throw exception with error message
   if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "Azure connector name (connector_name)"')
    }

      connector_call = call.connector(connector_name)
                            .set('action', action)
                            .set('tenant-id', tenant_id)
                            .set('subscription-id', subscription_id)
                            .set('key', key)
                            .set('client-id', client_id)
                            .set('data-disk-name',data_disk_name)
                            .set('instance-id', instance_id)

   if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    } else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    // MS-azure Connector Response Meta Parameters
    log.debug("==================>>>>>>>>>>>>>>>>>>>>>   ${response}")
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message', response_message)
    } else {
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -2).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure:operation:detach_disk.groovy' flintbit")                         