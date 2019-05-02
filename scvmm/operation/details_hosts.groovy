// require 'json'
// require 'rubygems'
// #begin   
log.trace("Started executing 'fb-cloud:scvmm:details_hosts.groovy' flintbit...")
try{
    // Flintbit Input Parameters
    // Mandatory  
   // hyperv_connector_name = config.global('flintcloud-integrations.hyperv.name')
    connector_name= input.get("connector_name")                                     //Name of the Connector
    target= input.get("target")               			                            //Target address
    username = input.get("username")               			                        //Username
    password = input.get("password")               			                        //Password
    hostname =input.get("host-name")                                               //Host Name
    shell = "ps"              			                                            //Shell Type
    transport = input.get("transport")               			                    //Transport
    command = "Get-SCVMHost -ComputerName ${hostname} -VMMServer ${target}| convertto-json 2>&1 -Compress"   //Command to run
    operation_timeout = 80               		                                    //Operation Timeout
    no_ssl_peer_verification = input.get("no_ssl_peer_verification")                //SSL Peer Verification
    port = input.get("port")                                                        //Port Number
    request_timeout= input.get("timeout")                                           //Timeout

   // log.info("action : list | name : ${hyperv_connector_name} | tenant id : ${tenant_id} | target : ${target} | username : ${username} | password : ${password} | port : ${port} | transport : ${transport} | no_ssl_peer_verification : ${no_ssl_peer_verification}")

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
        output.set('exit-code', 0).set('message', 'success').setraw("hosts",result.toString())
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} |message ::  ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
    }
}
catch( Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}

log.trace("Finished executing 'fb-cloud:scvmm:details_hosts.groovy' flintbit...")
