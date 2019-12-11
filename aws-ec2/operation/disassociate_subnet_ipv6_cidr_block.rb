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
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:disassociate_subnet_ipv6_cidr_block.rb' flintbit... &")
begin
	# Flintbit Input Parameters
	# Mandatory
	connector_name =@input.get('connector_name')	# Name of the Amazon EC2 Connector
	action = 'disassociate-subnet-ipv6-cidr-block'		# Contains the name of the operation:disassociate-subnet-ipv6-cidr-block
	association_id= @input.get('association-id')	# Specifies the  association ipv6-cidr id of Amazon EC2 subnet

	# Optional
	region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
	@access_key = @input.get('access-key')     #access key of aws-ec2 account
	@secret_key = @input.get('security-key')   #secret key of aws-ec2 account
	request_timeout = @input.get('timeout')    # Execution time of the Flintbit in milliseconds (default timeout is 60000 m illoseconds)

	@log.info("Flintbit input parameters are,connector_name: #{connector_name} | action : #{action} | association-id:-#{association_id}")

	#checking the connector name is provided or not,if not then provide error messsage to user
	if connector_name.nil? || connector_name.empty?
		raise 'Please provide "Amazon EC2 connector name (connector_name)" to disassociate subnet cidr block'
	end

	#checking the association id is provided or not,if not then provide error messsage to user
	if  association_id.nil? ||  association_id.empty?
		raise 'Please provide "Amazon EC2 association ID (association_id)" to disassociate subnet cidr block'
	end

	#Initialising connector with the provided parameter
	connector_call = @call.connector(connector_name)
			  .set('action', action)
			  .set('association-id',association_id)
			  .set('access-key', @access_key)
			  .set('security-key', @secret_key)

# checking that the region is provided or not,if not then use default region us-east-1
if !region.nil? && !region.empty?
		connector_call.set('region', region)
else
  	@log.trace("region is not provided so using default region 'us-east-1'")
end

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
		@output.set('exit-code', 0).set('message',response_message.to_s).setraw('response',response.to_s)
	else
		@log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message :  #{response_message}")
		response=response.to_s
		if !response.empty?
		@output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s)
		else
		@output.set('message', response_message).set('exit-code', 1)
		end
	end

	#if any exception occured during execution then it will catch by rescue and it will show exception message to user
rescue Exception => e
	@log.error(e.message)
	@output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:disassociate_subnet_ipv6_cidr_block.rb' flintbit")
# end
