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
log.trace("Started execution 'fb-cloud:vmware55:operation:details_datastore.groovy' flintbit...") // execution Started
try{

    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name') // vmware55 connector name
    action = 'datastore-details' // name of action:host-details
    username = input.get('username') // username of vmware55 connector
    password = input.get('password') // password of vmware55 connector
    url = input.get('url')
    datastoreName = input.get('datastore-name')

    // Optional
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('url', url)
                          .set('username', username)
                          .set('password', password)
                          .set('datastore-name', datastoreName)
    // checking connector name is nil or empty
    if (connector_name == null || connector_name == ""){
        throw new Exception ('Please provide "VMWare connector name (connector_name)" to list get details of a datastore') 
    }

    if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        // calling vmware55 connector
        response = connector_call.sync()
    }else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        // calling vmware55 connector
        response = connector_call.timeout(request_timeout).sync()
    }

    // VMWare  Connector Response Meta Parameters
    response_exitcode = response.exitcode() // Exit status code
    response_message =  response.message() // Execution status message

    log.info("RESPONSE :: ${response}")

    if (response_exitcode == 0){
        log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('result', response.toString()).set('exit-code', 0)
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('message', response_message.toString()).set('exit-code', response_exitcode)
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:vmware55:operation:details_datastore.groovy' flintbit...")
// end
