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


	@log.trace("Started execution of 'fb-cloud:rabbitMQ:operations:deleteQueue.rb' flintbit..")
begin
	# Mandatory Input Parameters
	connector_name = @input.get('connector_name') # Name of the RABBITMQ Connector

	action = 'delete-queue'

	    host_name = @input.get('host_name')# host on which rabbitmq is running
		user_name = @input.get('user_name')# username of user
		password = @input.get('password')# password of user
		virtual_host = @input.get('virtual_host')# virtual host of user
		port_number = @input.get('port_number')# port on which rabbitmq is running
		queue_name = @input.get('queue_name')# queue name on which action should be performed

		# Optional
	    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)


		connector_call = @call.connector(connector_name)
		                          .set('host-name', host_name)
		                          .set('username', user_name)
		                          .set('virtual-host', virtual_host)
		                          .set('password', password)
		                          .set('port-number', port_number)
		                          .set('action',action)

		if connector_name.nil? || connector_name.empty?
	 		raise 'Please provide "RabbitMQ connector name (connector_name)" add queue'
		end
			                          
		#checking queue name is nil or empty
		    if !queue_name.nil? && !queue_name.empty?
				connector_call.set('queue-name', queue_name)
			else
				@log.error("Please provide queue name")
			end

			#checking if request timeout provided
		    if request_timeout.nil? || request_timeout.is_a?(String)
		        @log.trace("Calling #{connector_name} with default timeout...")
		        # calling rabbitMQ connector
		        response = connector_call.sync
		    else
		        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
		        # calling rabbitMQ connector
		        response = connector_call.timeout(request_timeout).sync
		    end

		exit_code = response.exitcode
		message = response.message
		@output.set('exit-code', exit_code).set('message', message)
	    @log.info("Connector call response : #{@output}")
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', -1).set('message', e.message)
end
	@log.trace("Finished execution of 'fb-cloud:rabbitMQ:operations:deleteQueue.rb' flintbit..")
