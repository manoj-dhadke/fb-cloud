@log.trace("Started execution 'flint-vmware:vc55:check_credential.rb' flintbit...") # execution Started
begin
  # Flintbit input parametes
    @connector_name = @input.get("connector_name") # "vmware"
    @action = @input.get('action')
    @username = @input.get('username')  #username of vcenter
    @password=@input.get('password')    #password of vcenter
    @url=@input.get('url')  


    # calling vmware connector
    response = @call.connector(@connector_name)
                    .set('action',@action)
		    .set('url',@url)
		    .set('username',@username)
		    .set('password',@password)
                    .sync

     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message
    
      if response_exitcode==0
         @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
          @output.set('exit-code', 0).set('message', response_message.to_s)
     
      else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.exit(1, response_message)
 	 @output.set('exit-code', -1).set('message', response_message.to_s)
      end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'flint-vmware:vc55:check_credential.rb' flintbit...") 
