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
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:describe_instance.rb' flintbit... &")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'describe-instances'	# Contains the name of the operation: describe-instances
    instance_id = @input.get('instance-id')	# Specifies the instance ID of Amazon EC2

    # Optional
    @access_key = @input.get('access-key')
    @secret_key = @input.get('security-key')
    availability_zone = @input.get('availability_zone')	# Specifies the availability zones for
    # launching the required instances availability zone element.
    region = @input.get('region')	# Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    @log.info("Flintbit input parameters are, action : #{action} | instance_id : #{instance_id} | availability_zone : #{availability_zone} | region : #{region}|")

    @log.trace("Calling #{connector_name} ...")

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to describe amazon instance'
    end

    # if instance_id.nil? || instance_id.empty?
    #	raise 'Please provide "Amazon EC2 instance ID (instance_id)" to describe amazon instance'
    # end

    connector_call = @call.connector(connector_name).set('action', action).set('instance-id', instance_id).set('access-key', @access_key).set('security-key', @secret_key)

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

    @log.info(" Connector response :   #{response}")
    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages

    # Amazon EC2 Connector Response Parameters
    instances_set = response.get('instances-info')	# Set of Amazon EC2 described instances
    instances_set = [] if instances_set.nil?

    if response_exitcode == 0 && !instances_set.empty?
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        instances_set.each do |instance|
            @log.info("Amazon EC2 instance image id : #{instance.get('image-id')} | public ip : #{instance.get('public-ip')} | instance type : #{instance.get('instance-type')} |
          				key-name : #{instance.get('key-name')} |private ip : #{instance.get('private-ip')} | hypervisor : #{instance.get('hypervisor')} |
          				kernel id : #{instance.get('kernel-id')} | instance id : #{instance.get('instance-id')} | architecture : #{instance.get('architecture')} |
          				client-token : #{instance.get('client-token')} | instance-lifecycle : #{instance.get('instance-lifecycle')} | platform : #{instance.get('platform')} |
          				state code : #{instance.get('instance-state-code')} | state name : #{instance.get('instance-state-name')} | ramdisk id : #{instance.get('ramdisk-id')} |
          				ebs optimized : #{instance.get('ebs-optimized')} | placement tenancy : #{instance.get('placement-tenancy')} |
          				placement group name : #{instance.get('placement-group-name')} | public DNS name : #{instance.get('public-DNSname')} |
          				root device name : #{instance.get('root-device-name')} | root device type : #{instance.get('root-device-type')} |
          				launch time : #{instance.get('launch-time')} | subnet id : #{instance.get('subnet-id')} | virtualization type :  #{instance.get('virtualization-type')} |
          	            vpc id : #{instance.get('vpc-id')} | ami launch index : #{instance.get('ami-launch-index')} |")
        end
        @output.set('exit-code', 0).setraw('instances-info', instances_set.to_s)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message :  #{response_message}")
        response=response.to_s
        if !response.empty?
        @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response)
        else
        @output.set('message', response_message).set('exit-code', 1)
        end
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:describe_instance.rb' flintbit")
# end
