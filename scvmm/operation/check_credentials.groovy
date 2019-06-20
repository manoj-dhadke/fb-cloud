/*
Creation Date - 14/06/2019
Description - To Check Credentials
*/

//begin
log.trace("Started executing 'fb-cloud:scvmm:operation:check_credentials.groovy' flintbit...")
try{
    //Flintbit Input Parameters
    //Mandatory  
    connector_name= input.get("connector_name")                           //Name of the Connector
    target= input.get("target")               			                  //Target address
    username = input.get("username")               			              //Username
    password = input.get("password")               			              //Password
    shell = "ps"               			                                  //Shell Type
    transport = input.get("transport")               			              //Transport
    command = "Get-SCVirtualMachine -VMMServer '${target}' 2>&1 | convertto-json"       //Command to run
    operation_timeout = 80               		                              //Operation Timeout
    no_ssl_peer_verification = input.get("no_ssl_peer_verification")        //SSL Peer Verification
    port = input.get("port")                                                //Port Number

    //optional
    request_timeout= input.get("timeout")                                   //Request Timeout


    // checking that connector name is provided or not
	if(connector_name==null || connector_name==""){
		throw new Exception('Please provide "winrm connector name (connector_name)" to execute command')
    }
	
    log.info("Flintbit input parameters are,  connector name        ::    ${connector_name} |"+
                                            "target                   ::    ${target} |"+
                                            "username                 ::    ${username}|"+
                                            "shell                    ::    ${shell}|"+
                                            "transport                ::    ${transport}|"+
                                            "command                  ::    ${command}|"+
                                            "operation_timeout        ::    ${operation_timeout}|"+
                                            "no_ssl_peer_verification ::    ${no_ssl_peer_verification}|"+
                                            "port                     ::    ${port}")

    //initialize the winrm connector with the parameters
    connector_call = call.connector(connector_name)
                    .set("target",target)
                    .set("username",username)
                    .set("password",password)
                    .set("transport",transport)
                    .set("command",command)
                    .set("port",port)
                    .set("shell",shell)
                    .set("operation_timeout",operation_timeout)
                    .set("timeout",request_timeout)
                
    if(request_timeout==null || (request_timeout instanceof String)){
        log.trace("Calling ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
    else{
        log.trace("Calling ${connector_name} with given timeout ${request_timeout.toString()}...")
        response = connector_call.timeout(request_timeout).sync()
    }
    //Winrm Connector Response Meta Parameters
    response_exitcode=response.exitcode()           //Exit status code
    response_message=response.message()            //Execution status message

    //Winrm Connector Response Parameters
    result = response.get("result")               //Response Body

    
    if(response.exitcode == 0){    
        log.info("output: ${response}")
        log.info("SUCCESS in executing ${connector_name} where, exitcode :: ${response_exitcode} | message ::  ${response_message}")
        output.set('exit-code', 0).set('message', 'success').set("data",result.toString()) 
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message ::  ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}

log.trace("Finished executing 'fb-cloud:scvmm:operation:check_credentials.groovy' flintbit...")
