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
log.trace("Started execution 'fb-cloud:google-cloud:operation:list_images.groovy' flintbit...") // execution Started
try{
    // Flintbit input parametes
    // Mandatory
    connector_name = input.get('connector_name') // google-cloud connector name
    action = "list-images" // name of the operation: list-images
    project_id = input.get('project-id') // project-id of the google cloud-platform 
    service_account_credenetials = input.get('service-account-credentials') //service account credentials as json for the given project-id
   
    // Optional
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    //initialize the connector with the action and other parameters
    connector_call = call.connector(connector_name)
                         .set('action', action)                         
                         
    // checking connector name is nil or empty
    if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "google-cloud connector name (connector_name)" to list images ')
    }



    //checking project-id is nil or empty
    if( project_id == null || project_id == ""){
       throw new Exception ( 'Please provide "Please provide project id (project-id)" to list images ')
    }
    else{
        connector_call.set('project-id', project_id)
    }

  //checking service-account-credentials is nil or empty
    if( service_account_credenetials == null || service_account_credenetials == ""){
       throw new Exception ( 'Please provide "Please provide service account credentials (service-account-credentials)" to list images')
    }
    else{
        connector_call.set('service-account-credentials', service_account_credenetials)
    }
    //checking that the request timeout provided or not
    if( request_timeout == null || request_timeout instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        // calling google cloud connector
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        // calling google-cloud connector
        response = connector_call.timeout(request_timeout).sync()
    }

    // google-cloud  Connector Response Meta Parameters	
    response_exitcode = response.exitcode() // Exit status code
    response_message =  response.message() // Execution status message

    //list of the images
    images_list=response.get('images-list')

    if (response_exitcode == 0){
        log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('exit-code', 0).set('message', 'success').set('images-list',images_list)
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('exit-code', -1).set('message', response_message)
       }
}
catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:google-cloud:operation:list_images.groovy' flintbit...")
// end
