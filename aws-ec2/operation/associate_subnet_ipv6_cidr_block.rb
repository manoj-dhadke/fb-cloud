# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:associate_subnet_ipv6_cidr_block.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name') # Name of the Amazon EC2 Connector
    action = 'associate-subnet-ipv6-cidr-block'	# Specifies the name of the operation:associate-subnet-ipv6-cidr-block
    subnet_id = @input.get('subnet-id')	# Specifies the  subnet-id which you are going to describe
    cidr_block = @input.get('cidr-block') # Specifies the ipv6-cidr-block to associate with the subnet on Amazon EC2

    # Optional
    region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
    @access_key = @input.get('access-key')	# access key of aws-ec2 account
    @secret_key = @input.get('security-key')	# secret key aws-ec2 account

    @log.info("Flintbit input parameters are, connector_name:#{connector_name}  | action : #{action} | sunet-id: #{subnet_id} |cidr-block: #{cidr_block}")

    # checking the connector name is provided or not,if not then provide error messsage to user
    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to associate ipv6-cidr-block to subnet'
    end

    # checking the virtual prvate cloud id is provided or not,if not then provide error messsage to user
    if subnet_id.nil? || subnet_id.empty?
        raise 'Please provide "Amazon EC2 subnet id (subnet_id)"to associate ipv6-cidr-block to subnet'
    end

    # checking the ipv6-cidr-block is provided or not,if not then provide error messsage to user
    if cidr_block.nil? || cidr_block.empty?
        raise 'Please provide "Amazon EC2 cidr-block (cidr_block)" to associate ipv6-cidr-block to subnet'
    end

    # Initialising connector with the provided parameters
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('access-key', @access_key)
                          .set('security-key', @secret_key)
                          .set('subnet-id', subnet_id)
                          .set('cidr-block', cidr_block)

    # Checking that the region is provided or not,if not set default region i.e.us-east-1
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

    # Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages

    # Cheking the response_exitcode,if it zero then show details and response_message otherwise show error_message to user
    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', 'success')
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        response=response.to_s
        if !response.empty?
        @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s)
        else
        @output.set('message', response_message).set('exit-code', 1)
        end
    end

# if exception occured during execution then it will catch by rescue and it will show exception message to user
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:associate_subnet_ipv6_cidr_block.rb' flintbit")
# end
