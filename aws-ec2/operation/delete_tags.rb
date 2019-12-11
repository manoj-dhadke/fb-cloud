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
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:delete_tags.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    connector_name = @input.get('connector_name')	# Name of the Amazon EC2 Connector
    action = 'delete-tags'	# Contains the name of the operation: delete-tags
    resource_id = @input.get('resource_id')	# Specifies the resource ID of Amazon EC2
    tag_key = @input.get('tag_key')	# Specifies the key of the tag
    tag_value = @input.get('tag_value')	# Specifies the value of the tag

    # Optional
    @access_key = @input.get('access-key')
    @secret_key = @input.get('security-key')
    region = @input.get('region')	# Amazon EC2 region (default region is "us-east-1")
    request_timeout = @input.get('timeout')	# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

    @log.info("Flintbit input parameters are, action : #{action} | resource_id : #{resource_id} | tag_key : #{tag_key} | tag_value : #{tag_value} |region : #{region} |")

    if connector_name.nil? || connector_name.empty?
        raise 'Please provide "Amazon EC2 connector name (connector_name)" to delete Tags'
    end

    if resource_id.nil? || resource_id.empty?
        raise 'Please provide "Amazon machine resource ID (resource_id)" to delete Tags'
    end

    if tag_key.nil? || tag_key.empty?
        raise 'Please provide "Amazon EC2 Tag Key (tag_key)" to delete Tags'
    end

    if tag_value.nil? || tag_value.empty?
        raise 'Please provide "Tag Value (tag_value)" to delete Tags'
    end

    connector_call = @call.connector(connector_name).set('action', action).set('resource-id', resource_id).set('tag-key', tag_key).set('tag-value', tag_value)
                          .set('access-key', @access_key).set('security-key', @secret_key)

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

    if response_exitcode == 0
        @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @output.set('exit-code', 0).set('message', response_message)
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
    @output.set('error', e.message)
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:delete_tags.rb' flintbit")
# end
