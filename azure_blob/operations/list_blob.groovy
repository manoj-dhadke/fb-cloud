log.trace("Started execution of fb-cloud:azure_blob:operations:list_blob.groovy with input...${input}")
try{
    azure_blob_connector_name = input.get('connector_name')
    action = 'list-blobs'
    account_key = input.get('account_key')
    account_name = input.get('account_name')
    endpoint_url = input.get('endpoint_url')
    endpoint_protocol = input.get('endpoint_protocol')
    request_timeout = input.get('timeout')

    if (azure_blob_connector_name == null || azure_blob_connector_name == ""){
        throw new Exception ('Please provide "Azure Blob connector name (azure_blob_connector_name)" to list blobs')
    }
    else
    {
    connector_call = call.connector(azure_blob_connector_name).set('action', action)
    }
    if (account_key == null || account_key == ""){
        throw new Exception ('Please provide "Azure Storage account_key" to list blobs')
    }
    else
    {
         connector_call.set('account-key', account_key)
    }
    if (account_name == null || account_name == ""){
        throw new Exception ('Please provide "Azure Storage account_name" to list blobs')
    }
    else
    {
        connector_call.set('account-name', account_name)
    }   
    if (endpoint_url == null || endpoint_url == ""){
        throw new Exception ('Please provide "Azure Storage endpoint_url" to list blobs')
    }
    else{
        connector_call.set('endpoint-url', endpoint_url)
    }
    if (endpoint_protocol == null || endpoint_protocol == ""){
        throw new Exception ('Please provide "Azure Storage endpoint_protocol" to list blobs')
    }
    else
    {
        connector_call.set('endpoint-protocol', endpoint_protocol)
    }

    log.info("connector : ${azure_blob_connector_name} | action : ${action} | account_name : ${account_name}")

    //checking that the request timeout provided or not
    if( request_timeout == null || request_timeout instanceof String ){
        log.trace("Calling ${azure_blob_connector_name} with default timeout...")
        list_blob_output = connector_call.sync()
    }
    else{
        log.trace("Calling ${azure_blob_connector_name} with given timeout ${request_timeout}...")
        // calling azure-storage connector
        list_blob_output = connector_call.timeout(request_timeout).sync()
    }


    log.info("This is output : ${list_blob_output}")   
    list_response_exitcode = list_blob_output.exitcode()
    list_response_message = list_blob_output.message()

    result = list_blob_output.get("result")
    output.set('result', result)

    log.info("Exit code : ${list_response_exitcode} | Message : ${list_response_message}")   
  

}
catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}
log.trace('Finished execution of fb-cloud:azure_blob:operations:list_blob.groovy')
