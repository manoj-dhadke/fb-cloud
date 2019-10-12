log.trace("Started executing flintbit 'fb-cloud:azure:operation:arm-templates:deploy_arm_template.js' flintbit")

input_clone = JSON.parse(input)

// Initial Variables
subscription_id = ""
client_id = ""
key = ""
tenant_id = ""

// Credentials
if (input_clone.hasOwnProperty('cloud_connection')) {
    log.trace("Azure connection is given")

    encryptedCredentials = input.get('cloud_connection').get('encryptedCredentials')
    subscription_id = encryptedCredentials.get('subscription_id')
    client_id = encryptedCredentials.get('client_id')
    key = encryptedCredentials.get('key')
    tenant_id = encryptedCredentials.get('tenant_id')
    log.trace("Azure credentials successfully received from cloud connection")

    // Credentials form input
    if (subscription_id == null || subscription_id == "" && client_id == null || client_id == "" && key == null || key == "" && tenant_id == null || tenant_id == "") {
        if (input_clone.hasOwnProperty('subscription_id') && input_clone.hasOwnProperty('client_id') && input_clone.hasOwnProperty('tenant_id') && input_clone.hasOwnProperty('key')) {
            log.trace("Azure credentials are given in input")

            subscription_id = input.get('subscription_id')
            client_id = input.get('client_id')
            key = input.get('key')
            tenant_id = input.get('tenant_id')

            log.trace("Credentials taken from input")
            log.trace("Subscription ID : " + subscription_id)
            log.trace("Client ID : " + client_id)
            log.trace("Key : " + key)
            log.trace("Tenant ID : " + tenant_id)
        }
    }

    // Resource Group Name
    resource_group_name = input.get('resource_group_name')
    log.trace('Resource Group Name is ' + resource_group_name)

    // Deployment Name
    deployment_name = input.get('deployment_name')
    log.trace("Deployment name is " + deployment_name)

    // ARM Template
    arm_template = null
    if (input_clone.hasOwnProperty('arm_template')) {
        log.trace("ARM Template is present")
        arm_template = input.get('arm_template')
        if (typeof arm_template == "object") {
            log.trace("ARM template is given as JSON")
        } else if (typeof arm_template == "string") {
            arm_template = util.json(arm_template)
            log.trace("String ARM template converted to JSON")
        }

        // Print out ARM template
        log.debug("ARM Template :: \n" + arm_template)
        log.trace("Calling azure connector")

        connector_request = call.connector("msazure")
            .set('action', 'create-arm-stack')
            .set('client-id', client_id)
            .set('subscription-id', subscription_id)
            .set('tenant-id', tenant_id)
            .set('key', key)
            .set('deployment-name', deployment_name)
            .set('arm-template', arm_template)
            .set('resource-group-name', resource_group_name)
            .timeout(3000000)

        // ARM Parmeters
        template_parameters = null
        if (input_clone.hasOwnProperty('template_parameters')) {
            template_parameters = input.get('template_parameters')

            if (typeof template_parameters == "object") {
                log.trace("Template paramters are given as JSON")
                log.trace(template_parameters)
                connector_request.set('template-parameters', template_parameters)
            } else if (typeof template_parameters == "string") {
                log.trace("Template parameters are given as string. Converting..")
                template_parameters = util.json(template_parameters)
                connector_request.set('template-parameters', template_parameters)
            }
        } else {
            log.info("Template parameters are not given")
        }

        // Make connector request
        connector_response = connector_request.sync()

        // Exitcode
        exit_code = connector_response.exitcode()
        message = connector_response.message()

        if (exit_code == 0) {
            log.trace("Exitcode is " + exit_code)
            log.trace("Connector Response :: " + connector_response)
            log.trace("Success Message :: " + message)
            output.set("exit-code", 0).set("message", message).set("user_message", message)
        } else {
            log.error("Exitcode is " + exit_code)
            log.error("Error Message :: " + message)
            output.set("exit-code", -1).set("error", message).set("user_message", message)
        }

    } else {
        log.error("Please provide Azure ARM template")
    }

} else {
    log.error("Please provide credentials for Azure.")
}

log.trace("Finished executing flintbit 'fb-cloud:azure:operation:arm-templates:deploy_arm_template.js' flintbit")