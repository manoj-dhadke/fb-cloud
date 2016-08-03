@log.trace("Started executing 'fb-cloud:aws-ec2:operation:add_rule_security_group.rb' flintbit...")
begin
connector_name = @input.get("connector_name")
direction = @input.get("direction")
from_port = @input.get("from_port")
to_port = @input.get("to_port")
protocol = @input.get("protocol")
group_id = @input.get("security_group_id")

# Optional
ip_range = @input.get("ip_range")
cidr_block = @input.get("cidr_block")
region = @input.get("region")
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')

@log.trace("Calling AWS-EC2 Connector...")
response = @call.connector(connector_name)
                .set("action","security-group-add-rule")
                .set("security-group-id",group_id)
                .set("direction",direction)
                .set("ip-range",ip_range)
                .set("cidr-block",cidr_block)
                .set("from-port",from_port)
                .set("to-port",to_port)
                .set("protocol",protocol)
                .set("region",region)
                .set('access-key', @access_key)
                .set('security-key', @secret_key)
                .timeout(60000)
                .sync

#Amazon EC2 Connector Response Meta Parameters
 response_exitcode = response.exitcode #Exit status code
 response_message = response.message   #Execution status messages
if response_exitcode == 0
   @log.info('Success in executing AWS-EC2 Connector where, exitcode :: '+ response_exitcode.to_s+' | message :: '+ response_message)
   @output.set("exit-code",response_exitcode).set("message",response_message)
else
   @log.error('Failure in executing AWS-EC2 Connector where, exitcode ::'+ response_exitcode.to_s+' | message :: ' + response_message)
   @output.set("exit-code",response_exitcode).set("message",response_message)
end
rescue => e
    @log.error(e.message)
    @output.set('message', e.message).set('exit-code', -1)
end
@log.trace("Finished execution of 'fb-cloud:aws-ec2:operation:add_rule_security_group.rb' flintbit...")
