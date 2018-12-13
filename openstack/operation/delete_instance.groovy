log.trace("Started executing 'fb-cloud:openstack:operation:delete_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'delete-instance'
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

    log.info("Flintbit input parameters are, action : ${action} | server_id : ${server_id}")
    
    if (connector_name == null || connector_name == "")
    {
        throw 'Please provide "openstack connector name (connector_name)" to delete server'

    }

    if (domain_id == null || domain_id == "")
    {
       throw 'Please provide "openstack domain id (domain_id)" to  delete server'

    }

    if (target == null || target == "")
    {
        throw 'Please provide "openstack target (target)" to  delete server'

    }

    if (username == null || username == "")
    {
         throw 'Please provide "openstack username (username)" to  delete server'

    }

    if (password == null || password == "")
    {
         throw 'Please provide "openstack password (password)" to  delete server'

    }

    if (project_id == null || project_id == "")
    {
        throw 'Please provide "project id (project_id)" to delete server'

    }

    if (server_id == null || server_id == "")
    {
        throw 'Please provide "openstack server ID (serverid)" to delete server'

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

    response_exitcode = connector_call.exitcode()
    response_message = connector_call.message()

    log.info("RESPONSE ${connector_call}")

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
log.trace("Finished executing 'fb-cloud:openstack:operation:delete_instance.groovy' flintbit")

