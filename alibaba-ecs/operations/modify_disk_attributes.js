log.trace("Started executing fb-cloud:alibaba-ecs:operations:modify_disk_attributes.js flintbit")

log.trace("Inputs :: " + input)

action = input.get('action')
connector_name = "alibaba-cloud"
access_key = input.get('access-key')
access_key_secret = input.get('access-key-secret')
region = input.get('region')
disk_id = input.get('disk-id')

new_input = JSON.parse(input)

connector_call_response = call.connector(connector_name)
    .set('action', action)
    .set('access-key', access_key)
    .set('access-key-secret', access_key_secret)
    .set('region', region)
    .set('disk-id', disk_id)

// Optional Fields
if (new_input.hasOwnProperty('disk-description')) {
    connector_call_response.set('disk-description', input.get('disk-description'))
}
if (new_input.hasOwnProperty('is-delete-automatic-snapshot')) {
    connector_call_response.set('is-delete-automatic-snapshot', input.get('is-delete-automatic-snapshot'))
}
if (new_input.hasOwnProperty('disk-name')) {
    connector_call_response.set('disk-name', input.get('disk-name'))
}
if (new_input.hasOwnProperty('is-delete-with-instance')) {
    connector_call_response.set('is-delete-with-instance', input.get('is-delete-with-instance'))
}
if (new_input.hasOwnProperty('is-enable-auto-snapshot')) {
    connector_call_response.set('is-enable-auto-snapshot', input.get('is-enable-auto-snapshot'))
}

connector_call_response.timeout(120000)
connector_call_response.sync()

log.trace("Connector call response : " + connector_call_response)
exit_code = connector_call_response.exitcode()
message = connector_call_response.message()

log.trace("Message :: " + message)

if (exit_code == 0) {
    log.trace("Modify Disk Response :: \n" + connector_call_response.get('disk-id'))
    output.set('user_message', connector_call_response.get('disk-id'))
    output.set('result', connector_call_response.get('disk-id'))
    output.set('message', message)
    output.set('exit-code', 0)
} else {
    log.error("Exitcode is " + exit_code + "\n Error Message:: " + message)
    output.set('message', message)
    output.set('user_message', message)
    output.set('exit-code', exit_code)
}

log.trace("Finished executing fb-cloud:alibaba-ecs:operations:modify_disk_attributes.js flintbit")