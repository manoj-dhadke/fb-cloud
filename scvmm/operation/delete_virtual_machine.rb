=begin
##########################################################################
#
#  INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
#  __________________
# 
#  (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
#  All Rights Reserved.
#  Product / Project: Flint IT Automation Platform
#  NOTICE:  All information contained herein is, and remains
#  the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
#  The intellectual and technical concepts contained
#  herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
#  Dissemination of this information or any form of reproduction of this material
#  is strictly forbidden unless prior written permission is obtained
#  from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
=end

require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'fb-cloud:scvmm:operation:delete_virtual_machine.rb' flintbit...")
begin
#Flintbit Input Parameters
#Mandatory
@connector_name= @input.get("connector_name")											#Name of the Connector
@vmname = @input.get("vmname")															#Name of the vm
@command = "powershell -Command \"&{Remove-SCVirtualMachine -VM #{@vmname} -f 2>&1 | ConvertTo-JSON}\"" #Command to execute
@protocol = @input.get("protocol")                                                      #Protocol
#optional
@hostname = @input.get("hostname")                          							#hostname
@password = @input.get("password")                              						#password
@user = @input.get("user")																#username
@request_timeout= @input.get("timeout")
@action="exe"
@port = @input.get("port")                   							

@log.info("Flintbit input parameters are, connector name :: #{@connector_name} |
	                                  command ::       #{@command}|
                                          protocol ::      #{@protocol} |
                                          hostname ::      #{@hostname}|
                                          user ::          #{@user}|
                                          password ::      #{@password}|
                                          timeout ::       #{@request_timeout}")

if @vmname == nil || @vmname == ""
		@log.error("Please provide vm name to perform start operation")
		@output.exit(1,"vm name is blank or not provided")
end

connector_call = @call.connector(@connector_name)
                      .set("command",@command)
                      .set("protocol",@protocol)
                      .set("action",@action)
                      .set("hostname",@hostname)
                      .set("user",@user)
                      .set("password",@password)
                      .set("port", @port)
                      .set("timeout",10000)

if @request_timeout.nil? || @request_timeout.is_a?(String)
   @log.trace("Calling #{@connector_name} with default timeout...")
	 response = connector_call.sync
else
   @log.trace("Calling #{@connector_name} with given timeout #{request_timeout.to_s}...")
	 response = connector_call.timeout(@request_timeout).sync
end

#Winrm Connector Response Meta Parameters
response_exitcode=response.exitcode           #Exit status code
response_message=response.message             #Execution status message

#Winrm Connector Response Parameters
result = response.get("output")               #Response Body


if response.exitcode == 0

    @log.info("output"+result.to_s)
	@log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
    	                                                   message ::  #{response_message}")
	#@res = @util.json(result.to_s)
    #@output.setraw("output",result.to_s)
@output.set('exit-code', 0).set('message', response_message).set('output',result)

else
	@log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
		                                                  message ::  #{response_message}")
    #@output.exit(1,response_message)
    @output.set('exit-code', 1).set('message', response_message).set('output',result)
    end
rescue Exception => e
  @log.error(e.message)
  @output.set('exit-code', 1).set('message', e.message)
end    
@log.trace("Finished executing 'fb-cloud:scvmm:operation:delete_virtual_machine.rb' flintbit...")
#end
