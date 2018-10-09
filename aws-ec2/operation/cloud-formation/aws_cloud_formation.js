

log.trace("Started executing example:aws_cloud_formation.js flintbit")
try {

    log.trace("All Inputs to this flintbits are : " + input)
    // From service config
    stack_type = input.get('lamp-stack-config').get('stack-type')
    action = input.get('lamp-stack-config').get('action')
    connector_name = input.get('lamp-stack-config').get('connector-name')

    switch (stack_type) {
        case "LAMP":
            log.trace("In LAMP case")
            switch (action) {
                case "create-cloud-formation-stack":
                    // Create Stack case
                    log.trace("LAMP case -> create-cloud-formation-stack sub-case.")

                    // From Service form    
                    stack_name = input.get('stack_name')
                    region = input.get('region')
                    stack_formation_timeout = input.get('timeout')
                    keyname = input.get('key_name')
                    template_body = input.get('stack-template-body')
                    db_name = input.get('db_name')
                    db_user = input.get('db_user')
                    db_password = input.get('db_password')
                    db_root_password = input.get('db_root_password')

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
                        .timeout(stack_formation_timeout)
                        .sync()

                    log.trace(connector_response)

                    exit_code = connector_response.get("exit-code")
                    if (exit_code == 0) {
                        log.trace("Connector call done")
                        log.trace("Response is :" + connector_response)
                        output.set(connector_response)
                    }
                    else {
                        log.trace("Connector call failed with exit-code : " + exit_code)
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
                                             .sync()
                    
                    log.trace(connector_response)


                    break;
            }
    }
} catch (error) {
    log.error(error)
}



