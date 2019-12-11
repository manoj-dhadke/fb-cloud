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

# begin
require 'json'
@log.trace("Started executing 'fb-cloud:azure:operation:create_security_group.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # name of Azure connector
    @region = @input.get('region') # name of the region in which the the network will be located
    @group_name = @input.get('group-name') # name of the resource group in which you want to create the network
    @security_group_name = @input.get('security-group-name')     # name of security group name which you want to create
    @action = 'create-security-group' # Specifies the name of the operation:create-security-group

    # optional
    @key = @input.get('key') # Azure account key
    @tenant_id = @input.get('tenant-id') # Azure account tenant-id
    @subscription_id = @input.get('subscription-id') # Azure account subscription-id
    @client_id = @input.get('client-id') # Azure client-id

    @log.info("connector_name :#{@connector_name} | action:#{@action} |  @region :#{@region} | @resource-group-name : #{@group_name} |  @security-group-name : #{@security_group_name} ")


    # Checking that the connector name is provided or not,if not then raise the exception with error message
    if @connector_name.nil?
        raise 'Please provide Azure connector name (connector_name) to create security group name'
    end

    # Checking that the region name is provided or not,if not then raise the exception with error message
    if @region.nil? || @region.empty?
        raise 'Please provide Azure region name (@region) to create security group name'
    end

    # Checking that the resource group name is provided or not,if not then raise the exception with error message
    if @group_name.nil? || @group_name.empty?
        raise 'Please provide Azure  group name (@group_name) to create security group name'
    end

    # Checking that the network name is provided or not,if not then raise the exception with error message
    if @security_group_name.nil? || @security_group_name.empty?
        raise 'Please provide Azure security group name (@security_group_name)to create security group name'
    end


    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('tenant-id', @tenant_id)
                          .set('subscription-id', @subscription_id)
                          .set('key', @key)
                          .set('client-id', @client_id)
                          .set('region', @region)
                          .set('group-name', @group_name)
                          .set('security-group-name', @security_group_name)
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


    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        output = @call.bit('fb-cloud:azure:operation:describe_security_group.rb').set('connector_name',@connector_name).set('region', @region).set('group-name',@group_name).set('security-group-name',@security_group_name).set('key',@key).set('tenant-id',@tenant_id).set('subscription-id',@subscription_id).set('client-id',@client_id).sync

        @output.set('exit-code', 0).set('message', response_message).set('security-group-details',output.get('security-group-details'))
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:create_security_group.rb' flintbit")
# end
