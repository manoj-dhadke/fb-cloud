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
log.trace("Started executing 'fb-cloud:azure:operation:describe_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'describe-instance'
    instance_name = input.get('instance-name')
    group_name = input.get('group-name')

    // Optional
    request_timeout = 120000
    key = input.get('key')
    tenant_id = input.get('tenant-id')
    subscription_id = input.get('subscription-id')
    client_id = input.get('client-id')

    log.info("Flintbit input parameters are,connector_name: ${connector_name}| action : ${action} | Group name : ${group_name} | Name : ${instance_name} | tenant_id : ${tenant_id} | subscription_id : ${subscription_id} | key : ${key} | client_id : ${client_id}")

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('key', key)
                          .set('client-id', client_id)
                          .set('instance-name',instance_name)
                          .set('group-name',group_name)

    if (connector_name == null || connector_name == ""){
        throw new Exception ('Please provide "MS Azure connector name (connector_name)" to Describe Instance')
    }

    if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }
    // Amazon EC2 Connector Response Meta Parameters
    log.debug(" Response  ::   ${response}")
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages


    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message', response_message).set('instance-details',response.get('instance-details'))
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch(java.lang.NullPointerException ne){ 
    log.error(ne.message)
    output.set('exit-code', -2).set('message', "nullPointer exception catched, no response from connector")
}
catch(Exception e){ 
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure:operation:describe_instance.groovy' flintbit")
// end
