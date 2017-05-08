# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:create_network.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # name of Azure connector
    @region = @input.get('region') # name of the region in which the the network will be located
    @resource_group = @input.get('resource-group') # name of the resource group in which you want to create the network
    @network_name = @input.get('network-name')     # name of network which you want to create
    @address_spaces = @input.get('address-spaces') # provide address space in the form  of CIDR notion
    @action = 'create-network' # Specifies the name of the operation:create-network

    # optional
    @key = @input.get('key') # Azure account key
    @tenant_id = @input.get('tenant-id') # Azure account tenant-id
    @subscription_id = @input.get('subscription-id') # Azure account subscription-id
    @client_id = @input.get('client-id') # Azure client-id

    @log.info("connector_name :#{@connector_name} | action:#{@action} |  @region :#{@region} | @resource_group : #{@resource_group} |  @network_name : #{@network_name} | address-spaces :#{@address_spaces}")


    # Checking that the connector name is provided or not,if not then raise the exception with error message
    if @connector_name.nil?
        raise 'Please provide Azure connector name (connector_name) to create  virtual network'
    end

    # Checking that the region name is provided or not,if not then raise the exception with error message
    if @region.nil? || @region.empty?
        raise 'Please provide Azure region name (@region) to create  virtual network'
    end

    # Checking that the resource group name is provided or not,if not then raise the exception with error message
    if @resource_group.nil? || @resource_group.empty?
        raise 'Please provide Azure resource group name (@resource_group) to create  virtual network'
    end

    # Checking that the network name is provided or not,if not then raise the exception with error message
    if @network_name.nil? || @network_name.empty?
        raise 'Please provide Azure network name (@network_name) to create  virtual network'
    end

    # Checking that the adderess spaces is provided or not,if not then raise the exception with error message
    if @address_spaces.nil? || @address_spaces.empty?
        raise 'Please provide Azure address spaces (@address_spaces) to create  virtual network'
    end

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('region', @region)
                          .set('resource-group', @resource_group)
                          .set('network-name', @network_name)
                          .set('address-spaces', @address_spaces)
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
@log.trace("Finished executing 'fb-cloud:azure:operation:create_network.rb' flintbit")
# end
