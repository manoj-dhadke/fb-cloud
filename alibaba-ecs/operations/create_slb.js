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

log.trace("Started executing fb-cloud:alibaba-ecs:operations:create_slb.js flintbit")

log.trace("Inputs :: " + input)

action = "create-load-balancer"
connector_name = "alibaba-cloud"
access_key = input.get('access-key')
access_key_secret = input.get('access-key-secret')
region = input.get('region')
ip_address_version = input.get('ip-address-version')
ip_address_type = input.get('ip-address-type')
load_balancer_name = input.get('load-balancer-name')

new_input = JSON.parse(input)

connector_call_response = call.connector(connector_name)
    .set('action', action)
    .set('access-key', access_key)
    .set('access-key-secret', access_key_secret)
    .set('region', region)
    .set('ip-address-version', ip_address_version)
    .set('ip-address-type', ip_address_type)
    .set('load-balancer-name', load_balancer_name)

// Optional Fields
if (new_input.hasOwnProperty('load-balancer-spec')) {
    connector_call_response.set('load-balancer-spec', input.get('load-balancer-spec'))
}
if (new_input.hasOwnProperty('vswitch-id')) {
    connector_call_response.set('vswitch-id', input.get('vswitch-id'))
}
if (new_input.hasOwnProperty('vpc-id')) {
    connector_call_response.set('vpc-id', input.get('vpc-id'))
}
if (new_input.hasOwnProperty('resource-group-id')) {
    connector_call_response.set('resource-group-id', input.get('resource-group-id'))
}
if (new_input.hasOwnProperty('slave-zone-id')) {
    connector_call_response.set('slave-zone-id', input.get('slave-zone-id'))
}
if (new_input.hasOwnProperty('pay-type')) {
    connector_call_response.set('pay-type', input.get('pay-type'))
}

connector_call_response.timeout(120000)
call = connector_call_response.sync()

log.trace("Connector call response : " + call)
exit_code = call.exitcode()
message = call.message()

log.trace("Message :: " + message)

if (exit_code == 0) {
    log.trace("Create Server Load Balancer Response :: \n" + call.get('load-balancer'))
    output.set('user_message', call.get('load-balancer'))
    output.set('result', call.get('load-balancer'))
    output.set('message', message)
    output.set('exit-code', 0)
} else {
    log.error("Exitcode is " + exit_code+"\n Error Message:: "+message)
    output.set('message', message)
    output.set('user_message', message)
    output.set('exit-code', exit_code)
}

log.trace("Finished executing fb-cloud:alibaba-ecs:operations:create_slb.js flintbit")
