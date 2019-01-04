log.trace("Started executing example:create_instance.js flintbit")

try {
    log.trace("Inputs :: " + input)

    
    action = input.get('action')
    connector_name = input.get('connector-name')
    //access_key = input.get('access-key')
    //access_key_secret = input.get('access-key-secret')
    region = input.get('region')
    image_id = input.get('image-id')
    security_group_id = input.get('security-group-id')
    instance_type = input.get('instance-type')
    vswitch_id = input.get('vswitch-id')

    new_input = JSON.parse(input)

    connector_call_response = call.connector(connector_name)
        .set('action', action)
        //.set('access-key', access_key)
        //.set('access-key-secret', access_key_secret)
        .set('region', region)
        .set('image-id', image_id)
        .set('security-group-id', security_group_id)
        .set('instance-type', instance_type)
        .set('vswitch-id', vswitch_id)


    // Optional Fields
    if (new_input.hasOwnProperty('system-disk-category')) {
        connector_call_response.set('system-disk-category', input.get('system-disk-category'))
    }
    if (new_input.hasOwnProperty('system-disk-size')) {
        connector_call_response.set('system-disk-size', input.get('system-disk-size'))
    }
    if (new_input.hasOwnProperty('instance-charge-type')) {
        connector_call_response.set('instance-charge-type', input.get('instance-charge-type'))
    }
    if (new_input.hasOwnProperty('is-deletion-protection')) {
        connector_call_response.set('is-deletion-protection', input.get('is-deletion-protection'))
    }
    if (new_input.hasOwnProperty('instance-description')) {
        connector_call_response.set('instance-description', input.get('instance-description'))
    }
    if (new_input.hasOwnProperty('instance-password')) {
        connector_call_response.set('instance-password', input.get('instance-password'))
    }
    if (new_input.hasOwnProperty('resource-group-id')) {
        connector_call_response.set('resource-group-id', input.get('resource-group-id'))
    }
    if (new_input.hasOwnProperty('system-disk-description')) {
        connector_call_response.set('system-disk-description', input.get('system-disk-description'))
    }
    if (new_input.hasOwnProperty('system-disk-name')) {
        connector_call_response.set('system-disk-name', input.get('system-disk-name'))
    }
    if (new_input.hasOwnProperty('is-auto-renew')) {
        connector_call_response.set('is-auto-renew', input.get('is-auto-renew'))
    }
    if (new_input.hasOwnProperty('security-enhancement-strategy')) {
        connector_call_response.set('security-enhancement-strategy', input.get('security-enhancement-strategy'))
    }
    if (new_input.hasOwnProperty('auto-renew-period')) {
        connector_call_response.set('auto-renew-period', input.get('auto-renew-period'))
    }
    if (new_input.hasOwnProperty('host-name')) {
        connector_call_response.set('host-name', input.get('host-name'))
    }
    if (new_input.hasOwnProperty('io-optimized')) {
        connector_call_response.set('io-optimized', input.get('io-optimized'))
    }
    if (new_input.hasOwnProperty('tags')) {
        connector_call_response.set('tags', input.get('tags'))
    }
    if (new_input.hasOwnProperty('vlan-id')) {
        connector_call_response.set('vlan-id', input.get('vlan-id'))
    }

    connector_call_response.timeout(120000)
    call = connector_call_response.sync()

    log.trace("Connector call response : " + call)
    exit_code = call.exitcode()

    if (exit_code == 0) {
        log.trace("Create Instance Response :: \n" + call)
        // output.set('user_message', call)
        output.set('result', call.toString())
        // output.set('exit-code', 0)
    }

} catch (error) {
    log.trace("Error Message :: " + error)
    output.set('user_message', error)
    output.set('result', error)

    output.set('exit-code', -1)
}

log.trace("Finished executing example:create_instance.js flintbit")