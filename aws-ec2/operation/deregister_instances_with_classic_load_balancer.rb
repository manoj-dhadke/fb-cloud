@log.trace("Started executing 'fb-cloud:aws-ec2:operation:deregister_instances_with_classic_load_balancer.rb' flintbit...")

connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
load_balancer_name = @input.get('name') # Load Balancer Name
instances_to_register = @input.get('instances') # Instances to register to load balancer
action = 'deregister-instance-with-classic-load-balancer'
if !load_balancer_name.nil? && !load_balancer_name.empty?
	if !instances_to_register.nil? && !instances_to_register.empty?
		connector_call = @call.connector(connector_name)
								.set('action',action)
								.set('load-balancer-name',load_balancer_name)
								.set('instance-id-list',instances_to_register)
	else
		raise "Please provide instances to register"
	end
else
	raise "Please provide load balancer name"
end

response = connector_call.sync
if response.exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:deregister_instances_with_classic_load_balancer.rb' flintbit")
# end