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

@log.trace("Started executing 'fb-cloud:aws-ec2:operation:register_instances_with_classic_load_balancer.rb' flintbit...")
begin
connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
load_balancer_name = @input.get('name') # Load Balancer Name
instances_to_register = @input.get('instances') # Instances to register to load balancer
action = 'register-instance-with-classic-load-balancer'
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
request_timeout = @input.get('timeout')# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
region = @input.get('region')

if !load_balancer_name.nil? && !load_balancer_name.empty?
			if !instances_to_register.nil? && !instances_to_register.empty?
				connector_call = @call.connector(connector_name)
										.set('action',action)
										.set('load-balancer-name',load_balancer_name)
										.set('instance-id-list',instances_to_register)
										.set('access-key', @access_key)
            		    .set('security-key', @secret_key)

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
				raise "Please provide instances to register"
			end
else
	raise "Please provide load balancer name"
end

if response.exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message).set('exit-code', 0)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
		response=response.to_s
		if !response.empty?
		@output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s)
		else
		@output.set('message', response_message).set('exit-code', 1)
		end
end

rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:register_instances_with_classic_load_balancer.rb' flintbit")
# end
