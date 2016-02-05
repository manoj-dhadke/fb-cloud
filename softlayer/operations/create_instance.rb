# begin
@log.trace("Started executing 'flint-cloud:softlayer:operations:create_instance.rb' flintbit...")
begin
# Flintbit Input Parameters
# Mandatory
@connector_name = @input.get('connector_name') 							# Name of the Softlayer Connector
@action = @input.get('action')                              # Action
@hostname = @input.get('host-name')                         # Hostname of the machine to be created
@domainname = @input.get('domain-name')											# DomainName of the machine to be created
@cpu = @input.get('cpu')                                    # No of cpu required
@maxmemory = @input.get('max-memory')                       # Max memory required by machine
@datacenter = @input.get('datacenter')                      # Name of the datacenter where machine is created
@operating_system = @input.get('opearting-system')          # Name of the operating system which is to be in machine
# optional
@username = @input.get('username')                          # Username
@apikey = @input.get('apikey')                              # apikey
@request_timeout = @input.get('timeout') # timeout
service_request = @input.get('service-request')
@log.info("Flintbit input parameters are, connector name :: 	#{@connector_name} |
	                                        action ::        	#{@action}|
										   							 		  hostname ::      	#{@hostname}|
										                      domainname ::    	#{@domainname}|
                                          cpu ::           	#{@cpu}|
                                          maxmemory ::     	#{@maxmemory}|
										   										datacenter ::    	#{@datacenter}|
										   										operating_system ::  #{@operating_system}|
                                          username ::      	#{@username}|
                                          apikey ::        	#{@apikey}|
                                          timeout ::       	#{@request_timeout}")
if @hostname.nil? || @hostname.empty?
	fail 'Please provide "softalyer vm hostname (host-name)" to launch instance'
end
if @connector_name.nil? || @connector_name.empty?
	fail 'Please provide "softalyer connector name (connector_name)" to launch instance'
end
if @domainname.nil? || @domainname.empty?
	fail 'Please provide "softlayer domain name (domain-name) " to launch instance'
end
if @datacenter.nil? || @datacenter.empty?
	fail 'Please provide "softalyer data center (datacenter)" to launch instance'
end
if @operating_system.nil? | @operating_system.empty?
	fail 'Please provide "softlayer operating system (operating-system)" to launch instance'
end

connector_call = @call.connector(@connector_name)
                      .set('action', "create")
                      .set('host-name', @hostname)
                      .set('domain-name', @domainname)
                      .set('cpu', @cpu)
                      .set('max-memory', @maxmemory)
                      .set('datacenter', @datacenter)
                      .set('opearting-system', @operating_system)
                      .set('apikey', @apikey)
                      .set('username', @username)

if @request_timeout.nil? || @request_timeout.is_a?(String)
  @log.trace("Calling #{@connector_name} with default timeout...")
  response = connector_call.sync
else
  @log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
  response = connector_call.timeout(@request_timeout).sync
end

@log.info('Response : ' + response.to_s)
# Softlayer Connector Response Meta Parameters
response_exitcode = response.exitcode           # Exit status code
response_message = response.message             # Execution status message

# Softlayer Connector Response Parameters
id = response.get('id')                       # Machine Id
domainName = response.get('domainName')       # Machine domainName

if response.exitcode == 0
  @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
    	                                                   message ::  #{response_message}")
  @log.info("#{@connector_name} Machine  Id :: #{id} | Machine domainName ::#{domainName}")
  @output.setraw('response', response.to_s).set("exit-code",0).set("message","success")

else
  @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} |
		                                                  message ::  #{response_message}")
  @output.exit(1, response_message)
end
rescue => e
	@log.error(e.message)
	@output.set('message', e.message).set("exit-code", -1)
	@call.bit('flintcloud-integrations:aws:vm_provision_mail.rb').set('exit-code', 1).set('to', @email).set('error', e.message).set('service-request', service_request).async
	@log.info("output in exception")
end
@log.trace("Finished executing 'flint-cloud:softlayer:operation:create_instance.rb' flintbit...")
# end
