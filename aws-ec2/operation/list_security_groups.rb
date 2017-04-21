# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:list_security_groups.rb' flintbit...")

# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
action = 'list-security-group' # Specifies the name of the operation:list-security-group

# Optional
region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
request_timeout = @input.get('timeout')	      # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

@log.info("Flintbit input parameters are, connector_name : #{connector_name}| action : #{action}")

connector_call = @call.connector(connector_name)
                      .set('action', action)
                      .set('access-key', @access_key)
                      .set('security-key', @secret_key)

if !region.nil? && !region.empty?
    connector_call.set('region', region)
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

# Amazon EC2 Connector Response Parameters
security_group_list = response.get('security-group-list')	# Set of Amazon EC2 security groups details

if response_exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @output.set('exit-code', 0).set('message', response_message).setraw('security-group-list', security_group_list.to_s)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} |message : #{response_message}")
    @output.set('error', response_message)
    # @output.exit(1,response_message)						#Use to exit from flintbit
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:list_security_groups.rb' flintbit")
# end
