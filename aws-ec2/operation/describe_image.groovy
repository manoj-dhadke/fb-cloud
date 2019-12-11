/*************************************************************************
 * 
 * INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
 * __________________
 * 
 * (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
 * All Rights Reserved.
 * Product / Project: Flint IT Automation Platform
 * NOTICE:  All information contained herein is, and remains
 * the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
 * The intellectual and technical concepts contained
 * herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
 * Dissemination of this information or any form of reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
 */
log.trace("Started executing 'fb-cloud:aws-ec2:operation:describe_image.groovy' flintbit...      ${input}")
try{
     // Flintbit Input Parameters
     // Mandatory
    connector_name = input.get('connector_name')	 // Name of the Amazon EC2 Connector
    action = 'describe-image'	 // Contains the name of the operation: describe_image
    image_id = input.get('image-id')	 // Specifies the image ID of Amazon EC2

     // Optional
    access_key = input.get('access-key')
    secret_key = input.get('security-key')
    region = input.get('region')	 // Amazon EC2 region (default region is "us-east-1")
    request_timeout = input.get('timeout')	 // Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    log.info("Flintbit input parameters are, action :  ${action} | image_id :  ${image_id} | region :  ${region}")

    if (connector_name == null || connector_name == ""){
        throw new Exception ('Please provide "Amazon EC2 connector name (connector_name)" to describe Image')
    }

    if (image_id == null || image_id == ""){
        throw new Exception ('Please provide "Amazon EC2 image ID (image_id)" to describe image')
    }

    connector_call = call.connector(connector_name).set('action', action).set('image-id', image_id).set('access-key', access_key).set('security-key', secret_key)

    if (region != null && region != ""){
        connector_call.set('region', region)
    }
    else{
        log.trace("region is not provided so using default region 'us-east-1'")
    }

    if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling  ${connector_name} with default timeout... ")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling  ${connector_name} with given timeout  ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }
        
     // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	 // Exit status code
    response_message = response.message()	 // Execution status messages
    image_info = response.get('image-info')	 // image info json

    if (response_exitcode == 0){
        log.info("SUCCESS in executing  ${connector_name} where, exitcode :  ${response_exitcode} | message :  ${response_message}")
        log.info("Amazon EC2 Image info :  ${image_info}")
        output.set('exit-code', 0).set('message', response_message).set('image-info', image_info)
    }
        
    else{

        log.error("ERROR in executing  ${connector_name} where, exitcode :  ${response_exitcode} | message :  ${response_message}")
        response=response.toString()
        if (response != ""){
            output.set('message', response_message).set('exit-code', 1).setraw('error-details',response)
        }
        
        else{
            output.set('message', response_message).set('exit-code', 1)
        }
        
    }
}   
    
catch(Exception e) {
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}

log.trace("Finished executing 'fb-cloud:aws-ec2:operation:describe_image.groovy' flintbit")
