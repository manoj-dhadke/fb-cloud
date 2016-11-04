@log.trace("Started execution 'flint-vmware:vc55:list_vm.rb' flintbit...") # execution Started
begin
    # flintbit input parameters
    @connector_name = @input.get("connector_name")                # "vmware"
    @action = @input.get('action')
    @username = @input.get('username')		 #username of vcenter
    @password=@input.get('password')		 #password of vcenter
    @url=@input.get('url')

    # calling vmware connector
    response = @call.connector(@connector_name)
                    .set('action',@action)
		    .set('url',@url)
		    .set('username',@username)
		    .set('password',@password)
                    .sync

     response_body = response.to_s

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message
   
     
     @log.info("RESPONSE :: #{response_body}")
@log.info("RESPONSE :: #{response_body.class}")
     
      if response_exitcode==0
         @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.set('result', "#{response}").set('exit-code',0)

     
      else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.set(1, response_message)
      end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'flint-vmware:vc55:list_vm.rb' flintbit...") 