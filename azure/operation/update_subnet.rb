# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:update_subnet.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # name of Azure connector
    @network_id = @input.get('network-id')     # id of network which you want to create
    @address_prefix= @input.get('address-prefix') # provide address space in the form  of CIDR notion
    @subnet_name = @input.get('subnet-name')     # Name of subnet which you want to update
    @route_table_id= @input.get('route-table-id') # id of route table
    @network_security_group_name= @input.get("network-security-group-name")
    @action = 'update-subnet' # Specifies the name of the operation:update-subnet

    # optional
    @key = @input.get('key') # Azure account key
    @tenant_id = @input.get('tenant-id') # Azure account tenant-id
    @subscription_id = @input.get('subscription-id') # Azure account subscription-id
    @client_id = @input.get('client-id') # Azure client-id

    @log.info("connector_name :#{@connector_name} | action:#{@action} |  @network_id : #{@network_id} | address-prefix :#{@address_prefix}| route-table-id:#{@route_table_id} | subnet-name :#{@subnet_name} ")


    # Checking that the connector name is provided or not,if not then raise the exception with error message
    if @connector_name.nil?
        raise 'Please provide Azure connector name (connector_name) to update subnet'
    end

    # Checking that the network id is provided or not,if not then raise the exception with error message
    if @network_id.nil? || @network_id.empty?
        raise 'Please provide Azure network id (@network_id) to update subnet'
    end

    # Checking that the subnet name is provided or not,if not then raise the exception with error message
    if @subnet_name.nil? || @subnet_name.empty?
        raise 'Please provide Azure subnet name (@subnet_name) to update subnet'
    end

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('route-table-id', @route_table_id)
                          .set('network-security-group-name',@network_security_group_name)
                          .set('subnet-name', @subnet_name)
                          .set('network-id', @network_id)
                          .set('address-prefix', @address_prefix)
                          .timeout(2_800_000)

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

    network_details=response.get('network-details')#getting created network details
    network_details=@util.json(network_details)

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', response_message).setraw('network-details',network_details.to_s)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:update_subnet.rb' flintbit")
# end
