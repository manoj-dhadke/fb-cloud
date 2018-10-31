log.trace("Started executing example:aws_cloud_formation.js flintbit")
try {

    stack_type = ""
    connector_name = ""
    access_key = ""
    security_key = ""

    // Prase input to JSON
    new_input = JSON.parse(input)

    // TOD input
    //connector_name = input.get('connector-name')
    log.trace("All Inputs to this flintbits are : " + input)

    // From service config for all stack types
    // LAMP stack service config
    log.trace("About to check if condition")

    if (new_input.hasOwnProperty('lamp-stack-config')) {
        log.trace("Inside lamp stack config if condition")
        stack_type = input.get('lamp-stack-config').get('stack-type')
        access_key = input.get('lamp-stack-config').get('access-key')
        security_key = input.get('lamp-stack-config').get('security-key')
    }
    else if (new_input.hasOwnProperty('moderate-tier-config')) {
        log.trace("Inside moderate tier configuration")
        stack_type = input.get('moderate-tier-config').get('stack-type')
        access_key = input.get('moderate-tier-config').get('access-key')
        security_key = input.get('moderate-tier-config').get('security-key')
    }

    // TOD inputs
    // action = input.get('action')
    // template_body = input.get('stack-template-body')

    switch (stack_type) {
        // LAMP case
        case "LAMP":
            log.trace("In LAMP case")

            action = input.get('lamp-stack-config').get('action')   // Service config LAMP stack action
            log.trace(action)
            connector_name = input.get('lamp-stack-config').get('connector-name')   // Service config LAMP connector name
            log.trace(connector_name)
            template_body = input.get('lamp-stack-config').get('stack-template-body')   // Service config LAMP template body
            log.trace("TEMPLATE BODY :: " + template_body)

            sshlocation = input.get('lamp-stack-config').get('SSHLocation')

            switch (action) {
                case "create-cloud-formation-stack":
                    // Create Stack case
                    log.trace("LAMP case -> create-cloud-formation-stack sub-case.")

                    // From Service form    
                    stack_name = input.get('stack_name')
                    region = input.get('region')
                    //stack_formation_timeout = input.get('timeout')
                    stack_Formation_timeout = input.get('lamp-stack-config').get('timeout')
                    // Convert to integer since service form is giving it as a string
                    stack_formation_timeout = parseInt(stack_formation_timeout)
                    //keyname = input.get('key_name')
                    keyname = input.get('lamp-stack-config').get('key-name')


                    db_name = input.get('db_name')
                    db_user = input.get('db_user')
                    db_password = input.get('db_password')
                    db_root_password = input.get('db_root_password')
                    instance_type = input.get('instance_type')

                    connector_response = call.connector(connector_name)
                        .set('action', action)
                        .set('region', region)
                        .set('stack-template-body', template_body)
                        .set('stack-name', stack_name)
                        .set('stack-formation-timeout', stack_formation_timeout)
                        .set('DBName', db_name)
                        .set('DBUser', db_user)
                        .set('DBPassword', db_password)
                        .set('DBRootPassword', db_root_password)
                        .set('KeyName', keyname)
                        .set('SSHLocation', sshlocation)
                        .set('InstanceType', instance_type)
                        //.set('instance-type', instance_type)
                        // Newly set variables
                        .set('stack-type', stack_type)
                        .set('security-key', security_key)
                        .set('access-key', access_key)

                        .timeout(stack_formation_timeout)
                        .sync()

                    log.trace(connector_response)
                    // Connector exit code
                    exit_code = connector_response.exitcode()

                    if (exit_code == 0) {

                        // Setting user message
                        stack_id = connector_response.get('stack-id')
                        output_ar = stack_id.replace(/[/:]/g, ' ').split(' ')

                        user_message_region = output_ar[3]
                        user_message_stack_name = output_ar[6]
                        user_message_stack_id = output_ar[7]
                        user_message = "The requested single instance LAMP stack has been created. Here are the details. <br><b>Stack Name:</b> " + user_message_stack_name + " <br><b>Stack ID:</b> " + user_message_stack_id + "<br><b>Region:</b> " + user_message_region

                        log.trace("Connector call done")
                        log.trace("Response is :" + connector_response)
                        output.set('user_message', user_message)
                    }
                    else {
                        log.trace("Connector call failed with exit-code : " + exit_code)
                        output.set("user_message", connector_response)
                    }
                    break;

                // Delete Stack case
                case "delete-cloud-formation-stack":
                    log.trace("LAMP case -> delete-cloud-formation-stack sub-case.")

                    // From Service form    
                    stack_name = input.get('stack_name')
                    region = input.get('region')
                    keyname = input.get('key_name')

                    // AWS EC2 connector call
                    connector_response = call.connector(connector_name)
                        .set('region', region)
                        .set('action', action)
                        .set('KeyName', keyname)
                        .set('stack-name', stack_name)
                        .set('security-key', security_key)
                        .set('access-key', access_key)
                        .sync()

                    log.trace(connector_response)
                    output.set('user_message', connector_response)
                    break;
            }
            break;
        // Moderate stack
        case "Moderate":
            log.trace("In Moderate stack case")
            // Inputs from Service Config
            action = input.get('moderate-tier-config').get('action')   // Service config Moderate teir stack action
            connector_name = input.get('moderate-tier-config').get('connector-name')   // Service config Moderate teir connector name
            template_body = input.get('moderate-tier-config').get('stack-template-body')   // Service config Moderate teir template body
            switch (action) {
                // Create stack cases
                case "create-cloud-formation-stack":
                    log.trace("Moderate case -> create-cloud-formation-stack sub-case")

                    // From Service config
                    sshlocation = input.get('moderate-tier-config').get('SSHLocation')

                    // From Service form    
                    stack_name = input.get('stack_name')                    // Name of the stack to be created
                    region = input.get('region')                            // Region eg. us-east-1
                    stack_formation_timeout = input.get('timeout')          // Timeout for the stack creation
                    // Convert to integer since service form is giving it as a string
                    stack_formation_timeout = parseInt(stack_formation_timeout)
                
                    //keyname = input.get('key_name')                         // AWS Keypair -> Keyname
                    keyname = input.get('moderate-tier-config').get('key_name')
                    instance_type = input.get('instance_type')              // Size of instance to be created eg. t1.micro

                    db_name = input.get('db_name')                          // Name of the database to be created
                    db_user = input.get('db_user')                          // Username for the database 
                    db_password = input.get('db_password')                  // Password for the database
                    db_root_password = input.get('db_root_password')        // Root password for the database
                    db_allocated_storage = input.get('db_allocated_storage')// Database size allocation. Minimum accepted is 5GB
                    db_class = input.get('db_class')                        // Database class eg.db-t2.micro

                    connector_response = call.connector(connector_name)
                        .set('action', action)
                        .set('region', region)
                        .set('stack-template-body', template_body)
                        .set('stack-name', stack_name)
                        .set('stack-formation-timeout', stack_formation_timeout)
                        .set('DBName', db_name)
                        .set('DBUser', db_user)
                        .set('DBPassword', db_password)
                        .set('DBRootPassword', db_root_password)
                        .set('KeyName', keyname)
                        .set('stack-type', stack_type)
                        .set('DBAllocatedStorage', db_allocated_storage)
                        .set('DBClass', db_class)
                        .set('security-key', security_key)
                        .set('access-key', access_key)
                        .set('SSHLocation', sshlocation)
                        .set('InstanceType',instance_type)
                        .timeout(stack_formation_timeout)
                        .sync()

                    log.trace("Moderate Stack Response : " + connector_response)
                    exit_code = connector_response.exitcode()


                    if (exit_code == 0) {
                        // Setting user message
                        stack_id = connector_response.get('stack-id')
                        output_ar = stack_id.replace(/[/:]/g, ' ').split(' ')

                        user_message_region = output_ar[3]
                        user_message_stack_name = output_ar[6]
                        user_message_stack_id = output_ar[7]
                        user_message = "The requested stack with two virtual machines and a database server has been created. Here are the details. <br><b>Stack Name:</b> " + user_message_stack_name + " <br><b>Stack ID:</b> " + user_message_stack_id + "<br><b>Region:</b> " + user_message_region


                        log.trace("Connector call successful")
                        output.set('user_message', user_message)
                    } else {
                        log.trace("Connector call failed with exit-code: " + exit_code)// + " and message : " + message)
                        output.set('error_message', connector_response)
                    }
                    break;

                // Delete Stack case
                case "delete-cloud-formation-stack":
                    log.trace("Moderate tier case -> delete-cloud-formation-stack sub-case.")

                    // From Service form    
                    stack_name = input.get('stack_name')
                    region = input.get('region')
                    keyname = input.get('key_name')

                    // AWS EC2 connector call
                    connector_response = call.connector(connector_name)
                        .set('region', region)
                        .set('action', action)
                        .set('KeyName', keyname)
                        .set('stack-name', stack_name)
                        .set('security-key', security_key)
                        .set('access-key', access_key)
                        .set('security-key', security_key)
                        .set('access-key', access_key)
                        .sync()

                    // RESPONSE IS TO BE ADDED TO THE CONNECTOR FOR DELETE STACK ACTION
                    log.trace(connector_response)
                    output.set('user_message', connector_response)
                    break;
            }
            break;
    }
} catch (error) {
    log.error(error)
}



