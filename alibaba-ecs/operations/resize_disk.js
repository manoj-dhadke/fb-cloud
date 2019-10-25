log.trace("Started executing example:resize_disk.js flintbit")

try{

    log.trace("Inputs :: "+input)
    action = input.get('action')
    connector_name = "alibaba-cloud"
    access_key = input.get('access-key')
    access_key_secret = input.get('access-key-secret')
    region = input.get('region')
    disk_id = input.get('disk-id')
    new_disk_size = input.get('new-disk-size')
    
    connector_call_response = call.connector(connector_name)
    .set('action', action)
    .set('disk-id', disk_id)
    .set('new-disk-size', new_disk_size)
    .set('access-key', access_key)
.set('access-key-secret', access_key_secret)
    .set('region', region)
    .timeout(120000)
    .sync()

    log.trace("Connector call response : " +connector_call_response)
    exit_code = connector_call_response.exitcode()
    message = connector_call_response.message()

    log.trace("Message :: "+message)

    if(exit_code == 0){
        log.trace("Resize Disk Response :: \n"+connector_call_response.get('request-id'))
        output.set('user_message', connector_call_response.get('request-id'))
        output.set('result', connector_call_response.get('request-id'))

        output.set('exit-code', 0)
    }

}catch(error){
    log.trace("Error Message :: "+error)
    output.set('user_message', error)
    output.set('result', error)

    output.set('exit-code', -1)
}

log.trace("Finished executing example:resize_disk.js flintbit")