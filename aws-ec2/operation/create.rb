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

@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @log.info("Input for create instance flintbit :: #{@input}")

    # Mandatory Input Parameters
    connector_name = @input.get("connector_name") # Name of the Amazon EC2 Connector
    action = 'create-instance'                    # Contains the name of the operation: create-instance
    image_id = @input.get('ami_id')               # Specifies the unique ID for the AMI
    instance_type = @input.get('instance_type')   # Specifies the type of the instance
    min_instance = 1                              # Specifies the minimum number of instances to launch
    max_instance = 1                              # Specifies the maximum number of instances to launch
    subnet_id = ""
    access_key = @input.get("access-key")
    security_key = @input.get("security-key")
    # Optional Input Parameters
    availability_zone = @input.get('availability_zone')
    region = availability_zone.chop
    request_timeout = @input.get('timeout')
    security_group = "default"
    shutdown_behavior = @input.get('shutdown_behavior')
    termination_protection = @input.get('termination_protection')
    config = "aws."+availability_zone

    @log.info("Flintbit input parameters are, action : #{action} | image_id : #{image_id} | availability_zone : #{availability_zone} |instance_type : #{instance_type} | min_instance : #{min_instance} | max_instance : #{max_instance} | region : #{region}| security_group : #{security_group} |
shutdown_behavior : #{shutdown_behavior} | termination_protection : #{termination_protection}")

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to launch Instance'
    end

    if image_id.nil? || image_id.empty?
        raise 'Please provide "Amazon machine image ID (image_id)" to launch Instance'
    else
	subnet_id = @config.global(""+config.to_s+".subnet-id")
	image_id = @config.global(""+config.to_s+"."+image_id.to_s)
    end

    if instance_type.nil? || instance_type.empty?
        raise 'Please provide "Amazon EC2 instance type (instance_type)" to launch Instance'
    end

    @log.info("Calling Amazon EC2 Connector :: "+connector_name.to_s)
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('image-id', image_id)
                          .set('instance-type', instance_type)
                          .set('min-instance', min_instance)
                          .set('max-instance', max_instance)
                          .set('security-group', security_group)
                          .set('shutdown-behavior', shutdown_behavior)
                          .set('termination-protection', termination_protection)
                          .set("subnet-id",subnet_id)
                          .set("device-name","dev/sda1")
                          .set("access-key",access_key)
                          .set("security-key",security_key)

    if !region.nil? && !region.empty?
        connector_call.set('region', region)
        zone = region
    else
        zone = 'us-east-1'
        @log.trace("region is not provided so using default region 'us-east-1'")
    end

    if !availability_zone.nil? && !availability_zone.empty?
        connector_call.set('availability-zone', availability_zone)
    else
        @log.trace("availability zone is not provided so using default availability zone 'us-east-1a'")
    end

    if request_timeout.nil? || request_timeout.is_a?(String)
        @log.trace("Calling #{connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{connector_name} with given timeout...")
        response = connector_call.timeout(request_timeout).sync
    end

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode              		# Exit status code
    response_message = response.message                		# Execution status messages

    # Amazon EC2 Connector Response Parameters
    instance_info = response.get('instance-info') # Amazon EC2 created instance info set

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        instance_info.each do |instance|
            @log.info("Amazon EC2 Instance ID :	#{instance.get('instance-id')} |Instance Type :	#{instance.get('instance-type')} |
                Instance public IP : #{instance.get('public-ip')} |	Instance private IP : #{instance.get('private-ip')} ")
        end
        @output.setraw('instances-info', instance_info.to_s).set('exit-code', 0)
        @log.info('output in exitcode 0')
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('message', response_message).set('exit-code', -1)
        @log.info('output in exitcode -1')
        # @output.exit(1,response_message)										#Use to exit from flintbit
    end
rescue => e
    @log.error(e.message)
    @output.set('message', e.message).set('exit-code', -1)
    @log.info('output in exception')
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create.rb' flintbit")
# end
