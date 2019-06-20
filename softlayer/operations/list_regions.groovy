/*
Creation Date - 14/06/2019
Description - To List regions
*/

// begin
log.trace("Started executing 'flint-cloud:softlayer:operations:list_regions.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name') // Name of the Softlayer Connector
    action = 'list-regions' // Contains the name of the operation
    // optional
    username = input.get('username') // Username of softlayer account
    apikey = input.get('apikey') // apikey of softlayer account

    request_timeout = input.get('timeout') // timeout
    log.info("Flintbit input parameters are, connector name :: ${connector_name} | action :: ${action}| username :: ${username}| apikey :: ${apikey}| timeout :: ${request_timeout}")

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('apikey', apikey)
                          .set('username', username)

    if(request_timeout==null || (request_timeout instanceof String)){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    // Softlayer Connector Response Meta Parameters
    response_exitcode = response.exitcode()           // Exit status code
    response_message = response.message()             // Execution status message

    // Softlayer Connector Response Parameters
    result = response.get('list-regions') // Response body
    log.info(result.toString())
    if(response.exitcode == 0){

        log.info("SUCCESS in executing Softlayer Connector where, exitcode :: ${response_exitcode} | message ::  ${response_message}")
        log.info("Softlayer Response Body :: ${result}")
        output.set('exit-code', response.exitcode)
        output.set('message', response.message)
    }
    else{
        log.error("ERROR in executing Softlayer Connector where, exitcode :: ${response_exitcode} | message ::  ${response_message}")
        output.set('exit-code', response.exitcode)
        output.set('message', response.message)
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}
log.trace("Finished executing 'flint-cloud:softlayer:operations:list_regions.groovy' flintbit...")
