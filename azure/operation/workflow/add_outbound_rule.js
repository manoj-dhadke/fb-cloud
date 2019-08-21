log.trace("Started executing 'fb-cloud:azure:operation:add_outbound_rule.js' flintbit...")

// Flintbit Input Parameters
// Mandatory
connector_name = input.get('connector_name') // name of Azure connector
action = 'add-outbound-rule' // Specifies the name of the operation: add - outbound - rule
security_group_name = input.get('security-group-name') // please provide firewall name
resource_group_name = input.get('group-name')
rule = input.get('rule')

// optional
from_address = input.get('from-address')
to_address = input.get('to-address')
to_port = input.get('to-port')
from_port = input.get('from-port')
protocol = input.get('protocol')
priority = input.get('priority')
description = input.get('description')
key = input.get('key') // Azure account key
tenant_id = input.get('tenant-id') // Azure account tenant - id
subscription_id = input.get('subscription-id') // Azure account subscription - id
client_id = input.get('client-id') // Azure client - id
request_timeout = input.get('request-timeout')

// Checking that the connector name is provided or not,if not then log.error(the exception with error message
if (connector_name == null && connector_name == "") {
    log.error('Please provide "MS Azure connector name connector_name')
}

if (security_group_name == null && security_group_name == "") {
    log.error('Please provide security_group_name')
}

if (resource_group_name == null && resource_group_name == "") {
    log.error('Please provide resource_group_name')
}
if (rule == null && rule == "") {
    log.error("Rule name is not specified")
}

connector_call = call.connector(connector_name)
    .set('action', action)
    .set('tenant-id', tenant_id)
    .set('subscription-id', subscription_id)
    .set('key', key)
    .set('client-id', client_id)
    .set('security-group-name', security_group_name)
    .set('group-name', resource_group_name)
    .set('rule', rule)
    .set('from-address', from_address)
    .set('to-address', to_address)
    .set('from-port', from_port)
    .set('to-port', to_port)
    .set('protocol', protocol)
    .set('priority', priority)
    .set('description', description)

if (request_timeout == null) {
    log.trace("Calling " + connector_name + " with default timeout...")
    response = connector_call.sync()
}
else {
    log.trace("Calling " + connector_name + " with given timeout request_timeout...")
    response = connector_call.timeout(request_timeout).sync()
}

//MS-azure Connector Response Meta Parameters
response_exitcode = response.exitcode()	// Exit status code
response_message = response.message()	// Execution status messages

if (response_exitcode == 0) {
    log.info("SUCCESS in executing " + connector_name + " where, exitcode : " + response_exitcode + " | message : " + response_message)
    log.info(response)
    output.set('exit-code', 0).set('message', response_message)
} else {
    log.error("ERROR in executing " + connector_name + " where, exitcode : " + response_exitcode + " | message : " + response_message)
    output.set('exit-code', 1).set('message', response_message)
}

log.trace("Finished executing 'fb-cloud:azure:operation:add_outbound_rule.rb' flintbit")

