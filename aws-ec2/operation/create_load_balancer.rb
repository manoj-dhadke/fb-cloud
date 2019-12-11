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

require 'json'
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_load_balancer.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
loadbalancer_type = @input.get('loadbalancer-type')
action = "create-#{loadbalancer_type}-load-balancer"  # Specifies the name of the operation: create-security-group
load_balancer_name = @input.get('name')
availability_zones_array = @input.get('availabilityzones') # Array of Availibity zones Amazon EC2
listener_array = @input.get('listeners')       # JSONArray of listners
subnet_array = @input.get('subnets')           # Array of subnets on which we want to connect load balancer
region = @input.get('region')
scheme = @input.get('scheme')
ip_address_type = @input.get('ip-address-type')
# Optional
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
request_timeout = @input.get('timeout')
security_groups = @input.get('security-groups')
tags = @input.get('tags')
# @input.get('timeout')	            # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)


@log.info("Flintbit input parameters are, action : #{action} |  Load Balancer Name : #{load_balancer_name} | #{loadbalancer_type} Availability zones : #{availability_zones_array} | Subnets : #{subnet_array} | Listeners : #{listener_array}")
if !load_balancer_name.nil? && !load_balancer_name.empty?

		connector_call = @call.connector(connector_name)
		                          .set('action', action)
		                          .set('name',load_balancer_name)
		                          .set('access-key', @access_key)
		                          .set('security-key', @secret_key)
			                      .set('listeners',listener_array)

		if !subnet_array.nil? && !subnet_array.empty?
		    connector_call.set('subnets',subnet_array).timeout(request_timeout)
		else !availability_zones_array.nil? && !availability_zones_array.empty?
		    connector_call.set('availability-zones',availability_zones_array).timeout(request_timeout)
		end
		if !scheme.nil? && !scheme.empty?
			connector_call.set('scheme',scheme)
		end
		# @log.info("---------  #{loadbalancer_type}")
		# if !loadbalancer_type.nil? && !loadbalancer_type.empty?
		# 	if loadbalancer_type.eql? "application"
		# 	    connector_call.set('loadbalancer-type',loadbalancer_type)
		# 	    			  .set('scheme',scheme)
		# 	    			  .set('ip-address-type',ip_address_type)
		# 	else
		# 		if !listener_array.nil? && !listener_array.empty?
		# 	    connector_call.set('loadbalancer-type',loadbalancer_type)
		# 	    else
		# 		raise"Error: At 'listener_array' #{listener_array}. Please provide listener."
		# 		end
		# 	end
		# else
		# 	raise"Please provide type of load balancer"
		# end

		if !request_timeout.nil? && !request_timeout.empty?
			connector_call.timeout(request_timeout)
		else
			connector_call.timeout(400000)
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
	@log.error("Error: At 'Load balancer name' #{load_balancer_name}. Please provide load balancer name.")
end

@log.info("RESPONSE OF CREATE LOAD BALANCER>>>>#{response}")

# Amazon EC2 Connector Response Meta Parameters
response_exitcode = response.exitcode	# Exit status code
response_message = response.message	# Execution status messages

if response_exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @output.set('message', response_message).set('exit-code', 0)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
		response=response.to_s
		if !response.empty?
		@output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s)
		else
		@output.set('message', response_message).set('exit-code', 1)
		end
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_load_balancer.rb' flintbit")
# end
