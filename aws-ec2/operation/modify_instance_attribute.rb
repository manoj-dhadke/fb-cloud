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
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:modify_instance_attribute.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
action = 'modify-instance-attribute'	# Specifies the name of the operation: modify-instance-attribute
instance_id = @input.get('instance_id')	# Contain instance ID corresponding to the
# instance that you want to modify
attribute = @input.get('attribute')	# Specifies the name of the Instance attribute
attribute_value = @input.get('attribute_value')	# Specifies the value of the Instance attribute
# Optional
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
region = @input.get('region')	# Amazon EC2 region (default region is 'us-east-1')
request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

@log.info("Flintbit input parameters are, action : #{action} | instance_id : #{instance_id} | attribute : #{attribute} | attribute_value : #{attribute_value} |
			region : #{region}")

connector_call = @call.connector(connector_name).set('action', action).set('instance-id', instance_id).set('attribute', attribute)
                      .set('attribute-value', attribute_value).set('region', region).set('access-key', @access_key).set('security-key', @secret_key)

if request_timeout.nil? || request_timeout.is_a?(String)
    @log.trace("Calling #{connector_name} with default timeout...")
    response = connector_call.sync
else
    @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
    response = connector_call.timeout(request_timeout).sync
end

# Amazon EC2 Connector Response Meta Parameters
response_exitcode = response.exitcode              	          # Exit status code
response_message = response.message                           # Execution status messages

if response_exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @output.set('result', response_message)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
		response=response.to_s
    if !response.empty?
    @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s)
    else
    @output.set('message', response_message).set('exit-code', 1)
    end
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:modify_instance_attribute.rb' flintbit")
# end
