log.trace("Started executing 'fb-cloud:azure:operation:add_inbound_rule.js' flintbit...")

// Flintbit Input Parameters
// Mandatory
connector_name = 'msazure'
action = 'add-inbound-rule' // Specifies the name of the operation:add-inbound-rule
security_group_name = input.get('security-group-name') // please provide firewall name
resource_group_name = input.get('group-name')
rule = input.get('rule')

// Optional
// Add inbound rules to specified addresses, e.g. 10.0.0.1 - 10.0.0.15,
from_address = input.get('from-address')
to_address = input.get('to-address')
// Port range
to_port = input.get('to-port')
from_port = input.get('from-port')
// TCp or UDP or ICMP or ANY
protocol = input.get('protocol')
// Azure priority value range 100-65000  
priority = input.get('priority')
// Firewall description
description = input.get('description')

request_timeout = input.get('request-timeout')
input_clone = JSON.parse(input)
if (input_clone.hasOwnProperty('cloud_connection')) {

    // Get credentials
    encryptedCredentials = input.get('cloud_connection').get('encryptedCredentials')

    key = encryptedCredentials.get('key')
    tenant_id = encryptedCredentials.get('tenant_id')
    subscription_id = encryptedCredentials.get('subscription_id')
    client_id = encryptedCredentials.get('client_id')

    // Checking that the connector name is provided or not,if not then raise the exception with error message
    if (connector_name == null || connector_name == "") {
        log.error("Please provide MS Azure connector name")
    }

    if (security_group_name == null || security_group_name == "") {
        log.error("Please provide security_group_id")
    }

    if (resource_group_name == null || resource_group_name == "") {
        log.error("Please provide resource_group_name")
    }

    // Checking that the connector name is provided or not,if not then raise the exception with error message
    if (rule != null || rule != "") {

        log.debug("Input variables | from address : " + from_address +
            "| to address : " + to_address +
            "| firewall Id : " + security_group_name +
            "| group : " + resource_group_name +
            "| rule name : " + rule +
            "| to port : " + to_port +
            "| from port : " + from_port +
            "| protocol : " + protocol +
            "| priority : " + priority)

        log.trace("Calling msazure connector")

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
            log.trace("Calling #{connector_name} with default timeout...")
            response = connector_call.sync()
        } else {
            log.trace("Calling " + connector_name + " with given timeout " + request_timeout + "...")
            response = connector_call.timeout(request_timeout).sync()
        }

        // MS - azure Connector Response Meta Parameters
        response_exitcode = response.exitcode()	// Exit status code
        response_message = response.message()	// Execution status messages

        if (response_exitcode == 0) {
            log.info("SUCCESS in executing #{connector_name} where, exitcode : " + response_exitcode + " | message :" + response_message)
            log.info("Connector response: " + response)
            output.set('exit-code', 0).set('message', response_message)
        } else {
            log.error("ERROR in executing " + connector_name + " where, exitcode : " + response_exitcode + " | message : " + response_message)
            log.info("Connector error response: " + response)
            output.set('exit-code', 1).set('message', response_message)
        }

    } else {
        log.error("Please specify inbound rule name to add")
        output.set('exit-code', -1).set('message', response_message)
    }
} else {
    log.error("Please provide Azure credentials")
    output.set("error", "Please provide Azure connection credentials")
}
log.trace("Finished executing 'fb-cloud:azure:operation:add_inbound_rule.js' flintbit")
