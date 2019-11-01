log.trace("Started executing fb-cloud:alibaba-ecs:operations:get_all_instances.js flintbit")



log.trace("Inputs :: " + input)
action = "list-instances"
connector_name = "alibaba-cloud"
access_key = input.get('access-key')
access_key_secret = input.get('access-key-secret')
region = input.get('region')

regions = []

// Call to get_regions.js flintbit to get list of all regions
get_regions_call_response = call.bit('fb-cloud:alibaba-ecs:operations:get_regions.js')
    .set('connector-name', connector_name)
    .set('access-key', access_key)
    .set('access-key-secret', access_key_secret)
    .set('action', 'list-regions')
    .set('region', region)
    .timeout(60000)
    .sync()

//log.trace(flintbit_call_response.get('result'))
get_regions_exit_code = get_regions_call_response.exitcode()
get_regions_message = get_regions_call_response.message()

if (get_regions_exit_code == 0) {
    regions_list = get_regions_call_response.get('result')
    log.trace("Get All Instances Regions :: " + regions_list)

    for (index in regions_list) {
        //log.trace(regions_list[index].regionId)
        connector_call_response = call.connector(connector_name)
            .set('action', action)
            .set('access-key', access_key)
            .set('access-key-secret', access_key_secret)
            .set('region', regions_list[index].regionId)
            .timeout(120000)
            .sync()

        //log.trace('Region '+regions_list[index].regionId+' : ' +connector_call_response.get('instances-list'))
        exit_code = connector_call_response.exitcode()
        message = connector_call_response.message()

        if (exit_code == 0) {
            instances_list = connector_call_response.get('instances-list')
            if (instances_list != []) {
                log.trace('Region: ' + regions_list[index].regionId + ' ::: ' + instances_list)
            }
        } else {
            log.error("Exitcode is " + exit_code + "\n Error Message:: " + message)
            output.set('message', message)
            output.set('user_message', message)
            output.set('exit-code', exit_code)
        }

        log.trace("Message :: " + message)
    }
} else {
    log.error("Exitcode is " + get_regions_exit_code + "\n Error Message:: " + get_regions_message)
    output.set('message', get_regions_message)
    output.set('user_message', get_regions_message)
    output.set('exit-code', get_regions_exit_code)
}

log.trace("Finished executing fb-cloud:alibaba-ecs:operations:get_all_instances.js flintbit")