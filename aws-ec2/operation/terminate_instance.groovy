// begin
log.trace("Started executing 'fb-cloud:aws-ec2:operation:terminate_amazon_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // mandatory
    provider_details = util.json(input.get('provider_details'))
    
    connector_name = config.global('flintcloud-integrations.aws-ec2.name')	// Name of the Amazon EC2 Connector
    action = 'terminate-instances'	// Terminate Amazon EC2 instance action
    instance_id = input.get('instance-id')	// Amazon Instance ID to terminate one or more Instances
        // optional
    region = input.get('region')	// Amazon EC2 region (default region is 'us-east-1')
    request_timeout = 60000	// Execution time of the Flintbit in milliseconds
    access_Key=provider_details.get('credentials').get('access_key')
    log.info(access_Key)
    secret_Key=provider_details.get('credentials').get('secret_key')   
    subtype=provider_details.get('subtype')
    prov_name = provider_details.get('name') 

    log.info("Flintbit input parameters are, action : ${action} | instance_id : ${instance_id} | region : ${region}")

    connector_call = call.connector(connector_name).set('action', action).set('access-key', access_Key).set('security-key', secret_Key)

    if (connector_name ==null || connector_name ==""){
        throw new Exception('Please provide "Amazon EC2 connector name (connector_name)" to terminate Instance')
    }

    if (instance_id ==null || instance_id ==""){
        throw new Exception('Please provide "Amazon instance ID (instance_id)" to terminate Instance')
    }
    else{
        connector_call.set('instance-id', instance_id)
    }

    if (region !=null && region !=""){
        connector_call.set('region', region)
    }
    else{
        log.trace("Region is not provided so using default region 'us-east-1'")
    }

    if (request_timeout ==null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }
    log.info(response.toString())
    // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()              	          // Exit status code
    response_message = response.message()                           // Execution status messages

    // Amazon EC2 Connector Response Parameters
    instances_set = response.get('terminated-instance-set') // Set of Amazon EC2 terminated instances

    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message :  ${response_message}")
        user_message=("AWS VM deleted successfully")
        instances_set.each { instance_id ->
            log.info("Amazon EC2 Instance current state :  ${instance_id.get('current-state')} | previous state : ${instance_id.get('previous-state')} | Instance ID :    ${instance_id.get('instance-id')}")
        }
        output.set('exit-code', 0).set('terminated-instances', instances_set).set('user_message',user_message)
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        user_message=("Error in AWS instance deletion")
        response=response.toString()
        if (response !=""){
        output.set('message', response_message).set('exit-code', 1).set('user_message',user_message).set('error-details',response.toString())
        }
        else{
        output.set('message', response_message).set('exit-code', 1).set('user_message',user_message)
        }
    }
}
catch (Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:aws-ec2:operation:terminate_amazon_instance.groovy' flintbit")
// end
