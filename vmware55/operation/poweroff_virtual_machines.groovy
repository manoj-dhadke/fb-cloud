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
log.trace("Started execution 'fb-cloud:vmware55:operation:poweroff_virtual_machines.groovy' flintbit...") // execution Started
try{
    // Flintbit input parametes
    // Mandatory
    connector_name = input.get('connector_name') // vmware connector name
    action = input.get('action') // name of the operation: stop-vm
    username = input.get('username') // username of vmware connector
    password = input.get('password') // password of vmware connector
    vmname = input.get('vm-name')	// name of virtual machine which you want to stop
    url = input.get('url')

    // Optional
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('url', url)
                          .set('username', username)
                          .set('password', password)

    // checking connector name is nil or empty
    if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "VMWare connector name (connector_name)" to stop virtual machines')
    }

    //checking virtual machine name is nil or empty
    if( vmname == null || vmname == ""){
       throw new Exception ( 'Please provide "Virtual Machine name (vmname)" to stop virtual machine')
    }
    else{
        connector_call.set('vm-name', vmname)
    }

    if( request_timeout == null || request_timeout instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        // calling vmware55 connector
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        // calling vmware55 connector
        response = connector_call.timeout(request_timeout).sync()
    }

    // VMWare  Connector Response Meta Parameters
    response_exitcode = response.exitcode() // Exit status code
    response_message =  response.message() // Execution status message

    if (response_exitcode == 0){
        log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('exit-code', 0).set('message', 'success')
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('exit-code', -1).set('message', response_message)
        output.exit(1, response_message)
    }
}
catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:vmware55:operation:poweroff_virtual_machines.groovy' flintbit...")
// end
