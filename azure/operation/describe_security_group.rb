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
@log.trace("Started executing 'fb-cloud:azure:operation:describe_security_group.rb' flintbit...")
begin
    # Flintbit Input Parameters
   # Mandatory
   @connector_name = @input.get('connector_name') #name of Azure connector
   @action = 'describe-security-group' #Specifies the name of the operation:describe-security-group
   @group_name = @input.get('group-name') #name of the resource group in which your security group is present
   @security_group_name = @input.get('security-group-name')     #name security_group_name which you want to describe
   #optional
   @key = @input.get('key') #Azure account key
   @tenant_id = @input.get('tenant-id') #Azure account tenant-id
   @subscription_id = @input.get('subscription-id') #Azure account subscription-id
   @client_id = @input.get('client-id') #Azure client-id


   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @connector_name.nil? || @connector_name.empty?
       raise 'Please provide "MS Azure connector name (connector_name)" to list security group'
   end

   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @group_name.nil? ||  @group_name.empty?
       raise 'Please provide "MS Azure group-name (@group_name)" to describe security group'
   end


   #Checking that the connector name is provided or not,if not then raise the exception with error message
   if @security_group_name.nil? || @security_group_name.empty?
       raise 'Please provide "MS Azure security-group-name (@security_group_name)" to describe security group'
   end


   connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('tenant-id', @tenant_id)
                          .set('subscription-id', @subscription_id)
                          .set('key', @key)
                          .set('client-id', @client_id)
                          .set('group-name',@group_name)
                          .set('security-group-name',@security_group_name)
                          .timeout(2800000)

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

    security_group_details=response.get('security-group-details')

    if !security_group_details.nil?
         security_group_details=@util.json(security_group_details)
    end

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @log.info("security-group-details: #{response.to_s}")
        #@call.bit('flintcloud-integrations:services:http:http_services_helper.rb').set('action', 'sync_azure_vm').set('provide_ID', providerId).sync
        @output.set('exit-code', 0).set('message', response_message).setraw('security-group-details',security_group_details.to_s)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 1).set('message', response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:azure:operation:describe_security_group.rb' flintbit")
# end
