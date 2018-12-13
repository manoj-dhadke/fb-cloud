log.trace("Started executing 'fb-cloud:openstack:operation:disassociate_floating_ip.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'disassociate-floating-ip'
    serverId = input.get('server-id')
    floating_ip = input.get('floating-ip')
    protocol = input.get('protocol')
    target = input.get('target')
    port = input.get('port')
    version = input.get('version')
    domain_id = input.get('domain-id')
    username = input.get('username')
    password = input.get('password')
    project_id = input.get('project-id')

    //Optional
    request_timeout = input.get('timeout')
   

    log.info("Flintbit input parameters are, action : ${action} | serverId : ${serverId} | floating-ip : ${floating_ip }")                     

    if (connector_name == null || connector_name == "")
    {
        throw 'Please provide "openstack connector name (connector_name)" to disassociate floating ip from the server'

    }
  
    if (domain_id == null || domain_id == "")
    {
        throw 'Please provide "openstack domain id (domain_id)"  to disassociate floating ip from the server'

    }
    

    if (project_id == null || project_id == "")
    {
        throw 'Please provide "project id (project_id)"  to disassociate floating ip from the server'

    }
    
     if (target == null || target == "")
     {
        throw 'Please provide "openstack target (target)" to disassociate floatin ip from the server'

     }

     if (username == null || username == "")
     {
        throw 'Please provide "openstack username (username)" to disassociate floating ip from the server'

     }

    if (password == null || password == "")
    {
        throw 'Please provide "openstack password (password)"  to disassociate floating ip from the server'

    }
    
    if (serverId == null || serverId == "")
    {
        throw 'Please provide "openstack server ID (server-id)" to disassociate floating ip from the server'

    }
    if (floating_ip == null || floating_ip == "")
    {
        throw 'Please provide "openstack floating ip (floating-ip)" to disassociate floating ip from the server'

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
                          .set('server-id', serverId)
                          .set('floating-ip', floating_ip)
                          .set('timeout',60000)
                          .sync()
                          
    response_exitcode = connector_call.exitcode()
    response_message = connector_call.message()


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
log.trace("Finished executing 'fb-cloud:openstack:operation:disassociate_floating_ip.groovy' flintbit")

