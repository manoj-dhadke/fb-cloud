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
log.trace("Started executing 'fb-cloud:openstack:operation:snapshot_instance.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    //Mandatory
    connector_name = input.get('connector_name')
    action = 'create-snapshot'
    serverId = input.get('server-id')
    snapshotname = input.get('snapshot-name')
    protocol = input.get('protocol')
    target = input.get('target')
    port = input.get('port')
    version = input.get('version')
    domain_id = input.get('domain-id')
    username = input.get('username')
    password = input.get('password')
    project_id = input.get('project-id')
    request_timeout = input.get('timeout')
   

    log.info("Flintbit input parameters are, action : ${action} | serverId : ${serverId} | snapshotname : ${snapshotname}")
    

    if (connector_name== null || connector_name == ""){
       throw 'Please provide "openstack connector name (connector_name)" to create snapshot of the vm'
    }
        
  
    if (domain_id == null || domain_id == "")
    {
        throw 'Please provide "openstack domain id (domain_id)"  to start instance'

    }

    if (project_id == null || project_id == "")
    {
        throw 'Please provide "openstack Project ID (project_id)" to start instance'

    }  

    if (target == null || target == "")
    {
        throw 'Please provide "openstack target (target)"  to start instance'

    }

    if (username == null || username == "")
    {
        throw 'Please provide "openstack username (username)" to start instance'

    }

    if (password == null || password == "")
    {
        throw 'Please provide "openstack password (password)"  to start instance'

    }
    if (serverId == null || serverId == ""){
        throw 'Please provide "openstack server ID (server-id)" to create snapshot of the vm'

    }

    if (snapshotname == null || snapshotname == ""){
       throw 'Please provide "openstack snapshot name (snapshot-name)" to create snapshot of the vm'

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
                          .set('server-id', serverId)
                          .set('snapshot-name', snapshotname)
                          .set('project-id',project_id)
                          .set("timeout",60000)
                          .sync()
 
    response_exitcode = connector_call.exitcode()
    response_message = connector_call.message()

    log.info("RESPONSE "+connector_call.toString())

    image_id = connector_call.get('imageid')

    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message',response_message)

    }
        
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)

    }
        
}
    catch (error) {
       log.error("Error message: " + error)
       output.set("exit-code", 1)
    }        

log.trace("Finished executing 'fb-cloud:openstack:operation:snapshot_instance.groovy' flintbit")
