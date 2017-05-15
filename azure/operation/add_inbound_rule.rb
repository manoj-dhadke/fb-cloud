# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:add_inbound_rule.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # name of Azure connector
    @action = 'add-inbound-rule' # Specifies the name of the operation:add-inbound-rule
    @security_group_name = @input.get('security-group-name') # please provide firewall name
    @resource_group_name = @input.get('group-name')
    @rule = @input.get('rule')
    # optional
    @from_address = @input.get('from-address')
    @to_address = @input.get('to-address')
    @to_port = @input.get('to-port')
    @from_port = @input.get('from-port')
    @protocol = @input.get('protocol')
    @priority = @input.get('priority')
    @description = @input.get('description')
    @key = @input.get('key') # Azure account key
    @tenant_id = @input.get('tenant-id') # Azure account tenant-id
    @subscription_id = @input.get('subscription-id') # Azure account subscription-id
    @client_id = @input.get('client-id') # Azure client-id
    @request_timeout = @input.get('request-timeout')

    # Checking that the connector name is provided or not,if not then raise the exception with error message
    if @connector_name.nil? || @connector_name.empty?
        raise 'Please provide "MS Azure connector name (connector_name)" '
    end

    if @security_group_name.nil? || @security_group_name.empty?
        raise 'Please provide "(@security_group_id)"'
    end

    if @resource_group_name.nil? || @resource_group_name.empty?
        raise 'Please provide "(@resource_group_name)"'
    end
  
    # Checking that the connector name is provided or not,if not then raise the exception with error message
    raise 'Please provide "(@rule)" ' if @rule.nil? || @rule.empty?
    
     @log.debug("#{@log_action}
              
              | from address : #{@from_address}
              | to address : #{@to_address}
              | firewall Id : #{@security_group_name}
              | group : #{@resource_group_name}
              | rule name : #{@rule}
              | to port : #{@to_port}
              | from port : #{@from_port}
              | protocol : #{@protocol}
              | priority : #{@priority}")
    

    

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('security-group-name', @security_group_name)
                          .set('group-name', @resource_group_name)
                          .set('rule', @rule)
                          .set('from-address', @from_address)
                          .set('to-address', @to_address)
                          .set('from-port', @from_port.to_i)
                          .set('to-port', @to_port.to_i)
                          .set('protocol', @protocol)
                          .set('priority', @priority.to_i)
                          .set('description', @description)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # MS-azure Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @log.info(response.to_s)
        @output.set('exit-code', 0).set('message', response_message)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @log.info(response.to_s)
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:add_inbound_rule.rb' flintbit")
# end
