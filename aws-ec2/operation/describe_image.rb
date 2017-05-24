# begin
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:describe_image.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'describe-image'	# Contains the name of the operation: describe_image
    image_id = @input.get('image-id')	# Specifies the image ID of Amazon EC2

    # Optional
    @access_key = @input.get('access-key')
    @secret_key = @input.get('security-key')
    region = @input.get('region')	# Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    @log.info("Flintbit input parameters are, action : #{action} | image_id : #{image_id} | region : #{region}")

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to describe Image'
    end

    if image_id.nil? || image_id.empty?
        raise 'Please provide "Amazon EC2 image ID (image_id)" to describe image'
    end

    connector_call = @call.connector(connector_name).set('action', action).set('image-id', image_id).set('access-key', @access_key).set('security-key', @secret_key)

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
    response_exitcode = response.exitcode	# Exit status code
    response_message = response.message	# Execution status messages
    image_info = response.get('image-info')	# image info json

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @log.info("Amazon EC2 Image info : #{image_info}")

        @output.set('exit-code', 0).set('message', response_message).set('image-info', image_info)
    else
        @log.error("ERROR in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
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
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:describe_image.rb' flintbit")
# end
