log.trace("Started executing 'fb-cloud:openstack:operation:suspend_instance.groovy' flintbit...")
try{

    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'suspend-instance'
    server_id = input.get('server-id')
    protocol = input.get('protocol')
    target = input.get('target')
    port = input.get('port')
    version = input.get('version')
    username = input.get('username')
    password = input.get('password')
    domain_id = input.get('domain-id')
    project_id = input.get('project-id')

    //optional
    request_timeout = input.get('timeout')

    log.info("Flintbit input parameters are, action : ${action} | serverId : ${server_id} | target : ${target} | username : ${username} | password: ${password} | ${domain_id} | port: ${port} | version : ${version}")

    if (connector_name == null || connector_name == "")
    {
        throw 'Please provide "openstack connector name (connector_name)" to suspend instance'

    }

    if (domain_id == null || domain_id == " ")
    {
        throw 'Please provide "openstack domain ID (domain_id)" to suspend instance'

    }

    if (project_id == null || project_id == "")
    {
        throw 'Please provide "openstack Project ID (project_id)" to suspend instance'

    }

    if (target == null || target == "")
    {
        throw 'Please provide "openstack target (target)" to suspend instance'

    }

    if (username == null || username == "")
    {
        throw 'Please provide "openstack username (username)" to suspend instance'

    }

    if (password == null || password == "")
    {
        throw 'Please provide "openstack password (password)" to suspend instance'

    }

    if (server_id == null || server_id == "")
    {
        throw 'Please provide "openstack Server ID (server_id)" to suspend instance'

    }

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('protocol', protocol)
                          .set('username', username)
                          .set('password', password)
                          .set('domain-id', domain_id)
                          .set('target', target)
                          .set('port', port)
                          .set('version', version)
                          .set('project-id', project_id)
                          .set('server-id', server_id)
                          .set('timeout', 60000)
                          .sync()
                          
    //connector_call response
    response_exitcode = connector_call.exitcode()
    response_message = connector_call.message()

    log.info("RESPONSE  ${connector_call.toString()}")

    if (response_exitcode == 0)
    {
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message', response_message)
    }
    else
    {
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
    }
    catch (error) {
    log.error("Error message: " + error)
    output.set("exit-code", 1)
}
log.trace("Finished executing 'fb-cloud:openstack:operation:suspend_instance.groovy' flintbit")