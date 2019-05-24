log.trace("Started executing 'fb-cloud:azure:operation:list_volumes.groovy' flintbit...")
{
    //$ Flintbit Input Parameters
   //$ Mandatory
   connector_name = input.get('connector_name') //$name of Azure connector
   action = 'as-list-volumes' //$Specifies the name of the operation:list-volumes

   //$optional
   group_name=input.get("group-name") //$name of group for which you want
   key = input.get('key') //$Azure account key
   tenant_id = input.get('tenant-id') //$Azure account tenant-id
   subscription_id = input.get('subscription-id')// $Azure account subscription-id
   client_id = input.get('client-id')// $Azure client-id
   arm_endpoint = input.get('arm-endpoint')
   //$Checking that the connector name is provided or not,if not then raise the exception with error message
   if (connector_name!=null && connector_name == ""){
       raise 'Please provide "MS Azure Stack connector name (connector_name)" to list volume'
   }
    if (arm_endpoint!=null && arm_endpoint == ""){
        raise 'Please provide "MS Azure Stack ARM Endpoint(arm_endpoint)" to list volume'
   }
   connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('key', key)
                          .set('client-id', client_id)
                          .set('arm-endpoint',arm_endpoint)
                          .timeout(2800000)

    //$Checking that the group name is provided or not
    if (group_name!=null && group_name == ""){
      connector_call.set('group-name',group_name)
    }

    if (request_timeout!=null ){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }else
        log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    //$ MS-azure Connector Response Meta Parameters
    response_exitcode = response.exitcode	//$ Exit status code
    response_message = response.message	//$ Execution status messages

    volume_list=response.get('volume-list')

    if(response_exitcode == 0)
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        log.info("volume-details: ${response.toString()}")
        output.set('exit-code', 0).set('message', response_message).set('volume-list',volume_list)
    }else
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}catch(Exception e)
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure:operation:list_volumes.groovy' flintbit")

