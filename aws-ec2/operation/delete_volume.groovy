log.trace("Started executing 'fb-cloud:aws-ec2:operation:delete_volume.groovy' flintbit...")
try{

    // Flintbit Input Parameters
    // Mandatory
    connector_name = 'amazon-ec2' // Name of the Amazon EC2 Connector
    action = 'delete-volume' // Specifies the name of the operation:delete-volumes
    volume_id = input.get('volume-id')// Specifies the id of the volume
    // Optional
    access_key = input.get('access-key')
    secret_key = input.get('security-key')
    region = input.get('region')	// Amazon EC2 region (default region is "us-east-1")
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)


    log.info("Flintbit input parameters are, action : ${action} | volume_id : ${volume_id} | region : ${region} ")

    if (connector_name ==null || connector_name ==""){
        throw new Exception('Please provide "Amazon EC2 connector name (connector_name)" to delete volume')
    }

    if (volume_id ==null || volume_id ==""){
        throw new Exception('Please provide "Amazon EC2 volume ID (volume_id)" to delete')
    }

    connector_call = call.connector(connector_name)
                                    .set('action', action)
                                    .set('volume-id', volume_id)
                                    .set('access-key', access_key)
                                    .set('security-key', secret_key)

    if (region !=null && region !=""){
        connector_call.set('region', region)
    }
    else{
        log.trace("region is not provided so using default region 'us-east-1'")
    }

    if (request_timeout ==null || request_timeout instanceof String){
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
        response=response.toString()
        if (response !=""){
        output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.toString())
        }
        else{
        output.set('message', response_message).set('exit-code', 1)
        }
    }

}catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('error', e.message)
}
log.trace("Finished executing 'fb-cloud:aws-ec2:operation:delete_volume.groovy' flintbit")