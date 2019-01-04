log.trace("Started executing example:get_all_instances.js flintbit")

try{

    log.trace("Inputs :: "+input)
    action = input.get('action')
    connector_name = input.get('connector-name')
    //access_key = input.get('access-key')
    //access_key_secret = input.get('access-key-secret')
    region = input.get('region')
    
    regions = []

    // Call to get_regions.js flintbit to get list of all regions
    get_regions_call_response = call.bit('example:get_regions.js')
                                 .set('connector-name', connector_name)
                                 .set('action', 'list-regions')
                                 .set('region', region)
                                 .timeout(60000)
                                 .sync()

    //log.trace(flintbit_call_response.get('result'))
    regions_list = get_regions_call_response.get('result')
    log.trace("Get All Instances Regions :: "+regions_list)
    get_regions_exit_code = get_regions_call_response.get('exit-code')

    if(get_regions_exit_code == 0){
        for(index in regions_list){
            //log.trace(regions_list[index].regionId)
            connector_call_response = call.connector(connector_name)
                                          .set('action', action)
                                        //.set('access-key', access_key)
                                        //.set('access-key-secret', access_key_secret)
                                          .set('region', regions_list[index].regionId)
                                          .timeout(120000)
                                          .sync()

            //log.trace('Region '+regions_list[index].regionId+' : ' +connector_call_response.get('instances-list'))
            instances_list = connector_call_response.get('instances-list')
            exit_code = connector_call_response.exitcode()
            message = connector_call_response.message()

            if(exit_code == 0 && instances_list != []){
                log.trace('Region: '+regions_list[index].regionId+' ::: '+instances_list)
            }

            log.trace("Message :: "+message)
        }
    }
    log.trace("Regions list to iterate through for getting instances in all regions :: "+regions_list[0].regionId)

    // if(exit_code == 0){
    //     log.trace("Instances list :: \n"+connector_call_response.get('instances-list'))
    //     output.set('user_message', connector_call_response.get('instances-list'))
    //     output.set('result', connector_call_response.get('instances-list'))

    //     output.set('exit-code', 0)
    // }

}catch(error){
    log.trace("Error Message :: "+error)
    output.set('user_message', error)
    output.set('result', error)

    output.set('exit-code', -1)
}

log.trace("Finished executing example:get_all_instances.js flintbit")