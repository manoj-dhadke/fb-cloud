log.trace("Started executing fb-cloud:alibaba-ecs:operations:reboot_instance.js flintbit")

try {
    log.trace("Inputs :: " + input)
    action = "reboot-instance"
    connector_name = "alibaba-cloud"
    access_key = input.get('access-key')
    access_key_secret = input.get('access-key-secret')
    region = input.get('region')
    instance_id = input.get('instance-id')

    connector_call_response = call.connector(connector_name)
        .set('action', action)
        .set('instance-id', instance_id)
        .set('access-key', access_key)
        .set('access-key-secret', access_key_secret)
        .set('region', region)
        .timeout(120000)
        .sync()

    log.trace("Connector call response : " + connector_call_response)
    exit_code = connector_call_response.exitcode()
    message = connector_call_response.message()

    log.trace("Message :: " + message)

    if (exit_code == 0) {
        log.trace("Reboot Instance Response :: \n" + connector_call_response.get('request-id'))
        output.set('user_message', connector_call_response.get('request-id'))
        output.set('result', connector_call_response.get('request-id'))

        output.set('exit-code', 0)
    } else {
        log.trace("EXITCODE is " + exit_code)
        output.set('message', message)
        output.set('user_message', message)
        output.set('exit-code', exit_code)
    }

} catch (error) {
    log.trace("Error Message :: " + error)
    output.set('user_message', error)
    output.set('result', error)
    output.set('exit-code', -1)
    output.set('message', message)

}

log.trace("Finished executing fb-cloud:alibaba-ecs:operations:reboot_instance.js flintbit")