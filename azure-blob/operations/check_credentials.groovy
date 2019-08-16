// begin
log.trace("Started execution 'fb-cloud:azure-storage:opeartion:check_credentials.groovy' flintbit...")
log.debug("Input is : ${input}") // execution Started
try{
    // Flintbit input parametes
    // Mandatory
    connector_name = input.get('connector_name') // azure-storage connector name
    action = "check-credentials" // name of the operation: check-credentials
    // account_name = input.get('account-name')
    // account_key = input.get('account-key') 
    // endpoint_url = input.get('endpoint-url') 
    // endpoint_protocol = input.get('endpoint-protocol') 
    connection_string = input.get('connection_string')

    // Optional
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    //initialize the connector with the action and other parameters
    connector_call = call.connector(connector_name)
                         .set('action', action)                         
                         
    // checking connector name is nil or empty
    if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "azure-storage connector name (connector_name)" to validate credentials')
    }

    if( connection_string == null || connection_string == ""){
       throw new Exception ( 'Please provide "Please provide connection_string" to validate credentials')
    }
    else{
        connector_call.set('connection-string', connection_string)
    }


//     //checking account-name is nil or empty
//     if( account_name == null || account_name == ""){
//        throw new Exception ( 'Please provide "Please provide account_name (account-name)" to validate credentials')
//     }
//     else{
//         connector_call.set('account-name', account_name)
//     }


//  if( account_key == null || account_key == ""){
//        throw new Exception ( 'Please provide "Please provide account_key (account_key)" to validate credentials')
//     }
//     else{
//         connector_call.set('account-key', account_key)
//     }


//   //checking endpoint-url is nil or empty
//     if( endpoint_url == null || endpoint_url == ""){
//        throw new Exception ( 'Please provide "(endpoint-url)" to validate credentials')
//     }
//     else{
//         connector_call.set('endpoint-url', endpoint_url)
//     }


//       //checking endpoint-protocol is nil or empty
//     if( endpoint_protocol == null || endpoint_protocol == ""){
//        throw new Exception ( 'Please provide "(endpoint-protocol)" to validate credentials')
//     }
//     else{
//         connector_call.set('endpoint-protocol', endpoint_protocol)
//     }


    //checking that the request timeout provided or not
    if( request_timeout == null || request_timeout instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        // calling azure-storage connector
        response = connector_call.timeout(request_timeout).sync()
    }

    // azure-storage  Connector Response Meta Parameters
    response_exitcode = response.exitcode() // Exit status code
    response_message =  response.message() // Execution status message

    if (response_exitcode == 0){
        log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('exit-code', 0).set('message', 'success')
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('exit-code', -1).set('message', response_message)
       }
}
catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:azure-storage:opeartion:check_credentials.groovy' flintbit...")
// end
