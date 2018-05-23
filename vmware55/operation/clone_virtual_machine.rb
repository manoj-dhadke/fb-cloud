@log.trace("Started execution 'fb-cloud:vmware55:operation:clone_virtual_machine.rb' flintbit...") # execution Started
begin

    # Flintbit input parametes
    @connector_name = @input.get("connector_name")  # "vmware" connector name
    @action ="clone-vm"
    @username = @input.get('username')
    @password=@input.get('password')
    @url=@input.get('url')
    @datacenter=@input.get('datacenter-name')
    @clone_from_name=@input.get('clone-from-name')
    @vm_name=@input.get('vm-name')
    @host_name=@input.get('host-name')

    #Optional
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
    @resource_pool_name=@input.get('resource-pool-name')

    # calling vmware connector
    connector_call = @call.connector(@connector_name)
                          .set('action',@action)		           
                          .set('resource-pool-name',@resource_pool_name)

   

     #checking connector name is nil or empty
     if @connector_name.nil? || @connector_name.empty?
        raise 'Please provide "VMWare connector name(connector_name)" to retrieve create virtual machine'
     end
    
     if @url.nil? || @url.empty?
        raise 'Please provide "vmware server hostname(url)" to create new virtual machine'
     else
        connector_call.set('url',@url)
     end

     if @username.nil? || @username.empty?
        raise 'Please provide "username of the vmware server(username)" to create new virtual machine'
     else
        connector_call.set('username',@username)
     end    

     if @password.nil? || @password.empty?
        raise 'Please provide "password of the vmware server(password)" to create new virtual machine'
     else
        connector_call.set('password',@password)
     end

     if @vm_name.nil? || @vm_name.empty?
        raise 'Please provide "Virtual Machine name (vm-name)" to create new virtual machine'
     else
        connector_call.set('vm-name',@vm_name)
     end

     if @datacenter.nil? || @datacenter.empty?
        raise 'Please provide "datacenter name (datacenter-name)" to create new virtual machine'
     else
        connector_call.set('datacenter-name',@datacenter)
     end

     if @clone_from_name.nil? || @clone_from_name.empty?
        raise 'Please provide "name of the virtual machine "(clone-from-name)" from which new virtual machine get created'
     else
        connector_call.set('clone-from-name',@clone_from_name)
     end
 
     if @host_name.nil? || @host_name.empty?
        raise 'Please provide "name of the host "(host-name)" in which vm get created'
     else
        connector_call.set('host-name',@host_name)
     end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        # calling vmware55 connector
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
        # calling vmware55 connector
        response = connector_call.timeout(request_timeout).sync
    end
    
     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message

     if response_exitcode==0
         @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.set("message", "success").set('exit-code',0)

    else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.set("message",response_message).set('exit-code',-1)
    end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'fb-cloud:vmware55:operation:clone_virtual_machine.rb' flintbit...")
