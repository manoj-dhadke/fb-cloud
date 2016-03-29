# begin

@log.trace("Started executing 'flint-util:aws:operation:create_instance.rb' flintbit...")
begin
  # Flintbit Input Parameters
  @log.info("Input for create instance flintbit :: #{@input}")
  # Mandatory
  connector_name = @input.get('connector_name')           	# Name of the Amazon EC2 Connector
  action = 'create-instance'                              	# Contains the name of the operation: create-instance
  image_id = @input.get('ami_id')                     		  # Specifies the unique ID for the AMI
  instance_type = @input.get('instance_type')					      # Specifies the type of the instance
  min_instance = @input.get('min_instance')					        # Specifies the minimum number of instances to launch
  max_instance = @input.get('max_instance')					        # Specifies the maximum number of instances to launch
  @email = @input.get('email-id')
  service_request = @input.get('service-request')
  owner = @input.get('owner')
  access_key =  @input.get('access-key')
  security_key =  @input.get('security-key')
  # Optional
  availability_zone = @input.get('availability_zone')   		# Specifies the availability zones forlaunching the required instances availability zone element.
  region = @input.get('region')								              # Amazon EC2 region (default region is "us-east-1")
  key_name = @input.get('key_name')							            # Specifies the name of the key pair
  subnet_id = @input.get('subnet_id')							          # Subnet ID for VPC instances
  request_timeout = @input.get('timeout')						        # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
  network = @input.get("network")                           # Launch Instance into Amazon Virtual Private Cloud
  storage = @input.get("storage")                           # Volume type for instance
  security_group = @input.get("security_group")             # Security Group for instance
  device_name = @input.get("device_name")                   
  shutdown_behavior = @input.get("shutdown_behavior")
  termination_protection = @input.get("termination_protection")

  @log.info("Flintbit input parameters are, action : #{action} | image_id : #{image_id} | availability_zone : #{availability_zone} |instance_type : #{instance_type} |
  key_name : #{key_name} | min_instance : #{min_instance} | max_instance : #{max_instance} | region : #{region} | subnet_id : #{subnet_id}| network : #{network}
  | storage : #{storage}| security_group : #{security_group} | shutdown_behavior : #{shutdown_behavior} | termination_protection : #{termination_protection}")



  if connector_name.nil? || connector_name.empty?
    fail 'Please provide "Amazon EC2 connector name (connector_name)" to launch Instance'
  end

  if image_id.nil? || image_id.empty?
    fail 'Please provide "Amazon machine image ID (image_id)" to launch Instance'
  end

  if instance_type.nil? || instance_type.empty?
    fail 'Please provide "Amazon EC2 instance type (instance_type)" to launch Instance'
  end

  if min_instance.nil? || min_instance.is_a?(String)
    fail 'Please provide "Minimum instance value (min_instance)" to launch Instance'
  end

  if max_instance.nil? || max_instance.is_a?(String)
    fail 'Please provide "Maximum instance value (max_instance)" to launch Instance'
  end
  if !termination_protection.nil?
    if termination_protection == "true"
      termination_protection = true
    end
    termination_protection = false
  end
  connector_call = @call.connector(connector_name)
                        .set('action', action)
                        .set('image-id', image_id)
                        .set('instance-type', instance_type)
                        .set('min-instance', min_instance)
                        .set('max-instance', max_instance)
                        .set('access-key', access_key)
                        .set('security-key', security_key)
                        .set('network', network)
                        .set('storage', storage)
                        .set('security-group', security_group)
                        .set('shutdown-behavior', shutdown_behavior)
                        .set('termination-protection', termination_protection)
                        .set('device-name', device_name)

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

  if !key_name.nil? && !key_name.empty?
    connector_call.set('key-name', key_name)
  end

  if !subnet_id.nil? && !subnet_id.empty?
    @log.trace('Creating instance in VPC (Virtual Private Cloud)')
    connector_call.set('subnet-id', subnet_id)
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
  instance_info = response.get('instance-info')         # Amazon EC2 created instance info set

  if response_exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} |
                                message : #{response_message}")
    instance_info.each do |instance|
      @log.info("Amazon EC2 Instance ID :	#{instance.get('instance-id')} |Instance Type :	#{instance.get('instance-type')} |
          Instance public IP : #{instance.get('public-ip')} |	Instance private IP : #{instance.get('private-ip')} ")
      @call.bit('flintcloud-integrations:aws:vm_provision_mail.rb').set('exit-code', 0).set('to', @email).set('owner', owner)
          .set('zone', zone).set('instance-id', instance.get('instance-id')).set('public-ip', instance.get('public-ip'))
          .set('service-request', service_request).async

    end
    @output.setraw('instances-info', instance_info.to_s).set("exit-code", 0)
    @log.info("output in exitcode 0")
  else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
    @call.bit('flintcloud-integrations:aws:vm_provision_mail.rb').set('exit-code', 1).set('to', @email).set('error', response_message)
      .set('service-request', service_request).async
    @output.set('message', response_message).set("exit-code", -1)
    @log.info("output in exitcode -1")
    # @output.exit(1,response_message)										#Use to exit from flintbit
  end
  rescue => e
    @log.error(e.message)
    @output.set('message', e.message).set("exit-code", -1)
    @call.bit('flintcloud-integrations:aws:vm_provision_mail.rb').set('exit-code', 1).set('to', @email).set('error', e.message).set('service-request', service_request).async
    @log.info("output in exception")
end
@log.trace("Finished executing 'flint-util:aws:operation:create_amazon_instance.rb' flintbit")
# end
