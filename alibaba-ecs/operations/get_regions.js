log.trace("Started executing fb-cloud:alibaba-ecs:operations:get_regions.js flintbit")

log.trace("Inputs :: " + input)
action = "list-regions"
connector_name = "alibaba-cloud"
access_key = input.get('access-key')
access_key_secret = input.get('access-key-secret')
region = "us-east-1"

connector_call_response = call.connector(connector_name)
    .set('action', action)
    .set('access-key', access_key)
    .set('access-key-secret', access_key_secret)
    .set('region', region)
    .timeout(300000)
    .sync()

log.trace("Connector call response : " + connector_call_response)
exit_code = connector_call_response.exitcode()
message = connector_call_response.message()

if (exit_code == 0) {
    log.trace("Regions list is :: \n" + connector_call_response.get('regions-list'))
    output.set('result', connector_call_response.get('regions-list'))
    output.set('user_message', connector_call_response.get('regions-list'))
    output.set('exit-code', 0)
    output.set('message', message)
} else {
    log.error("Exitcode is " + exit_code + "\n Error Message:: " + message)
    output.set('message', message)
    output.set('user_message', message)
    output.set('exit-code', exit_code)


    log.trace("Finished executing fb-cloud:alibaba-ecs:operations:get_regions.js flintbit")