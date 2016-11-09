@log.trace("Started execution 'fb-cloud:vmware55:operation:reboot_vm.rb") # execution Started
begin
    # Flintbit input parametes
    @connector_name = @input.get('connector_name') # "vmware"
    @action = @input.get('action')
    @username = @input.get('username')
    @password = @input.get('password')
    @vmname = @input.get('vm-name')
    @url = @input.get('url')

    # calling vmware connector
    response = @call.connector(@connector_name)
                    .set('action', @action)
                    .set('url', @url)
                    .set('vm-name', @vmname)
                    .set('username', @username)
                    .set('password', @password)
                    .sync

    response_exitcode = response.exitcode # Exit status code
    response_message =  response.message # Execution status message

    if response_exitcode == 0
        @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('exit-code', 0).set('message', 'success')
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.set('exit-code', -1).set('message',response_message)
        @output.exit(1, response_message)
    end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code',-1).set('message', e.message)
end

@log.trace("Finished execution of 'fb-cloud:vmware55:operation:reboot_vm.rb' flintbit...")
