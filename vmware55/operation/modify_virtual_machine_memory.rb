# begin
@log.trace("Started execution 'fb-cloud:vmware55:operation:modify_virtual_machine_memory.rb' flintbit...") # execution Started
begin
    # Flintbit input parametes
    # Mandatory
    @connector_name = @input.get('connector_name') # vmware connector name
    @action ='modify-memory' # name of the operation:modify-memory
    @username = @input.get('username') # username of vmware connector
    @password = @input.get('password') #  password of vmware connector
    @url = @input.get('url') # url for the vmware connector
    @vm_name= @input.get('vm-name') #name of the virtual machine wich you want update 
    @memory_size=@input.get('memory-size') #memory size which you are going to update for given virtual machine

   #optional
   request_timeout = @input.get('timeout') # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    #checking that the connector name is provided or not 
    if @connector_name.nil? || @connector_name.empty?
       raise 'Please provide "vmware connector name (@connector_name)" to update virtual machine'
    end

    #checking that the virtual machine name is provided or not 
    if @vm_name.nil? || @vm_name.empty?
       raise 'Please provide "virtual machine name (@vm_name)" to update virtual machine'
    end

    #checking that the virtual machine memory size is provided or not 
    if @memory_size.nil?
       raise 'Please provide "virtual machine memory size (@memory_size)" to update virtual machine'
    end

    # calling vmware connector
    connector_call = @call.connector(@connector_name)
                    .set('action', @action)
                    .set('url', @url)
                    .set('username', @username)
                    .set('password', @password)
		    .set('vm-name', @vm_name)
                    .set('memory-size', @memory_size)
                    

	#if the request_timeout is not provided then call connector with default time-out otherwise call connector with given request time-out
	if request_timeout.nil? || request_timeout.is_a?(String)
		@log.trace("Calling #{@connector_name} with default timeout...")
		#calling connector
		response = connector_call.sync
	else
		@log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
		#calling connector
		response = connector_call.timeout(request_timeout).sync
	end

    response_exitcode = response.exitcode # Exit status code
    response_message =  response.message # Execution status message

    if response_exitcode == 0
        @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('exit-code', 0).set('message', response_message.to_s)

    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('exit-code', -1).set('message', response_message.to_s)
    end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'fb-cloud:vmware55:operation:modify_virtual_machine_memory.rb' flintbit...")
# end
