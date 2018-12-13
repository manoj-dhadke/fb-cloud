log.trace("Started executing 'fb-cloud:openstack:operation:create_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    log.info("Input for create instance flintbit :: ${input}")
    // Mandatory Input Parameters
    connector_name = input.get('connector_name')
    action = 'create-instance'
    target = input.get('target')
    username = input.get('username')
    password = input.get('password')
    port = input.get('port')
    protocol = input.get('protocol')
    version = input.get('version')
    domain_id = input.get('domain-id')
    servername = input.get('server-name')
    flavorId = input.get('flavor-id')
    imageId = input.get('image-id')
    networkId = input.get('network-id')
    project_id = input.get('project-id')

    // optional
    request_timeout = input.get('timeout')
    

    log.info("Flintbit input parameters are, action : ${action} | servername : ${servername} | flavorid : ${flavorId} | imageid : ${imageId} | networkid : ${networkId}")
    log.info("Calling openstack Connector ::  ${connector_name}")

    if (connector_name == null || connector_name == "")
    {
        throw 'Please provide "openstack connector name (connector_name)" to create server'

    }
	
    if (project_id == null || project_id == "")
    {
        throw 'Please provide "project id (project_id)" to create server'

    }
   
    if (domain_id == null || domain_id == "")
    {
        throw 'Please provide "openstack domain id (domain_id)" to create server'

    }
    if (servername == null || servername == "")
    {
        throw 'Please provide "openstack server name (server-name)" to create server'

    }
   
    if (flavorId == null || flavorId == "")
    {
        raise 'Please provide "openstack flavor Id (flavor-id)" to create server'

    }

    if (imageId == null || imageId == "")
    {
        throw 'Please provide "openstack image Id (image-id)" to create server'

    }

    if (networkId == null || networkId == "")
    {
        throw 'Please provide "openstack network Id (network-id)" to create server'

    }

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('target', target)
                          .set('username', username)
                          .set('password', password)
                          .set('port', port)
                          .set('protocol', protocol)
                          .set('version', version)
                          .set('project-id', project_id)
                          .set('domain-id', domain_id)  
                          .set('server-name', servername) 
                          .set('flavor-id', flavorId)   
                          .set('image-id', imageId)                   
			              .set('network-id', networkId)
                          .set('timeout', 60000)
                          .sync()

    response_exitcode = connector_call.exitcode()
    response_message = connector_call.message()

    log.info("RESPONSE ${connector_call}")

    serverid = connector_call.get('id')
    log.info("Server Id:: ${serverid}")

    if (response_exitcode == 0)
    {
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message',response_message)
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
log.trace("Finished executing 'fb-cloud:openstack:operation:create_instance.groovy' flintbit")
