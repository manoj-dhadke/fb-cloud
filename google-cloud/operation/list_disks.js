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
