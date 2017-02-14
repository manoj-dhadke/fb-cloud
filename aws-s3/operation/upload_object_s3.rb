@log.trace("Started executing 'fb-cloud:aws-s3:operation:upload_object_s3.rb' flintbit...")
begin
	# Flintbit Input Parameters
	# Mandatory Input Parameters
	@connector_name = @input.get("connector_name") # Name of the aws-s3 Connector
	action = 'put-s3-object'                    #@input.get("action")
	@bucket_name = @input.get("bucket-name") #name of the bucket to which you want to upload the file
	@key = @input.get("key") #name of file
	@filename = @input.get("file")
	@log.info("#{@connector_name} | #{action} | #{@bucket_name} | #{@key} | #{@filename} ")

	# Optional input parameters
	request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

	connector_call = @call.connector(@connector_name)
                        .set('action', action)
                        .set('bucket-name',@bucket_name)
                        .set('key', @key)
                        .set('file', @filename)


	if @connector_name.nil? || @connector_name.empty?
		raise 'Please provide "aws-s3 connector name (connector_name)" to upload file to aws-s3 bucket'
	end

	if @bucket_name.nil? || @bucket_name.empty?
		raise 'Please provide "name of bucket (bucket-name)" to upload file to aws-s3 bucket'
	end

	if @filename.nil? || @filename.empty?
		raise 'Please provide "name of file (bucket-name)" to upload file to aws-s3 bucket'
	end

  if @key.nil? || @key.empty?
    raise 'Please provide "name of file  (key)" to upload file to aws-s3 bucket'
  end

	if request_timeout.nil? || request_timeout.is_a?(String)
		@log.trace("Calling #{@connector_name} with default timeout...")
		# calling aws-s3 connector
		response = connector_call.sync
	else
		@log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
		# calling aws-s3 connector
		response = connector_call.timeout(request_timeout).sync
	end

	response_exitcode = response.exitcode              		# Exit status code
	response_message = response.message                		# Execution status messages

	@log.info("response:: #{response}")

	if response_exitcode == 0
		@log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
	else

		@log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
		@output.set('message', response_message).set('exit-code', -1)
	end

rescue => e
	@log.error(e.message)
	@output.set('message', e.message).set('exit-code', -1)
	@log.info('output in exception')
end
@log.trace("Finished executing 'fb-cloud:aws-s3:operation:upload_object_s3.rb' flintbit")
