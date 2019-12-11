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
log.trace("Started executing 'fb-cloud:azure:operation:create_snapshot_of_vhd.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'create-snapshot-of-vhd'
    snapshot_name = input.get('snapshot-name')
    group_name = input.get('group-name')
    region = input.get('region')
    vhdURI = input.get('os-disk-vhd-uri')
    snapshot_sku = input.get('snapshot-sku')
    snapshot_size_in_gb = input.get('snapshot-size-in-gb')
    
    // Optional
    request_timeout = 300000
    key = input.get('key')
    tenant_id = input.get('tenant-id')
    subscription_id = input.get('subscription-id')
    client_id = input.get('client-id')

    log.info("Flintbit input parameters are,connector_name: ${connector_name}"+ 
                                            "| Action : ${action} "+
                                            "| Group name : ${group_name} "+
                                            "| Snapshot Name : ${snapshot_name}"+ 
                                            "| Tenant Id : ${tenant_id} "+
                                            "| Subscription Id : ${subscription_id} "+ 
                                            "| key : ${key} "+
                                            "| Client Id : ${client_id}")

    connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('key', key)
                          .set('client-id', client_id)
                          .set('snapshot-name',snapshot_name)
                          .set('resource-group',group_name)
                          .set('region',region)
                          .set('os-disk-vhd-uri',vhdURI)                    

    if (connector_name == null || connector_name == ""){
        throw new Exception ('Please provide "MS Azure connector name (connector_name)" to take snapshot')
    }

    if (snapshot_name == null || snapshot_name == ""){
        throw new Exception ('Please provide "MS Azure snapshot name (snapshot-name)" to take snapshot')
    }

    if (group_name == null || group_name == ""){
        throw new Exception ('Please provide "MS Azure group name (group-name)" to take snapshot')
    }

    if (region == null || region == ""){
        throw new Exception ('Please provide "MS Azure group name (region)" to take snapshot')
    }

    if (vhdURI == null || vhdURI == ""){
        throw new Exception ('Please provide "MS Azure group name (os-disk-vhd-uri)" to take snapshot')
    }

    if (snapshot_sku != null && snapshot_sku != ''){
        log.info("setting snapshot_sku to "+snapshot_sku)
        connector_call.set('snapshot-sku',snapshot_sku)
    } 

    if (snapshot_size_in_gb != null && snapshot_size_in_gb > 0){
        log.info("setting snapshot-size-in-gb to "+snapshot_size_in_gb)
        connector_call.set('snapshot-size-in-gb',snapshot_size_in_gb)
    }

    if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages
    log.info("REsponse | "+response)
    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message', response_message).set('snapshot-details',response.get('snapshot-details'))
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch(Exception e){ 
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure:operation:create_snapshot_of_vhd.groovy' flintbit")
// end
