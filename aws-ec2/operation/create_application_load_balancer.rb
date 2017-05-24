require 'json'
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_application_load_balancer.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = 'amazon-ec2'	      # Name of the Amazon EC2 Connector
action = "create-application-load-balancer"  # Specifies the name of the operation: create-security-group
load_balancer_name = @input.get('name')
listener_array = @input.get('listeners')       # JSONArray of listners
subnet_array = @input.get('subnets')           # Array of subnets on which we want to connect load balancer
region = @input.get('region')
scheme = @input.get('scheme')
ip_address_type = @input.get('ip-address-type')
# Optional
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
request_timeout = @input.get('timeout')# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
security_groups = @input.get('security-groups')
tags = @input.get('tags')


@log.info("Flintbit input parameters are, action : #{action} |  Load Balancer Name : #{load_balancer_name} | Subnets : #{subnet_array} | Listeners : #{listener_array}")
if !load_balancer_name.nil? && !load_balancer_name.empty?
		name_validation = @call.connector(connector_name).set('action','describe-application-load-balancer').set('name',load_balancer_name)
		validation_response = name_validation.sync
		if validation_response.exitcode != 0

								if !@input.get('subnet1').nil? && !@input.get('subnet1').empty?
									subnets = []
									subnets << @input.get('subnet1')
										if !@input.get('subnet2').nil? && !@input.get('subnet2').empty?
											subnets << @input.get('subnet2')
											connector_call = @call.connector(connector_name)
									                          .set('action', action)
									                          .set('name',load_balancer_name)
									                          .set('access-key', @access_key)
									                          .set('security-key', @secret_key)
																						.set('subnets',subnets)

																if !request_timeout.nil? && !request_timeout.empty?
																	connector_call.timeout(request_timeout)
																else
																	@log.trace("Calling #{connector_name} with default timeout...")
																end
																if !region.nil? && !region.empty?
														         response = connector_call.set('region', region).sync
														    else
														    	response = connector_call.sync
														        @log.trace("region is not provided so using default region 'us-east-1'")
														    end
										else
											raise "Please provide at least two subnets"
										end

							elsif !subnet_array.nil? && !subnet_array.empty?
								connector_call = @call.connector(connector_name)
								                          .set('action', action)
								                          .set('name',load_balancer_name)
								                          .set('access-key', @access_key)
								                          .set('security-key', @secret_key)
									                      .set('listeners',listener_array)


									if !subnet_array.nil? && !subnet_array.empty?
									    connector_call.set('subnets',subnet_array)
									else
											raise "Subnets is not provided"
									end
									if !scheme.nil? && !scheme.empty?
										connector_call.set('scheme',scheme)
									end

									if !request_timeout.nil? && !request_timeout.empty?
										connector_call.timeout(request_timeout)
									else
										@log.trace("Calling #{connector_name} with default timeout...")
									end

									if !security_groups.nil? && security_groups.empty?
										connector_call.set('security-groups',security_groups)
									end

									if !tags.nil? && tags.empty?
										connector_call.set('tags',tags)
									end
									if !region.nil? && !region.empty?
								         response = connector_call.set('region', region).sync
								    else
								    	response = connector_call.sync
								        @log.trace("region is not provided so using default region 'us-east-1'")
								    end
							else
								raise "Please provide subnets"
							end
		else
				raise "Load balancer with the given name '#{load_balancer_name}' already exists"
		end
else
	@log.error("Error: At 'Load balancer name' #{load_balancer_name}. Please provide load balancer name.")
end

@log.info("RESPONSE OF CREATE LOAD BALANCER>>>>#{response}")

# Amazon EC2 Connector Response Meta Parameters
response_exitcode = response.exitcode	# Exit status code
response_message = response.message	# Execution status messages

if response_exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @output.set('exit-code', 0).set('message', response_message)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
		@log.error("ERROR in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
		response=response.to_s
		if !response.empty?
		@output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s)
		else
		@output.set('message', response_message).set('exit-code', 1)
		end
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_application_load_balancer.rb' flintbit")
# end
