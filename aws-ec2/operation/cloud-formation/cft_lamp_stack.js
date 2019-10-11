log.trace("Started executing 'fb-cloud:aws-ec2:operation:cloud-formation:cft_lamp_stack.js' flintbit")


// Static Variables
connector_name = "amazon-ec2"
action = "create-cloud-formation-stack"

// Inputs
log.info("All inputs :: " + input)
input_clone = JSON.parse(input)

if (input_clone.hasOwnProperty('cft_template')) {

    // Cloud Formation Template JSON
    template = input.get('cft_template')
    if (template != null && template != "") {
        log.debug("CFT Template JSON:: \n" + template)

        if(typeof template == "string"){
            log.trace("Template is given as a JSON string. Coverting to JSON object")
            template = util.json(template)
        }else if (typeof template == "object"){
            log.trace("Template JSON is given")
        }

        // Credential Variables
        access_key = ""
        secret_key = ""

        // Credentials - AWS Cloud Connection JSON
        if (input_clone.hasOwnProperty('cloud_connection')) {
            log.trace("Taking AWS credentials from connection")
            access_key = input.get('cloud_connection').get('encryptedCredentials').get('access_key');
            secret_key = input.get('cloud_connection').get('encryptedCredentials').get('secret_key');

            // Check if credentials are null or empty
            if (access_key == null || access_key == "" && secret_key == null || secret_key == "") {

                log.trace("AWS credentials are not properly given in connection. Checking input JSON")
                if (input_clone.hasOwnProperty('access_key') && input_clone.hasOwnProperty('secret_key')) {
                    log.trace("Taking AWS credentials from input JSON")
                    access_key = input.get('access_key')
                    secret_key = input.get('secret_key')

                    // Check if credentials are null or empty
                    if (access_key != null && access_key != "" && secret_key != null && secret_key != "") {
                        log.trace("Access key and secret key taken from input JSON")
                    } else {
                        log.debug("Access key or secret key is null or empty")
                    }
                } else {
                    log.error("AWS Credentials are not provided. Please provide AWS credentials")
                }
            } else {
                log.info("AWS credentials are taken from connection")
            }
        }

        stack_parameters = null

        // LAMP Stack Parameters
        if (input_clone.hasOwnProperty('stack_parameters')) {
            stack_parameters = input.get('stack_parameters')
            if (typeof stack_parameters == "object") {
                log.trace("Stack parameters are given as JSON")
            } else if (typeof stack_parameters == "string") {
                log.trace("Converting stack parameters JSON string to JSON object")
                stack_parameters = util.json(stack_parameters)
                log.trace("Stack parameters JSON " + typeof stack_parameters)
            }

            // Stack Name
            if (input_clone.hasOwnProperty("stack_name")) {
            
                stack_name = input.get("stack_name")
                log.trace("Stack name is "+stack_name)
                region = input.get('region')
                log.trace("Region is "+region)

                // Building Connector Request
                connector_request = call.connector(connector_name)
                    .set('action', action)
                    .set('region', region)
                    .set('security-key', secret_key)
                    .set('access-key', access_key)
                    .set('stack-parameters', stack_parameters)
                    .set('stack-template-body', template)
                    .set('stack-name', stack_name)
                    .set('stack-formation-timeout', 300000)
                    .timeout(300000)
                    .sync()

                exit_code = connector_request.exitcode()
                message = connector_request.message()

                if(exit_code == 0){
                    log.trace("Exitcode is "+exit_code)

                    // Response Values
                    // Setting user message
                    stack_id = connector_request.get('stack-id')
                    output_array = stack_id.replace(/[/:]/g, ' ').split(' ')

                    user_message_region = output_array[3]
                    user_message_stack_name = output_array[6]
                    user_message_stack_id = output_array[7]

                    log.trace("LAMP stack successfully deployed with details - \nRegion: "+user_message_region+"\nStack Name: "+user_message_stack_name+"\nStack ID: "+user_message_stack_id)

                    output.set("exit-code", 0).set("result", user_message_stack_id)

                }else{
                    log.error("LAMP stack creation failed with "+exit_code)
                    log.error("Failed due to- "+message)
                    output.set("exit-code", -1).set("error", message)
                }


            } else {
                log.error("Please provide stack name for this LAMP stack")
            }
        } else {
            log.error("Please provide LAMP stack parameters")
        }

    } else {
        log.error("Cloud Formation template is null or empty")
    }

} else {
    log.error("Cloud Formation template for LAMP stack is not given. Please provide LAMP stack template.")
}


log.trace("Finished executing 'fb-cloud:aws-ec2:operation:cloud-formation:cft_lamp_stack.js' flintbit")