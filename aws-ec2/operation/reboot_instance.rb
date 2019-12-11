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
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:reboot_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'reboot-instances'	# Reboot Amazon EC2 instance action
    instance_id = @input.get('instance-id')	# Amazon Instance ID to reboot Instance
    @access_key = @input.get('access-key')
    @secret_key = @input.get('security-key')

    # Optional
    region = @input.get('region')	# Amazon EC2 region (default region is 'us-east-1')
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds

    @log.info("Flintbit input parameters are, action : #{action} | instance_id : #{instance_id} | region : #{region}")

    connector_call = @call.connector(connector_name).set('action', action).set('access-key', @access_key).set('security-key', @secret_key)

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to reboot Instance'
    end

    if instance_id.nil? || instance_id.empty?
        raise 'Please provide "Amazon instance ID (instance_id)" to reboot Instance'
    else
        connector_call.set('instance-id', instance_id)
    end

    if !region.nil? && !region.empty?
        connector_call.set('region', region)
    else
        @log.trace("region is not provided so using default region 'us-east-1'")
    end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(request_timeout).sync
    end

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode              	      # Exit status code
    response_message = response.message                       # Execution status messages

    # Amazon EC2 Connector Response Parameters
    instances_set = response.get('reboot-instance-id') # Set of Amazon EC2 rebooted instances

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        instances_set.each do |instance_id|
            @log.info("Amazon EC2 rebooted instance : #{instance_id}")
        end
        @output.set('exit-code', 0).setraw('rebooted-instances', instances_set.to_s)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
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
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:reboot_instance.rb' flintbit")
# end
