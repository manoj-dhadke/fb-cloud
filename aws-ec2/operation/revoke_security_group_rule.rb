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

@log.trace("Started executing 'fb-cloud:aws-ec2:operation:revoke_security_group_rule.rb' flintbit...")
begin
# Flintbit Input Parameters
# Mandatory
connector_name = @input.get('connector_name')	      # Name of the Amazon EC2 Connector
action = 'revoke-security-group-rule'
direction = @input.get('direction')					# Direction i.e inbound/outbound
group_name = @input.get("security-group-name")
ip_permissions = @input.get("ip-permissions")
group_id=@input.get("group-id")

# Optional
    region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
    @access_key = @input.get('access-key')	# access key of aws-ec2 account
    @secret_key = @input.get('security-key')	# secret key aws-ec2 account


@log.info("Flintbit input parameters are, action : #{action}
														| Direction : #{direction}
														| IP Permissions : #{ip_permissions}
														| Group Id : #{group_id}
														| Group Name : #{group_name}")
		if !direction.nil? && !direction.empty?

if !ip_permissions.nil? && !ip_permissions.empty?
		connector_call = @call.connector(connector_name)
					                .set("action",action)
									.set('ip-permissions',ip_permissions)
									.set('direction',direction)
									.set('access-key', @access_key)
		                          	.set('security-key', @secret_key)
		                          	.set('type',"ipv6")
		if !group_name.nil? && !group_name.empty?
				connector_call.set('security-group-name',group_name)
		else
			#raise "Please provide group name"
		end
		if !group_id.nil? && !group_id.empty?
		connector_call.set('security-group-id',group_id)
		else
			raise "Please provide group id"
		end
		#Cheking the region is not provided or not,if not then use default region as us-east-1
	    if !region.nil? && !region.empty?
	        connector_call.set('region', region)
	    else
	        @log.trace("region is not provided so using default region 'us-east-1'")
	    end

	    # if the request_timeout is not provided then call connector with default time-out otherwise call connector with given request time-out
	    if request_timeout.nil? || request_timeout.is_a?(String)
	        @log.trace("Calling #{connector_name} with default timeout...")
	        response = connector_call.sync
	    else
	        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
	        response = connector_call.timeout(request_timeout).sync
	    end

else
	raise "Please provide IP permissions"
end
else
	@log.error("Please provide direction")
end
if response.exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message).set('exit-code',0)
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

@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:revoke_security_group_rule.rb' flintbit")
# end
