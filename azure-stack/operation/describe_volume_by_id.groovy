// $ begin
log.trace("Started executing 'fb-cloud:azure-stack:operation:describe_volume_by_id.groovy' flintbit...")
try{
//     $ Flintbit Input Parameters
//    $ Mandatory
   connector_name = input.get('connector_name') //$name of Azure connector
   action = 'as-describe-volume' //$Specifies the name of the operation:describe-volume
   data_disk_id = input.get('data-disk-id') //$ID of the data disk which you want to describe

   log.info("connector-name:${connector_name} | action :${action} | data-disk-id:${data_disk_id}")

//    $optional
   key = input.get('key')// $Azure accountid
   tenant_id = input.get('tenant-id') //$Azure account tenant-id
   subscription_id = input.get('subscription-id')// $Azure account subscription-id
   client_id = input.get('client-id')// $Azure client-id
   arm_endpoint = input.get('arm-endpoint')

//    $Checking that the connector name is provided or not,if not then raise the exception with error message
   if (connector_name!=null && connector_name == ""){
       raise 'Please provide "MS Azure Stack connector name (connector_name)" to describe volume'
   }

//    $Checking that the data disk id is provided or not,if not then raise the exception with error message
   if (data_disk_id!=null && data_disk_id == ""){
        raise 'Please provide "MS Azure Stack data disk id(data_disk_id)" to describe volume'
   }

    if (arm_endpoint!=null && arm_endpoint == ""){
        raise 'Please provide "MS Azure Stack ARM Endpoint(arm_endpoint)" to describe volume'
   }
   connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('key', key)
                          .set('client-id', client_id)
                          .set('data-disk-id',data_disk_id)
                          .set('arm-endpoint',arm_endpoint)
                          .timeout(2800000)

    if (request_timeout!=null ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }


    // $ MS-azure Connector Response Meta Parameters
    response_exitcode = response.exitcode()//	$ Exit status code
    response_message = response.message()//	$ Execution status messages


    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        log.info("volume details=========${response}")
        output.set('exit-code', 0).set('message', response_message).set('volume-details',response.toString())
    }else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure-stack:operation:describe_volume_by_id.groovy' flintbit")
// $ end
