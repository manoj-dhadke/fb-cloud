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
log.trace("Started executing 'fb-cloud:aws-s3:operation:delete_file.groovy' flintbit...")
try{
	// Flintbit Input Parameters
	// Mandatory Input Parameters

	connector_name = input.get("connector_name") // Name of the Amazon EC2 Connector
	action = 'delete-file'                    //input.get("action")
	bucket_name = input.get("bucket-name")  //name of bucket from which you want to delete file
	filename = input.get("file") //name of the file which you want to delete
    access_key = input.get("access-key") //aws account access key
	security_key = input.get("security-key") //aws account security key
    region = input.get("region")

	log.info("Connector Name:${connector_name}"+
	        "| Action:${action}"+ 
                "| Bucket Name: ${bucket_name}"+
                "| File Name :${filename}")


	// checking that connector name is provided or not
	if(connector_name==null || connector_name==""){
		throw new Exception('Please provide "aws-s3 connector name (connector_name)" to deleto file from given bucket')
    }

	// checking that bucket name is provided or not
	if(bucket_name==null || bucket_name==""){
		throw new Exception('Please provide "name of bucket (bucket-name)" from which you want to delete file from given bucket')
    }

	// checking that file name is provided or not
	if(filename==null || filename==""){
		throw new Exception('Please provide "name of file (bucket-name)" to delete from bucket on aws-s3')
    }

    // checking that access-key is provided or not
	if(access_key==null || access_key==""){
		throw new Exception('Please provide "Access Key (access-key)"')
    }

    // checking that bucket name is provided or not
	if(security_key==null || security_key==""){
		throw new Exception('Please provide "Security Key (security-key)"')
    }

	// checking that region is provided or not
	if(region==null || region==""){
        throw new Exception('Please provide "Region (region)"')
    }

    //initializing the connector with the parameter        
	connector_call = call.connector(connector_name)
                        .set('action', action)
                        .set('bucket-name', bucket_name)
                        .set('file', filename)
                        .set("access-key",access_key)
                        .set("security-key",security_key)
						.set("region",region)

    if(input.hasProperty("request_timeout")){
        request_timeout = input.get("request_timeout");
        if(request_timeout!=null || request_timeout!=""){
            response = connector_call.timeout(request_timeout).sync(); 
            log.info("Request Timeout: "+request_timeout);
        }
        else{
			response = connector_call.timeout(240000).sync(); 
            log.info("Calling connector with request_timeout 240000 miliseconds");
        }
    }
    else{  //request_timeout key not present in input JSON 
		response = connector_call.timeout(240000).sync(); 
        log.info("Calling connector with request_timeout 240000 miliseconds");
    }

	response_exitcode = response.exitcode()              		// Exit status code
	response_message = response.message()                		// Execution status messages

	log.info("response:: ${response}")

	if(response_exitcode == 0){
		log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
		output.set('message', response_message).set('exit-code', 0)
    }
    else{
		log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
		output.set('message', response_message).set('exit-code', -1)
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('message', e.message).set('exit-code', -1)
    log.info('output in exception')
}
log.trace("Finished executing 'fb-cloud:aws-s3:operation:delete_file.groovy' flintbit")