log.trace("Started executing fb-cloud:alibaba-ecs:operations:get_specified_instances.js flintbit")

log.trace("Inputs :: " + input)
action = "list-specified-instances"
connector_name = "alibaba-cloud"
instance_ids = input.get('instance-ids')
access_key = input.get('access-key')
access_key_secret = input.get('access-key-secret')
region = input.get('region')

connector_call_response = call.connector(connector_name)
    .set('action', action)
    .set('access-key', access_key)
    .set('access-key-secret', access_key_secret)
    .set('region', region)
    .set('instance-ids', instance_ids)
    .timeout(120000)
    .sync()

log.trace("Connector call response : " + connector_call_response)
exit_code = connector_call_response.exitcode()
message = connector_call_response.message()

log.trace("Message :: " + message)

if (exit_code == 0) {
    log.trace("Specified Instances list :: \n" + connector_call_response.get('instances-list'))
    output.set('user_message', connector_call_response.get('instances-list'))
    output.set('result', connector_call_response.get('instances-list'))
    output.set('message', message)
    output.set('exit-code', 0)
} else {
    log.error("Exitcode is " + exit_code + "\n Error Message:: " + message)
    output.set('message', message)
    output.set('user_message', message)
    output.set('exit-code', exit_code)
}

log.trace("Finished executing fb-cloud:alibaba-ecs:operations:get_specified_instances.js flintbit")
