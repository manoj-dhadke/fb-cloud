require 'json'
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_classic_lb_listeners.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
load_balancer_name = @input.get('name')
listener_array = @input.get('listeners')       # JSONArray of listners
action = 'create-listener-for-classic-load-balancer'


@log.info("Flintbit input parameters are, action : #{action} |  Load Balancer Name : #{load_balancer_name} | Listeners : #{listener_array}")
if !load_balancer_name.nil? && !load_balancer_name.empty?
	
		connector_call = @call.connector(connector_name)
		                          .set('action', action)
		                          .set('load-balancer-name',load_balancer_name)
			                      .set('listeners',listener_array)
	    response= connector_call.sync
else
	raise "Please provide load balancer name"
end

		@log.info("RESPONSE OF CREATE LOAD BALANCER>>>>#{response}")	   

if response.exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message)
    # @output.exit(1,response_message)						#Use to exit from flintbit
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_classic_lb_listeners.rb' flintbit")
# end