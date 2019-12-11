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
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_security_group.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = @config.global('flintcloud-integrations.aws-ec2.name')	      # Name of the Amazon EC2 Connector
action = 'create-security-group'                    # Specifies the name of the operation: create-security-group
group_name = @input.get('group_name')	              # Contain security group name that you want to create
group_description = @input.get('group_description')	# Contain security group description that you want to create
# Optional

region = @input.get('region')	                      # Amazon EC2 region (default region is 'us-east-1')
request_timeout = @input.get('timeout')	            # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

@log.info("Flintbit input parameters are, action : #{action} | group_name : #{group_name} | region : #{region} | access_key : #{@access_key} | secret_key : #{@secret_key} ")

connector_call = @call.connector(connector_name).set('action', action).set('group-name', group_name).set('group-description', group_description)
                      .set("access-key",@input.get("access-key"))
                          .set("security-key",@input.get("security-key"))
if !region.nil? && !region.empty?
    connector_call.set('region', region)
else
    @log.trace("region is not provided so using default region 'us-east-1'")
end

if request_timeout.nil? || request_timeout.is_a?(String)
    @log.trace("Calling #{connector_name} with default timeout...")
    response = connector_call.sync
else
    @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
    response = connector_call.timeout(request_timeout).sync
end

# Amazon EC2 Connector Response Meta Parameters
response_exitcode = response.exitcode	# Exit status code
response_message = response.message	# Execution status messages

if response_exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @user_message = "Successfully created AWS Security Group"
     @output.set('message', response.message).set('exit-code',0).set('user_message',@user_message)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    response=response.to_s
    @user_message = "Failed to create AWS Security Group"
    if !response.empty?
    @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s).set('user_message',@user_message)
    else
    @output.set('message', response_message).set('exit-code', 1).set('user_message',@user_message)
    end
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_security_group.rb' flintbit")
# end
