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

log.trace("Started executing fb-cloud:google_connect.js flintbit")
try {

    service_account_credentials = input.get('service-account-credentials')
    project_id = input.get('project-id')
    action = 'insert-disk'
    connector_name = input.get('connector-name')
    zone_name = input.get('zone-name')
    disk_type = input.get('disk-type')
    disk_size_gb = input.get('disk-size-gb')
    disk_name = input.get('disk-name')
    disk_source_image = input.get('disk-source-image')



    // Winrm Commonconnect Call
    response = call.connector(connector_name)
        .set('service-account-credentials', service_account_credentials)
        .set('action', action)
        .set('zone-name', zone_name)
        .set('project-id', project_id)
        .set('disk-type', disk_type)
        .set('disk-size-gb', disk_size_gb)
        .set('disk-name', disk_name)
        .set('disk-source-image', disk_source_image)
        .timeout(60000)
        .sync()

    log.trace("Response: " + response)

    // google-cloud Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0) {
        log.info("SUCCESS in executing " + connector_name + " where, exitcode : " + response_exitcode + "| message : " + response_message)
        output.set('exit-code', 0).set('message', response_message).set('disk-details', response.get('operation-details'))
    }
    else {
        log.error("ERROR in executing " + connector_name + " where, exitcode : " + response_exitcode + "| message : " + response_message)
        response = response.toString()
        if (response != "") {
            output.set('message', response_message).set('exit-code', 1).setraw('error-details', response.toString())
        }
        else {
            output.set('message', response_message).set('exit-code', 1)
        }
    }
    //output.set('result', response.get('disk'))

} catch (error) {
    log.trace(error)
    output.set('error', error)
}
log.trace("Finished executing google_connect.js flintbit")

/**
 *
 *error reading service account credential from stream, expecting  'client_id', 'client_email', 'private_key' and 'private_key_id'.
 */
