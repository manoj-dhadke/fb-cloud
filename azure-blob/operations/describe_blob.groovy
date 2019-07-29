
// begin
log.trace("Started executing 'fb-cloud:azure-blob:operations:describe_blob.groovy' flintbit... ${input.raw()}")

    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = "get-blob-details"
    connection_string = input.get('connection_string')
    blob_name = input.get('blob_name')
    container_name = input.get('container_name')

    //optional
    request_timeout = input.get('timeout')
    log.debug("Flintbit input parameters are, connector_name: ${connector_name}| action : ${action} | Container name : ${container_name} | Blob name : ${blob_name}")

    if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "azure-storage connector name (connector_name)"')
    }
    if( connection_string == null || connection_string == ""){
       throw new Exception ( 'Please provide "azure-storage Connection string (connection_string)" to validate credentials')
    }
    if (blob_name == null || blob_name == ""){
       throw new Exception ( 'Please provide "azure-storage Blob name (blob_name)"')
    }
    if( container_name == null || container_name == ""){
       throw new Exception ( 'Please provide "azure-storage Container name (container_name)"')
    }

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('connection-string', connection_string)
                          .set('containerName', container_name)
                          .set('blobName', blob_name)

    if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    log.debug("Response :: " +  response)

    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message', response_message).set('result', response.toString())
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }

log.trace("Finished executing 'fb-cloud:azure-blob:operations:describe_blob.groovy' flintbit")
// end
