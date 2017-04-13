# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:associate_vpc_ipv6_cidr_block.rb' flintbit... &")
begin
	# Flintbit Input Parameters
	# Mandatory
	connector_name =@input.get('connector_name')	# Name of the Amazon EC2 Connector
	action = 'associate-vpc-cidr-block'		# Contains the name of the operation:associate-vpc-cidr-block
	vpc_id = @input.get('vpc-id')		        # Specifies the virtual private cloud ID of Amazon EC2

	# Optional
	@access_key = @input.get('access-key')	        #access key of aws-ec2 account
	@secret_key = @input.get('security-key')	#secret key of aws-ec2 account
	request_timeout = @input.get('timeout')		# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

		@log.info("Flintbit input parameters are,connector_name:#{connector_name} | action : #{action} | vpc_id: #{vpc_id}")
		#checking the connector name is provided or not,if not then provide error messsage to user
	if connector_name.nil? || connector_name.empty?
		raise 'Please provide "Amazon EC2 connector name (connector_name)" to associate virtual private cloud cidr block'
	end

	#checking the virtual private cloud id is provided or not,if not then provide error messsage to user
	if vpc_id.nil? || vpc_id.empty?
		raise 'Please provide "Amazon EC2 vpc ID (vpc_id)" to associate virtual private cloud cidr block'
	end

	#Initialising connector with the provided parameters
	connector_call = @call.connector(connector_name)
			  .set('action', action)
			  .set('vpc-id',vpc_id)
			  .set('access-key', @access_key)
			  .set('security-key', @secret_key)

	#if the request_timeout is not provided then call connector with default time-out otherwise call connector with given request time-out 
	if request_timeout.nil? || request_timeout.is_a?(String)
		@log.trace("Calling #{connector_name} with default timeout...")
		#calling connector
		response = connector_call.sync
	else
		@log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
		#calling connector
		response = connector_call.timeout(request_timeout).sync
	end

	# Amazon EC2 Connector Response Meta Parameters
	response_exitcode = response.exitcode	# Exit status code
	response_message = response.message     # Execution status messages

	#Cheking the response_exitcode,if it's zero then show details and response_message otherwise show error_message to user
	if response_exitcode == 0 
		@log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
		@output.set('exit-code', 0).set('message',response_message.to_s).setraw('response',response.to_s)
	else
		@log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message :  #{response_message}")
		@output.set('exit-code', 1).set('message', response_message)
			end

	#if any exception occured during execution then it will catch by rescue and it will show exception message to user
rescue Exception => e
	@log.error(e.message)
	@output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:associate_vpc_ipv6_cidr_block.rb' flintbit")
# end

