#begin
@log.trace("Started execution 'fb-cloud:docker:operation:inspect_container.rb' flintbit...") # execution Started
begin
	# Flintbit input parametes
	#Mandatory
	@connector_name = @input.get('connector_name') # docker connector name
	@action = 'inspect' # name of the operation: inspect
	@container_id = @input.get('container-id')	# name of container which you want inspect

	# Optional
	host_name = @input.get('hostname') # docker server hostname
	port = @input.get('port') # port on which docker server running
	api_version = @input.get('docker-api-version')	# docker api version used to perform operation
	certificate_directroy_path = @input.get('certificate-dierctory-path')	# certificate directory  path to verify the user
	docker_registry_url = @input.get('docker-registry-url') #docker registry url to connect with docker server

	request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)


	connector_call=@call.connector(@connector_name)
                        .set("action",@action)

	#checking connector name is nil or empty
	if @connector_name.nil? || @connector_name.empty?
		raise 'Please provide "Docker connector name (@connector_name)" to inspect container'
	end

	#checking container id is nil or empty
	if @container_id.nil? || @container_id.empty?
		raise 'Please provide "container id (@container_id)"to inspect container'
	else
   	connector_call.set("container-id",@container_id)
	end

	if request_timeout.nil? || request_timeout.is_a?(String)
		@log.trace("Calling #{@connector_name} with default timeout...")
		# calling docker connector
		response = connector_call.sync
	else
		@log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
		# calling docker connector
		response = connector_call.timeout(request_timeout).sync
	end

	# docker  Connector Response Meta Parameterss
	response_exitcode = response.exitcode # Exit status code
	response_message =  response.message # Execution status message

	if response_exitcode==0
		@log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
		@output.set('exit-code',0).set('message',"success").set('result',response.to_s)

	else
		@log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
		@output.set('exit-code',-1).set('message',response_message)
		@output.exit(1, response_message)

	end

rescue Exception => e
	@log.error(e.message)
	@output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'fb-cloud:docker:operation:inspect_container.rb' flintbit...")
#end
