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

require 'json'
@log.trace("Started executing 'fb-cloud:aws-ec2:operation:create_classic_load_balancer.rb' flintbit...")
# Flintbit Input Parameters
# Mandatory
connector_name = 'amazon-ec2'	      # Name of the Amazon EC2 Connector
action = "create-classic-load-balancer"  # Specifies the name of the operation: create-security-group
load_balancer_name = @input.get('name')
region = @input.get('region')
scheme = @input.get('scheme')
ip_address_type = @input.get('ip-address-type')
# Optional
@access_key = @input.get('access-key')
@secret_key = @input.get('security-key')
request_timeout = @input.get('timeout')# Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)
security_groups = @input.get('security-groups')
tags = @input.get('tags')

if !load_balancer_name.nil? && !load_balancer_name.empty?
  name_validation = @call.connector(connector_name).set('action','describe-load-balancer').set('name',load_balancer_name)
  validation_response = name_validation.sync
  if validation_response.exitcode != 0
          if !@input.get('listeners').nil? && !@input.get('listeners').empty?

            availability_zones_array = @input.get('availabilityzones')  # Array of Availibity zones Amazon EC2
            listener_array = @input.get('listeners')                    # JSONArray of listners
            subnet_array = @input.get('subnets')                        # Array of subnets on which we want to connect load balancer
            @log.info("Flintbit input parameters are, action : #{action}
            															| Load Balancer Name : #{load_balancer_name}
            															| Availability zones : #{availability_zones_array}
            															| Subnets : #{subnet_array}
            															| Listeners : #{listener_array}
                                          | Region : #{region}")
                    connector_call = @call.connector(connector_name)
                		                          .set('action', action)
                		                          .set('name',load_balancer_name)
                		                          .set('access-key', @access_key)
                		                          .set('security-key', @secret_key)
                			                      .set('listeners',listener_array)

                		if !subnet_array.nil? && !subnet_array.empty?
                		    connector_call.set('subnets',subnet_array)
                		else !availability_zones_array.nil? && !availability_zones_array.empty?
                		    connector_call.set('availability-zones',availability_zones_array)
                		end
                		if !scheme.nil? && !scheme.empty?
                			connector_call.set('scheme',scheme)
                		end

                		if !request_timeout.nil? && !request_timeout.empty?
                			connector_call.timeout(request_timeout)
                		else
                			@log.trace("Calling #{connector_name} with default timeout...")
                		end

                		if !security_groups.nil? && security_groups.empty?
                			connector_call.set('security-groups',security_groups)
                		end

                		if !tags.nil? && tags.empty?
                			connector_call.set('tags',tags)
                		end
                		if !region.nil? && !region.empty?
                	         response = connector_call.set('region', region).sync
                	    else
                	    	response = connector_call.sync
                	        @log.trace("region is not provided so using default region 'us-east-1'")
                	    end

          elsif !@input.get('listener-protocol').nil? && !@input.get('listener-protocol').empty?
            availability_zone = @input.get('availabilityzones')
            listener_protocol = @input.get('listener-protocol')
            load_balancer_port = @input.get('load-balancer-port')
            instance_port = @input.get('instance-port')
            subnet = @input.get('subnets')
            ab = {}
            ab['protocol'] = listener_protocol
            ab['loadBalancerPort'] = load_balancer_port.to_i
            ab['instancePort'] = instance_port.to_i
            b = ab
            listener_array= []
            listener_array << b                               # JSONArray of listners
            subnets =[]
            subnets << subnet                                 # Array of subnets on which we want to connect load balancer
            availability_zones_array =[]
            availability_zones_array << availability_zone     # Array of Availibity zones Amazon EC2

            @log.info("Flintbit input parameters are, action : #{action}
            															| Load Balancer Name : #{load_balancer_name}
            															| Availability zones : #{availability_zones_array}
            															| Subnets : #{subnets}
            															| Listeners : #{listener_array}
                                          | Region : #{region}")
            connector_call = @call.connector(connector_name)
            		                          .set('action', action)
            		                          .set('name',load_balancer_name)
                                          .set('listeners',listener_array)
                                          .set('subnets',subnets)
                                          .set('region',region)
                                          .set('availability-zones',availability_zones_array)

            response = connector_call.sync

          else
            raise "Please provide listeners"
          end
    else
				raise "Load balancer with the given name '#{load_balancer_name}' already exists"
		end
else
  @log.error("Error: At 'Load balancer name' #{load_balancer_name}. Please provide load balancer name.")
end
@log.info("RESPONSE OF CREATE LOAD BALANCER>>>>#{response}")

if response.exitcode == 0
    @log.info("SUCCESS in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    @output.set('message', response.message).set('exit-code', 0)
else
    @log.error("ERROR in executing #{connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
    response=response.to_s
    if !response.empty?
    @output.set('message', response_message).set('exit-code', 1).setraw('error-details',response.to_s)
    else
    @output.set('message', response_message).set('exit-code', 1)
    end
end
@log.trace("Finished executing 'fb-cloud:aws-ec2:operation:create_classic_load_balancer.rb' flintbit")
# end
