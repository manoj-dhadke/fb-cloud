log.trace("Started executing 'fb-cloud:openstack:operation:rename_instance.groovy' flintbit...")
try{

    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'rename-instance'
    server_id = input.get('server-id')
    protocol = input.get('protocol')
    target = input.get('target')
    port = input.get('port')
    version = input.get('version')
    username = input.get('username')
    password = input.get('password')
    new_vm_name = input.get('new-vm-name')
    domain_id = input.get('domain-id')
    project_id = input.get('project-id')

    // optional  
    request_timeout = input.get('timeout')

    log.info("Flintbit input parameters are, action : ${action} | serverId : ${server_id}")
    

    if (connector_name == null || connector_name == "")
    {
        throw 'Please provide "openstack connector name (connector_name)" to rename server'

    }

    if (domain_id == null || domain_id == "")
    {
        throw 'Please provide "openstack domain ID (domain_id)" to rename server'

    }

    if (project_id == null || project_id == "")
    {
        throw 'Please provide "openstack Project ID (project_id)" to rename server'

    }

    if (target == null || target == "")
    {
        throw 'Please provide "openstack target (target)" to  rename server'

    }

    if (username == null || username == "")
    {
        throw 'Please provide "openstack username (username)" to  rename server'

    }

    if (password == null || password == "")
    {
        throw 'Please provide "openstack password (password)" to  rename server'

    }

    if (server_id == null || server_id == "")
    {
        throw 'Please provide "openstack server ID (server-id)" to rename server'

    }

    if (new_vm_name == null || new_vm_name == "")
    {
        throw 'Please provide "new-vm-name" to rename server'

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
                          .set('new-vm-name', new_vm_name)
                          .set('timeout', 60000)
                          .sync()
                          
    //connector_call response
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
log.trace("Finished executing 'fb-cloud:openstack:operation:rename_instance.groovy' flintbit")