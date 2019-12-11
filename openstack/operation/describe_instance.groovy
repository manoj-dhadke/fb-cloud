/*************************************************************************
 * 
 * INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
 * __________________
 * 
 * (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
 * All Rights Reserved.
 * Product / Project: Flint IT Automation Platform
 * NOTICE:  All information contained herein is, and remains
 * the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
 * The intellectual and technical concepts contained
 * herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
 * Dissemination of this information or any form of reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
 */
log.trace("Started executing 'fb-cloud:openstack:operation:describe_instance.groovy' flintbit...")
    // Flintbit Input Parameters
    // Mandatory
    try{
    connector_name = input.get('connector_name')
    action = 'describe-server'
    serverId = input.get('server-id')
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
        throw 'Please provide "openstack connector name (connector_name)" to describe instance'
    }
    if (domain_id == null || domain_id == "")
    {
        throw 'Please provide "openstack domain id (domain_id)"  to describe instance'
    }
    if (project_id == null || project_id == "")
    {
        throw 'Please provide "openstack project id (project_id)"  to describe instance'
    }
    if (target == null || target == "")
    {
        throw 'Please provide "openstack target (target)"  to describe instance'
    }
    if (username == null || username == "")
    {
        throw 'Please provide "openstack username (username)" to describe instance'
    }
    if (password == null || password == "")
    {
        throw 'Please provide "openstack password (@password)"  to describe instance'
    }
    if (serverId == null || serverId == "")
    {
        throw 'Please provide "openstack server-id (serverId)"  to describe instance'
    }
    //fetching connector_call response 
    connector_call = call.connector(connector_name)
			  .set('action', action)
 			  .set('protocol', protocol)
			  .set('target', target)
			  .set('password', password)
			  .set('port', port)
			  .set('version', version)
			  .set('username', username)
              .set('domain-id', domain_id)
              .set('project-id', project_id)
              .set('server-id',serverId)
              .set('timeout', 60000)
              .sync()
              
    response_exitcode = connector_call.exitcode()
    response_message = connector_call.message()
    instance_info=connector_call.get('instance-info')
    if (response_exitcode == 0)
    {
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message',response_message).set('instance-info',instance_info)
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch (error) {
    log.error("Error message: " + error)
    output.set("exit-code", 1)
}
log.trace("Finished executing 'fb-cloud:openstack:operation:describe_instance.groovy' flintbit")