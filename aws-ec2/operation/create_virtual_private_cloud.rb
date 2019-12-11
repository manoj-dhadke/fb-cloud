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
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_virtual_private_cloud.rb' flintbit... &")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name =@config.global('flintcloud-integrations.aws-ec2.name') # Name of the Amazon EC2 Connector
    action = 'create-vpc'	                 # Contains the name of the operation: create-vpc
    cidr_block = @input.get('cidr-block')	 # Specifies the cidr-block to create virtual private cloud on Amazon EC2

    # Optional
    name = @input.get('name')
    tenancy = @input.get('tenancy')
    region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
    @access_key = @input.get('access-key')      # access key of aws-ec2 account
    @secret_key = @input.get('security-key')    # secret key of aws-ec2 account
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    @log.info("Flintbit input parameters are, connector_name:#{connector_name} | action : #{action} | cidr_block:#{cidr_block}")

    # checking the connector name is provided or not,if not then provide error messsage to user
    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)"  to create amazon virtual private cloud'
    end

    # checking the cidr block is provided or not,if not then provide error messsage to user
    if cidr_block.nil? || cidr_block.empty?
        raise 'Please provide "Amazon EC2 cidr-block (cidr_block)" to create amazon virtual private cloud'
    end

    # Initialising connector with the provided parameters
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('cidr-block', cidr_block)
                          .set('access-key', @access_key)
                          .set('security-key', @secret_key)
    # checking that the region is provided or not,if not then use default region as us-east-1
    if !region.nil? && !region.empty?
        connector_call.set('region', region)
    else
        @log.trace("region is not provided so using default region 'us-east-1'")
    end

    if !name.nil? && !name.empty?
        connector_call.set('name', name)
    end

    if !tenancy.nil? && !tenancy.empty?
        connector_call.set('tenancy', tenancy)
    end
    # if the request_timeout is not provided then call connector with default time-out otherwise call connector with given request time-out
    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        # calling connector
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        # calling connector
        response = connector_call.timeout(request_timeout).sync
    end

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages

    # Cheking the response_exitcode,if it zero then show details and response_message otherwise show error_message to user
    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")

   if name         
        @call.bit("fb-cloud:aws-ec2:operation:create_tags.rb")
             .set('connector_name', connector_name)
             .set("resource_id", "#{response.get('vpc-id')}")
             .set('tag_key','Name')
             .set('tag_value', name)
             .set('access-key', @access_key)
             .set('security-key', @secret_key)
             .sync
    end
        
        @user_message = "Successfully created AWS Virtual Private Cloud"
        @output.set('exit-code', 0).set('message', response_message.to_s).setraw('vpc-details',response.to_s).set('user_message',@user_message)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message :  #{response_message}")
        response=response.to_s
         @user_message = "Failed to create AWS Virtual Private Cloud"
        if !response.empty?
        @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s).set('user_message',@user_message)
        else
        @output.set('message', response_message).set('exit-code', 1).set('user_message',@user_message)
        end
    end

# if any exception occured during execution then it will catch by rescue and it will show exception message to user
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_virtual_private_cloud.rb' flintbit")
# end
