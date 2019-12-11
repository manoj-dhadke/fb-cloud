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
log.trace("Started executing 'fb-cloud:azure:operation:create_disk.groovy' flintbit...")
try{
// Flintbit Input Parameters
    // Mandatory  
    connector_name = input.get('connector-name') //name of Azure connector
    action = 'create-disk' //Specifies the name of the operation: create-disk
    disk_name= input.get("data-disk-name") //name of the subnet which you want to create
    size_in_gb = input.get("size-in-gb")
    group_name = input.get("group-name")
    region = input.get("region")
    os_type = input.get("os-type")
    data_snapshot = input.get("data-snapshot")
    data_disk = input.get("data-disk")
    disk_snapshot = input.get("disk-snapshot")
    vhd_id = input.get("vhd-id")
    log.info("connector-name:${connector_name} | action :${action} | disk-name:${disk_name}")

    //optional
    key = input.get('key') //Azure accountid
    tenant_id = input.get('tenant-id') //Azure account tenant-id
    subscription_id = input.get('subscription-id') //Azure account subscription-id
    client_id = input.get('client-id') //Azure client-id
    request_timeout = input.get('timeout')	// Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

   //Checking that the connector name is provided or not,if not then throw exception with error message
   if (connector_name == null || connector_name == ""){
       throw new Exception ( 'Please provide "Azure connector name (connector_name)"')
    }

   //Checking that the dsik id is provided or not,if not then throw the exception with error message
    if (disk_name == null || disk_name == ""){
       throw new Exception ( 'Please provide "Disk Inamed"')
    }

        connector_call = call.connector(connector_name)
                            .set('action', action)
                            .set('tenant-id', tenant_id)
                            .set('subscription-id', subscription_id)
                            .set('key', key)
                            .set('client-id', client_id)
                            .set('data-disk-name',disk_name)
                            .set('group-name', group_name)
                            .set('size-in-gb', size_in_gb)
                            .set('region', region)
                            
     
    if( os_type != null || os_type instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.set('os-type', os_type)
     }
    if( data_snapshot != null || data_snapshot instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.set('data-snapshot', data_snapshot)
     }
    if( data_disk != null || data_disk instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.set('data-disk', data_disk)
     }   
    if( disk_snapshot != null || disk_snapshot instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.set('disk-snapshot', disk_snapshot)
     }
    if( vhd_id != null || vhd_id instanceof String ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.set('vhd-id', vhd_id)
     }
    if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    } else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    // MS-azure Connector Response Meta Parameters
    log.debug("==================>>>>>>>>>>>>>>>>>>>>>   ${response}")
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message', response_message).set('disk-details',response.get('disk-details'))
    } else {
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}catch (Exception  e){
    log.error(e.message)
    output.set('exit-code', -2).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure:operation:create_disk.groovy' flintbit")
