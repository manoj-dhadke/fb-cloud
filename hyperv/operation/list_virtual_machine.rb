require 'json'
require 'rubygems'
#begin
@log.trace("Started executing 'flint-hyperv:hyperv_2012:list_virtual_machine.rb' flintbit...")
#Flintbit Input Parameters
#Mandatory
@connector_name= @input.get("connector_name")               #Name of the Connector
@command = "powershell -Command \"&{Get-VM 2>&1 | ConvertTo-JSON}\""  #Command
@protocol = input.get('protocol')                          #Protocol
#optional
@hostname = @input.get("hostname")                          #hostname
@password = @input.get("password")                          #password
@user = @input.get("user")                                  #username
#@request_timeout= @input.get("timeout")                     #timeout
@action = "exe"
@port = @input.get("port")


@log.info("Flintbit input parameters are, connector name :: #{@connector_name} |
	                                         command ::       #{@command}|
                                           protocol ::      #{@protocol} |
                                           hostname ::      #{@hostname}|
                                           user ::          #{@user}|
                                           password ::      #{@password}|
                                           timeout ::       #{@request_timeout}")

connector_call = @call.connector(@connector_name)
                  .set("command",@command)
                  .set("protocol",@protocol)
                  .set("action",@action)
                  .set("hostname",@hostname)
                  .set("user",@user)
                  .set("password",@password)
                  .set("port",@port)
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

    #@log.info("output:::"+result.to_s)
	@log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
    	                                                   message ::  #{response_message}")
    @log.info("{\"output\":"+result)
    @output.set('exit-code', 0).set('message', response_message).set('output',result)
  #  @jsonarray = []
    #JSON.generate(@jsonarray)
  #  @res = @util.json("{\"output\":"+result.to_s+"}")
  #  @abc = @res.get("output")
  #  @abc.each do |vm|
  #  @jsonobject = {}
    #JSON.generate(@jsonobject)
  #  @jsonobject ["VMName"] = vm.get("VMName")
 	#@jsonobject ["ComputerName"] = vm.get("ComputerName")
 	#@jsonobject ["Status"] = vm.get("Status")
  #  @jsonobject ["ProcessorCount"] = vm.get("ProcessorCount")
 #	@jsonobject ["MemoryAssigned"] = vm.get("MemoryAssigned")
 #	@jsonobject ["CPUUsage"] = vm.get("CPUUsage")
 	#@jsonobject ["MemoryAssigned"] = vm.get("MemoryAssigned")
  #  @jsonobject ["Path"] = vm.get("Path")
	#@jsonarray << @jsonobject
  #  end
	#@output.set("result",@jsonarray)
else
	@log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
		                                                  message ::  #{response_message}")
    #@output.exit(1,response_message)
    @output.set('exit-code', 1).set('message', response_message)
    end
@log.trace("Finished executing 'flint-hyperv:hyperv_2012:list_virtual_machine.rb' flintbit...")
#end
