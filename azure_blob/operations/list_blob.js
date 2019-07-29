endpoint_protocol = input.get('endpoint_protocol')

account_name = input.get('account_name')

account_key = input.get('account_key')

endpoint_url = input.get('endpoint_url')

action = "list-blobs"



log.info("Calling connector")

connector_call = call.connector('azure-storage')

.set('endpoint-protocol' , endpoint_protocol)

.set('account-name' , account_name)

.set('account-key' , account_key)

.set('endpoint-url' , endpoint_url)

.set('action', action)

.sync()



exit_code = connector_call.exitcode()

message = connector_call.message()

if(exit_code == 0){

    log.trace(connector_call)

    output.set("result", connector_call.get("result"))

}else{

    log.trace(message)

}

log.info("Finished execution")