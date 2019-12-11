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
log.trace("Started execution 'fb-cloud:vmware-vcd:operation:list_virtual_machines.groovy' flintbit...") // execution Started
try{

    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name') // vmware-vcd connector name
    action ='list-vm' // name of action:list-vm
    hostname = input.get('host_name') // hostname of the vCloud server
    organization_name = input.get('organization_name') // name of the organization
    organization_admin_username = input.get('organization_admin_username') // organization admin username
    organization_admin_password = input.get('organization_admin_password') // organization admin password
    protocol = input.get('protocol') //protocol for the server i.e http/https

    // Optional
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    // checking connector name is nil or empty
    if(connector_name==null || connector_name==""){
        throw new Exception('Please provide "VMWare connector name (connector_name)" to list virtual machines')
    }
  
    // checking host name is nil or empty
    if(hostname==null || hostname==""){
        throw new Exception('Please provide "vCloud director server hostname(host-name)" to list virtual machines')
    }
	
    // checking organization name is nil or empty
    if(organization_name==null || organization_name==""){
        throw new Exception('Please provide "organization name (organization-name)" to list virtual machines')
    }
  
    // checking organization admin username is nil or empty
    if(organization_admin_username==null || organization_admin_username==""){
        throw new Exception('Please provide "Organzation admin username (Organzation-admin-username)" to list virtual machines')
    }
   
    // checking organization admin password is nil or empty
    if(organization_admin_password==null || organization_admin_password==""){
        throw new Exception('Please provide "Organzation admin password (Organzation-admin-password)" to list virtual machines')
    }

    // checking protocol is nil or empty
    if(protocol==null || protocol==""){
        throw new Exception('Please provide "protocol (protocol)" to list virtual machines')
    }

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('host-name', hostname)
                          .set('organization-name', organization_name)
                          .set('organization-admin-username', organization_admin_username)
			  .set('organization-admin-password', organization_admin_password)
			  .set('protocol',protocol)

    if(request_timeout==null || (request_timeout instanceof String)){
        log.trace("Calling ${connector_name} with default timeout...")
        // calling vmware-vcd connector
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        // calling vmware-vcd connector
        response = connector_call.timeout(request_timeout).sync()
    }

    // vmware-vcd Connector Response Meta Parameters
    response_exitcode = response.exitcode() // Exit status code
    response_message =  response.message() // Execution status message

    if(response_exitcode == 0){
        vm_list=response.get('vm-list')
	    log.info("--------vm list--------${vm_list}")
        log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('result',vm_list).set('exit-code', 0).set('message',response_message)
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
        output.set('message', response_message.toString()).set('exit-code', -1)

    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', -1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:vmware-vcd:operation:list_virtual_machines.groovy' flintbit...")
// end