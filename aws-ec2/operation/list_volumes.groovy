/*
Creation Date - 14/06/2019
Description - List Volumes on AWS EC2
*/

// begin
log.trace("Started executing 'fb-cloud:aws-ec2:operation:list_volumes.groovy' flintbit...")
try{
// Flintbit Input Parameters
// Mandatory
connector_name = 'amazon-ec2'
//input.get('connector_name')	// Name of the Amazon EC2 Connector
action = 'list-volumes' // Specifies the name of the operation:list-volumes

// Optional
region = input.get('region')	    // Amazon EC2 region (default region is 'us-east-1')
access_key = input.get('access-key')
secret_key = input.get('security-key')
request_timeout = input.get('timeout')	      // Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

log.info("Flintbit input parameters are, connector_name : ${connector_name}| action : ${action}")

// checking the connector name is provided or not,if not then provide error messsage to user
if(connector_name==null || connector_name==""){
    throw new Exception('Please provide "Amazon EC2 connector name (connector_name)" to list volumes')
}

connector_call = call.connector(connector_name)
                      .set('action', action)
                      .set('access-key', access_key)
                      .set('security-key', secret_key)

if(region!=null && region!=""){
      connector_call.set('region', region)
}
else{
 log.trace("region is not provided so using default region 'us-east-1'")
}

if(request_timeout==null || (request_timeout instanceof String)){
    log.trace("Calling ${connector_name} with default timeout...")
    response = connector_call.sync()
    log.trace("${response}")
}
else{
    log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
    response = connector_call.timeout(request_timeout).sync()
}

// Amazon EC2 Connector Response Meta Parameters
response_exitcode = response.exitcode()	// Exit status code
response_message = response.message()	// Execution status messages

// Amazon EC2 Connector Response Parameters
volume_list = response	// Set of Amazon EC2 security groups details

if(response_exitcode == 0){
    log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message} | volume list : ${volume_list}")
    output.set('exit-code', 0).set('message', response_message).set('volume-list',volume_list.toString())
}
else{
    log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} |message : ${response_message}")
    response=response.toString()
    if !response.empty?
    output.set('message', response_message).set('exit-code', 1).set('error-details',response.toString())
    else
    output.set('message', response_message).set('exit-code', 1)
}
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}

log.trace("Finished executing 'fb-cloud:aws-ec2:operation:list_volumes.groovy' flintbit")
// end