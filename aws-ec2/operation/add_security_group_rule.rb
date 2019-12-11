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

@log.trace("Started executing 'fb-cloud:aws-ec2:operation:add_security_group_rule.rb' flintbit...")
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

request_timeout = @input.get('timeout')
@log.trace("Calling AWS-EC2 Connector...")
@log.info("Flintbit input parameters are connector_name : #{connector_name} | direction : #{direction}
| from_port :#{from_port} | to_port : #{to_port} | protocol : #{protocol} | group_id : #{group_id}
 | access_key : #{@access_key} | secret_key : #{@secret_key}")

connector_call = @call.connector(connector_name)
                .set("action","security-group-add-rule")
                .set("access-key",@input.get("access-key"))
                .set("security-key",@input.get("security-key"))

                    if !group_id.nil? && !group_id.empty?
                      connector_call.set("security-group-id",group_id)
                    else
                      raise "Please provide 'Security Group Id'"
                    end
                    if !direction.nil? && !direction.empty?
                      connector_call.set("direction",direction)
                    else
                      raise "Please provide 'direction' for security group rule"
                    end
                    if !from_port.nil? && !from_port.empty?
                      connector_call.set("from-port",from_port.to_i)
                    else
                      raise "Please provide 'from port' for security group rule"
                    end
                    if !to_port.nil? && !to_port.empty?
                      connector_call.set("to-port",to_port.to_i)
                    else
                      raise "Please provide 'to port' for security group rule"
                    end
                    if  !protocol.nil? && !protocol.empty?
                      connector_call.set("protocol",protocol)
                    else
                      raise "Please provide 'protocol' for security group rule"
                    end
                    if !request_timeout.nil? && !request_timeout.empty?
                      connector_call.timeout(request_timeout)
                    else
                      @log.trace("Calling #{connector_name} with default timeout...")
                    end
                    if !region.nil? && !region.empty?
                           connector_call.set('region', region)
                    else
                          @log.trace("region is not provided so using default region 'us-east-1'")
                    end
                    if  !cidr_block.nil? &&  !cidr_block.empty?
                      if  !ip_range.nil? && !ip_range.empty?
                        raise "Please provide either CIDR block or IP ranges for security group rule. Do not provide both at same time."
                      else
                      response = connector_call.set("cidr-block",cidr_block).sync
                      end
                    elsif  !ip_range.nil? && !ip_range.empty?
                      if  !cidr_block.nil? &&  !cidr_block.empty?
                        raise "Please provide either CIDR block or IP ranges for security group rule. Do not provide both at same time."
                      else
                      response = connector_call.set("ip-range",ip_range).sync
                      end
                    else
                      raise "Please provide either CIDR block or IP ranges for security group rule"
                    end

  #Amazon EC2 Connector Response Meta Parameters
   response_exitcode = response.exitcode #Exit status code
   response_message = response.message   #Execution status messages

  if response_exitcode == 0
     @log.info("Response ::#{response}")
     @log.info("Success in executing AWS-EC2 Connector where, exitcode :: #{response_exitcode}| message :: #{response_message}")
     @user_message = "Successfully added the security rules."
     @output.set("exit-code",response_exitcode).set("message",response_message).set("user_message",@user_message)
  else
     @log.error("Response ::#{response}")
     @log.error("Failure in executing AWS-EC2 Connector where, exitcode :: #{response_exitcode} | message :: #{response_message}")
     @user_message = "Failed to add the security rules."
     response=response.to_s
     if !response.empty?
     @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s).set("user_message",@user_message)
     else
     @output.set('message', response_message).set('exit-code', 1).set("user_message",@user_message)
     end
  end



rescue => e
    @log.error(e.message)
    @output.set('message', e.message).set('exit-code', -1)
end
@log.trace("Finished execution of 'fb-cloud:aws-ec2:operation:add_security_group_rule.rb' flintbit...")
