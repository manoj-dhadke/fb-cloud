//require 'json'
//require 'rubygems'
//begin
log.trace("Started executing 'fb-cloud:hyperv:operation:remove_virtual_machine.groovy' flintbit...")
try{
    //Flintbit Input Parameters
    //Mandatory
    connector_name= config.global("winrm.connector_name")                //Name of the Connector
    provider_details = util.json(input.get('provider_details'))
    
    target= provider_details.get('credentials').get("target")               			       //Target address
    username = provider_details.get('credentials').get("username")               			   //Username
    password = provider_details.get('credentials').get("password")               			   //Password
    shell = "ps"               			                       //Shell Type
    transport = provider_details.get('credentials').get("transport")               		   //Transport
    vmidentifier = input.get("vm-id")               		   //Virtual Machine name
    command = "\$VM = Get-VM -Id ${vmidentifier};Remove-VM -VM \$VM -Force 2>&1 | convertto-json "      //Command to run
    operation_timeout = 80                                           	    //Operation Timeout
    no_ssl_peer_verification = provider_details.get('credentials').get("no_ssl_peer_verification")        //SSL Peer Verification
    port = provider_details.get('credentials').get("port")                                                //Port Number
    request_timeout= input.get("timeout")                                   //Timeout

    log.info("Flintbit input parameters are,  connector name::${connector_name} |target::${target} |username::${username}|password::${password} |shell::${shell}|vm-id::${vmidentifier}|transport::${transport}|command::${command}|operation_timeout::${operation_timeout}|no_ssl_peer_verification::${no_ssl_peer_verification}|port::${port}")


    if (vmidentifier == null || vmidentifier == ""){
            log.error("Please provide vm id to perform remove vm operation")
            output.exit(1,"vm id is blank or not provided")
    }

    connector_call = call.connector(connector_name)
                    .set("target",target)
                    .set("username",username)
                    .set("password",password)
                    .set("transport",transport)
                    .set("command",command)
                    .set("port",port)
                    .set("shell",shell)
                    .set("no_ssl_peer_verification",no_ssl_peer_verification)
                    .set("operation_timeout",operation_timeout)

    if (request_timeout ==null || request_timeout instanceof String){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout.toString()}...")
        response = connector_call.timeout(request_timeout).sync()
    }

    //Winrm Connector Response Meta Parameters
    response_exitcode=response.exitcode()           //Exit status code
    response_message=response.message()             //Execution status message

    //Winrm Connector Response Parameters
    result = response.get("result")               //Response Body


    if (response_exitcode == 0){

        log.info("output"+result.toString())
        log.info("SUCCESS in executing ${connector_name} where, exitcode :: ${response_exitcode} |message ::  ${response_message}")
        user_message=("HyperV VM deleted successfully")
        if ((result.toString().trim() =="") == false){
           output.set('exit-code', 1).set('message', result)
        }
        else{
           output.set("exit-code",response_exitcode).set("user_message",user_message)
        }
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} |message ::  ${response_message}")
        user_message=("Error in deleting HyperV VM")
        output.set('exit-code', 1).set('user_message', user_message)
    }
}
catch (Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:hyperv:operation:remove_virtual_machine.groovy' flintbit...")
//end
