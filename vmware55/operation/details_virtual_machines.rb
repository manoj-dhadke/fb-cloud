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

#begin
@log.trace("Started execution 'fb-cloud:vmware55:operation:details_virtual_machines.rb' flintbit...") # execution Started
begin
    # Flintbit input parametes
    #Mandatory
    @connector_name = @input.get('connector_name') # vmware connector name
    @action = @input.get('action') # name of the operation: vm-details
    @username = @input.get('username') # username of vmware connector
    @password = @input.get('password') # password of vmware connector
    @vmname = @input.get('vm-name')	# name of virtual machine to retrieve details
    @url = @input.get('url') #url for the vmware connector

    # Optional
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('url', @url)
                          .set('username', @username)
                          .set('password', @password)
    #checking connector name is nil or empty
    if @connector_name.nil? || @connector_name.empty?
        raise 'Please provide "VMWare connector name (connector_name)" to retrieve  details of virtual machines'
    end

    #checking virtual machine name is nil or empty
    if @vmname.nil? || @vmname.empty?
        raise 'Please provide "Virtual Machine name (@vmname)" to retrieve  details of virtual machines'
    else
        connector_call.set('vm-name',@vmname)
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

    # VMWare  Connector Response Meta Parameterss
     response_exitcode = response.exitcode # Exit status code
     response_message =  response.message # Execution status message

      if response_exitcode==0
         @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
         @log.info("details of the vm#{response}")
         @output.set("result",response.to_s).set('exit-code',0).set('message',"success")

      else
         @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
         @output.set('exit-code',-1).set('message',response_message)
         @output.exit(1, response_message)

      end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished execution 'fb-cloud:vmware55:operation:details_virtual_machines.rb' flintbit...")
#end
