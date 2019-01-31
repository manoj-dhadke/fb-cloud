/**
** Author: Anurag
** Creation Date: 7th January 2019
** Summary: GCP Create Disk Snapshot Action flintbit. 
** Description: This flintbit is developed to create disk snapshot from a disk.
**/

log.info("Started executing fb-cloud:google-cloud:operation:create_disk_snapshot.js flintbit")
try {
  
    service_account_credentials = input.get('service-account-credentials')
    project_id = input.get('project-id')
    action = 'create-disk-snapshot'
    connector_name = input.get('connector-name')
    zone_name = input.get('zone-name')
    source_disk_name = input.get('source-disk-name')
    snapshot_name = input.get('snapshot-name')
    log.info("=====================>>>>>>>>>>>>>>>>>>>>>")
    // Winrm Commonconnect Call
    response = call.connector(connector_name)
                    .set('service-account-credentials', service_account_credentials)
                    .set('action', action)
                    .set('zone-name', zone_name)
                    .set('project-id', project_id)
                    .set('snapshot-name',snapshot_name)
                    .set('source-disk-name', source_disk_name)
                    .timeout(60000)
                    .sync()
                    
    log.trace("Response: "+response)

    // google-cloud Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0){
        log.info("SUCCESS in executing "+connector_name +" where, exitcode : "+response_exitcode +"| message : " + response_message)
        output.set('exit-code', 0).set('message', response_message).set('snapshot-details',response.get('operation-details'))
    }
    else{
        log.error("ERROR in executing "+connector_name +" where, exitcode : "+response_exitcode +"| message : " + response_message)
        response=response.toString()
        if (response !=""){
        output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.toString())
        }
        else{
        output.set('message', response_message).set('exit-code', 1)
        }
    }    
   // output.set('result', response.get('operation-details'))

} catch(error){
    log.trace(error)
    output.set('error', error)
}
log.trace("Finished executing create_disk_snapshot.js flintbit")

/**
 * 
 *error reading service account credential from stream, expecting  'client_id', 'client_email', 'private_key' and 'private_key_id'.
 */