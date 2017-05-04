# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:delete_security_group_by_id.rb' flintbit...")
begin
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
action = 'delete-security-group' # Specifies the name of the operation: delete-security-group
group_id = @input.get('group-id')	# Contain security group id corresponding to the
# region that you want to delete
# Optional
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
region = @input.get('region')	# Amazon EC2 region (default region is 'us-east-1')
request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

@log.info("Flintbit input parameters are, action : #{action} | group_id : #{group_id} | region : #{region}")

# checking the connector name is provided or not,if not then provide error messsage to user
if connector_name.nil? || connector_name.empty?
    raise 'Please provide "Amazon EC2 connector name (connector_name)" to delete-security-group by id'
end

# checking the group id is provided or not,if not then provide error messsage to user
if group_id.nil? || group_id.empty?
    raise 'Please provide "Amazon EC2 security group id  (group_id)" to delete security group by id'
end


connector_call = @call.connector(connector_name)
                      .set('action', action)
                      .set('group-id', group_id)
                      .set('access-key', @access_key)
                      .set('security-key', @secret_key)

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
    @output.set('message', response.message).set('exit-code', 0)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @output.set('message', response_message).set('exit-code', 1)
    # @output.exit(1,response_message)						#Use to exit from flintbit
end

rescue Exception => e
	@log.error(e.message)
	@output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:delete_security_group_by_id.rb' flintbit")
# end
