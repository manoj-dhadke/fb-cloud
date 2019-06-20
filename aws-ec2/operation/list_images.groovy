/*
Creation Date - 14/06/2019
Description - List Images on AWS EC2
*/

// begin
log.trace("Started executing 'fb-cloud:aws-ec2:operation:list_images.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')	// Name of the Amazon EC2 Connector
    action = 'list-image'	// Contains the name of the operation: list_image
    account_id = input.get('account-id')
    access_key = input.get('access-key')
    secret_key = input.get('security-key')
    region = input.get('region')	// Amazon EC2 region (default region is "us-east-1")
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    log.info("Flintbit input parameters are, action : ${action} | region : ${region}")

    if(connector_name==null || connector_name==""){
        throw new Exception('Please provide "Amazon EC2 connector name (connector_name)" to list Images')
    }

    connector_call = call.connector(connector_name).set('action', action).set('account-id', account_id).set('access-key', access_key).set('security-key', secret_key)

    if(region!=null && region!=""){
        connector_call.set('region', region)
    }
    else{
        log.trace("region is not provided so using default region 'us-east-1'")
    }

    if(request_timeout==null || (request_timeout instanceof String)){
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
    
    if(response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        log.info("Amazon EC2 image list : ${response}")

        output.set('exit-code', 0).set('message', response_message)
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        response=response.toString()
        if(response!=""){
            output.set('message', response_message).set('exit-code', 1).set('error-details',response)
        }
        else{
            output.set('message', response_message).set('exit-code', 1)
        }
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:aws-ec2:operation:list_images.groovy' flintbit")
