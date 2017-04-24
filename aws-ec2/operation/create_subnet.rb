# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_subnet.rb' flintbit...")
begin
	# Flintbit Input Parameters
	# Mandatory
	connector_name =@input.get('connector_name')# Name of the Amazon EC2 Connector
	action = 'create-subnet'	# Specifies the name of the operation:list-subnets
	vpc_id = @input.get('vpc-id')	# Specifies the virtual private cloud id to associate to subnet which u are going to create
	cidr_block = @input.get('cidr-block')	 # Specifies the cidr-block to create subnet on Amazon EC2
	availability_zone = @input.get('availability-zone') # Specifies the availability zones for launching the required subnet availability zone element.


	# Optional
	request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
	@access_key = @input.get('access-key')	#access key of aws-ec2 account
	@secret_key = @input.get('security-key')	#secret key aws-ec2 account

	@log.info("Flintbit input parameters are, connector_name:#{connector_name}  | action : #{action}")

	#checking the connector name is provided or not,if not then provide error messsage to user
	if connector_name.nil? || connector_name.empty?
		raise 'Please provide "Amazon EC2 connector name (connector_name)" to create subnet'
	end

	#checking the availability-zone is provided or not,if not then provide error messsage to user
        if availability_zone.nil? && availability_zone.empty?
                raise 'Please provide "Amazon EC2 availabilty (availability_zone)" to create subnet'
        end

	#checking the cidr block is provided or not,if not then provide error messsage to user
	if cidr_block.nil? || cidr_block.empty?
		raise 'Please provide "Amazon EC2 cidr-block (cidr_block)" to create subnet'
	end

	#checking the virtual prvate cloud id is provided or not,if not then provide error messsage to user
	if vpc_id.nil? || vpc_id.empty?
		raise 'Please provide "Amazon EC2 Vpc id (vpc_id)" to create subnet'
	end

	#Initialising connector with the provided parameters
	connector_call = @call.connector(connector_name)
			  .set('action', action)
                          .set('access-key', @access_key)
                          .set('security-key', @secret_key)
			  .set('cidr-block', cidr_block)
			  .set('vpc-id',vpc_id)
		          .set('availability-zone',availability_zone)


        #if the request_timeout is not provided then call connector with default time-out otherwise call connector with given request time-out
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


	#Cheking the response_exitcode,if it zero then show details and response_message otherwise show error_message to user
	if response_exitcode == 0
		@log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
		@log.info("subnet-details:-#{response}")
		@output.set('exit-code', 0).set('message', 'success').setraw('details',response.to_s)
	else
		@log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
		@output.set('exit-code', 1).set('message', response_message)
	end

	#if exception occured during execution then it will catch by rescue and it will show exception message to user
rescue Exception => e
	@log.error(e.message)
	@output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_subnet.rb' flintbit")
# end
