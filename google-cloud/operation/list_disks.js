/**
** Author: Anurag 
** Creation Date: 1st January 2019
** Summary: This is a GCP Connector Disks List Action flintbit. 
** Description: This flintbit is developed to get disks list using GCP Connector.
**/

log.info("Started executing fb-cloud:gcp_list_disks.js flintbit ====="+ input)
try {
  
    service_account_credentials = input.get('service-account-credentials')
    project_id = input.get('project-id')
    action = input.get('action')
    connector_name = input.get('connector-name')
    zone_name = input.get('zone-name')
  
    // GCP connector call
    response = call.connector(connector_name)
                    .set('service-account-credentials', service_account_credentials)
                    .set('action', action)
                    .set('zone-name', zone_name)
                    .set('project-id', project_id)
                    .timeout(60000)
                    .sync()
                    
    log.trace("Response: "+response)

    output.set('result', response.get('disk-list')).set("exit-code", 0)

} catch(error){
    log.trace(error)
    output.set('error', error)
}
log.trace("Finished executing gcp_list_disks.js flintbit")

/**
 * 
 *rror reading service account credential from stream, expecting  'client_id', 'client_email', 'private_key' and 'private_key_id'.
 */
