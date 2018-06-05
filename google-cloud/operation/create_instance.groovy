// begin
log.trace("Started execution 'fb-cloud:google-cloud:operation:create_instance.groovy' flintbit...") // execution Started
try{
    // Flintbit input parametes
    // Mandatory
    connector_name = input.get('connector_name') // google-cloud connector name
    action = "create-instance" // name of the operation: create-instance
    project_id = input.get('project-id') // project-id of the google cloud-platform
    zone_name = input.get('zone-name') // zone-name of the project id
    service_account_credenetials = input.get('service-account-credentials') //service account credentials as json for the given project-id
    instance_name = input.get('instance-name') //instance name to start instance
    disk_type = input.get('disk-type') // type of the disk to create instance
    image_name = input.get('image-name') //name of the image to create instace
    machine_type = input.get('machine-type') //type of the machine for creating virtual machine
    image_project_id = input.get('image-project-id') //project id of the image where image is present

    //optional
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
    deletion_protection= input.get('deletion-protection') //deletion protection for the created instance
    //initialize the connector with the action and other parameters
    connector_call = call.connector(connector_name)
                         .set('action', action)

    // checking connector name is nil or empty
    if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "google-cloud connector name (connector_name)" to create instance')
    }

    //checking project-id is nil or empty
    if( project_id == null || project_id == ""){
       throw new Exception ( 'Please provide "Please provide project id (project-id)" to create instance')
    }
    else{
        connector_call.set('project-id', project_id)
    }

     //checking zone name is nil or empty
    if( zone_name == null || zone_name == ""){
       throw new Exception ( 'Please provide "Please provide zone name(zone-name)" to create instance')
    }
    else{
        connector_call.set('zone-name', zone_name)
    }

  //checking service-account-credentials is nil or empty
    if( service_account_credenetials == null || service_account_credenetials == ""){
       throw new Exception ( 'Please provide "Please provide service account credentials (service-account-credentials)" to create instance')
    }
    else{
        connector_call.set('service-account-credentials', service_account_credenetials)
    }


  //checking instance name is nil or empty
    if( instance_name == null || instance_name == ""){
       throw new Exception ( 'Please provide "Please provide instance name (insatnce-name)" to create instance')
    }
    else{
        connector_call.set('instance-name', instance_name)
    }



     //checking disk-type is nil or empty
    if( disk_type == null || disk_type == ""){
       throw new Exception ( 'Please provide "Please disk type (disk-type)" to create instance')
    }
    else{
        connector_call.set('disk-type', disk_type)
    }

  //checking image name is nil or empty
    if( image_name == null || image_name == ""){
       throw new Exception ( 'Please provide "Please image name (image-name)" to create instance')
    }
    else{
        connector_call.set('image-name', image_name)
    }


  //checking machine type is nil or empty
    if( machine_type == null || machine_type == ""){
       throw new Exception ( 'Please provide "Please provide machine type (machine-type)" to create instance')
    }
    else{
        connector_call.set('machine-type', machine_type)
    }

     //checking image project id is nil or empty
    if( image_project_id == null || image_project_id == ""){
       throw new Exception ( 'Please provide "Please provide image project id (image-project-id)" to create instance')
    }
    else{
        connector_call.set('image-project-id', image_project_id)
    }

   //checking deletion protection is nil or empty
    if( deletion_protection == null || deletion_protection == ""){
        log.info "detetion protection is not provided"
        connector_call.set('deletion-protection', false)
    }
    else{
        connector_call.set('deletion-protection', deletion_protection)
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

    //operation details
    operation_details=response.get('operation-details')

    if (response_exitcode == 0){
        log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")
        user_message= "Successfully created instance: ${instance_name} in Google Cloud Provider"
        output.set('exit-code', 0).set('message', 'success').set('operation-details',operation_details).set('user_message',user_message)

    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
        user_message= "Failed to create instance: ${instance_name} in Google Cloud Provider"
        output.set('exit-code', -1).set('message', response_message).set('user_message',user_message)
       }
}
catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:google-cloud:operation:create_instance.groovy' flintbit...")
// end
