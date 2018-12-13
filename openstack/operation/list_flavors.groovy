/**
** Creation Date: 6th December 2018
** Summary: This is Openstack List Flavors flintbit.
** Description: This flintbit is developed to list openstack flavorss using Openstack connector.
**/
log.trace("Started executing 'fb-cloud:openstack:operation:list_flavors.groovy' flintbit...")
try{
     // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'list-flavors'
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
    
    if (connector_name == null || connector_name == "")
    {
        throw 'Please provide "openstack connector name (connector_name)" to list flavors'
    }
    if (domain_id == null || domain_id == "")
    {
        throw 'Please provide "openstack domain id (domain_id)" to list flavors'
    }
    if (project_id == null || project_id == "")
    {
        throw 'Please provide "openstack project id (project_id)" to list flavors'
    }
    if (target == null || target == "")
    {
        throw 'Please provide "openstack target (target)" to list flavors'
    }
    if (username == null || username == "")
    {
        throw 'Please provide "openstack username (username)"to list flavors'
    }
    if (password == null || password == "")
    {
        throw 'Please provide "openstack password (password)" to list flavors'
    }

    connector_call = call.connector(connector_name)
			  .set('action', action)
 			  .set('protocol', protocol)
			  .set('target', target)
			  .set('password', password)
			  .set('domain-id', domain_id)
			  .set('port', port)
			  .set('version', version)
			  .set('username', username)
			  .set('project-id', project_id)
              .set('timeout', 60000)
              .sync()

    //fetching connector_call response
    response_exitcode = connector_call.exitcode()
    response_message = connector_call.message()
    flavor_list=connector_call.get('flavor-list')
    if (response_exitcode == 0)
    {
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message',response_message).set('flavor-list',flavor_list)
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch (error) {
    log.error("Error message: " + error)
    output.set("exit-code", 1)
}
log.trace("Finished executing 'fb-cloud:openstack:operation:list_flavors.groovy' flintbit")