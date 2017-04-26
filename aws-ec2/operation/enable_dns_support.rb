# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:enable_dns_support.rb' flintbit... &")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'modify-vpc-attribute'	# Contains the name of the operation:modify-vpc-attribute
    vpc_id = @input.get('vpc-id')	# Specifies the virtual private cloud ID of Amazon EC2
    is_enable_dns_support = @input.get('is-enable-dns-support') # provide true to enable dns support other-wise false

    # Optional
    region = @input.get('region') # Amazon EC2 region (default region is "us-east-1")
    @access_key = @input.get('access-key') # access key of aws-ec2 account
    @secret_key = @input.get('security-key') # secret key aws-ec2 account
    request_timeout = @input.get('timeout') # Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    @log.info("Flintbit input parameters are,connector_name:#{connector_name} | action : #{action} | vpc-id:#{vpc_id} | is-enable-dns-support:#{is_enable_dns_support}")

    # checking the connector name is provided or not,if not then provide error messsage to user
    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)"  to modify virtual private cloud attributes'
    end

    # checking that the vpc-id is provided or not,if not then provide error message to user
    if vpc_id.nil? || vpc_id.empty?
        raise 'Please provide "Amazon EC2 Vpc id (vpc_id)" to modify virtual private cloud attributes'
    end

    # Initialising connector with the provided parameter
    connector_call = @call.connector(connector_name)
                          .set('action', action)
                          .set('vpc-id', vpc_id)
                          .set('is-enable-dns-support', is_enable_dns_support)
                          .set('access-key', @access_key)
                          .set('security-key', @secret_key)

    # checking that the region is provided or not ,if not the use default region us-east-1
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
        @output.set('exit-code', 0).set('message', response_message.to_s)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message :  #{response_message}")
        @output.set('exit-code', 1).set('message', response_message.to_s)
    end

# if exception occured during execution then it will catch by rescue and it will show exception message to user
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end

@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:enable_dns_support.rb' flintbit")
# end
