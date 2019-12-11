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
log.info("Started executing 'fb-cloud:aws-ec2:operation:list_security_groups.groovy' flintbit");

try {
 connector_name = input.get('connector_name')	// Name of the Amazon EC2 Connector
action = 'list-security-group' // Specifies the name of the operation:list-security-group

// Optional
region = input.get('region') // Amazon EC2 region (default region is "us-east-1")
access_key = input.get('access-key')
secret_key = input.get('security-key')
request_timeout = input.get('timeout')	      // Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    if (connector_name == null || connector_name == "") {
        throw new Exception('Please provide "AWS connector name (connector_name)" to list security group')
    }
    else {
        connector_call = call.connector(connector_name).set('action', action)
    }

    if (region != null && region != ""){
        connector_call.set('region', region)
    } 
    else {
        log.trace("region is not provided so using default region 'us-east-1'")
    }
    if (access_key == null || access_key == "") {
        throw new Exception('Please provide "AWS (access-key)" to list security group')
    }
    else {
        connector_call.set('access-key', access_key)
    }
    if (secret_key == null || secret_key == "") {
        throw new Exception('Please provide "AWS (security-key)" to list security group')
    }
    else {
        connector_call.set('security-key', secret_key)
    }

    if (request_timeout == null || request_timeout instanceof String) {
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else {
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }


    log.debug("This is output : ${response}")
    response_exitcode = response.exitcode()
    response_message = response.message()
    security_group_list = response.get('security-group-list')

    if (response_exitcode == 0) {
        log.debug("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        log.debug("security-group-list: ${response}")
        output.set('exit-code', 0).set('message', response_message).set('security-group-list', security_group_list)
    }
    else {
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch (Exception  e) {
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}
log.info("Finished execution of 'fb-cloud:aws-ec2:operation:list_security_groups.groovy'")
