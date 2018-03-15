// begin
log.trace("Started executing 'fb-cloud:aws-ec2:operation:describe_instance.groovy' flintbit... &")
try {
    // Flintbit Input Parameters
    // Mandatory
    connector_name =  input.get('connector_name')	// Name of the Amazon EC2 Connector
    action = 'describe-instances'	// Contains the name of the operation: describe-instances
    instance_id =  input.get('instance-id')	// Specifies the instance ID of Amazon EC2

    // Optional
     access_key =  input.get('access-key')
     secret_key =  input.get('security-key')
    availability_zone =  input.get('availability_zone')	 // Specifies the availability zones for
     // launching the required instances availability zone element.
    region =  input.get('region')	 // Amazon EC2 region (default region is "us-east-1")
    request_timeout =  input.get('timeout')	 // Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

     //log.info("Flintbit input parameters are, action :  ${action} | instance_id :  ${instance_id} | availability_zone :  ${availability_zone} | region :  ${region}|")

     //log.trace("Calling  ${connector_name} ...")

    if (connector_name == null || connector_name == "")
        throw new Exception('Please provide "Amazon EC2 connector name (connector_name)" to describe amazon instance')
     

     // if instance_id.nil? || instance_id.empty?
     //	raise 'Please provide "Amazon EC2 instance ID (instance_id)" to describe amazon instance'
  

    connector_call =  call.connector(connector_name).set('action', action).set('instance-id', instance_id).set('access-key',  access_key).set('security-key',  secret_key)

    if (region != null && region == ""){
        connector_call.set('region', region)
    }
    else{
        log.trace("region is not provided so using default region 'us-east-1'")
    }
         
    
    if (request_timeout == null || request_timeout instanceof String){
        log.trace("Calling  ${connector_name} with default timeout...")
        response = connector_call.sync()
    }
         
    else{
        log.trace("Calling  ${connector_name} with given timeout  ${request_timeout}...")
        response = connector_call.timeout(request_timeout).sync()
    }
         

     //log.info(" Connector response :    ${response}")
     // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	 // Exit status code
    response_message = response.message()	 // Execution status messages

     // Amazon EC2 Connector Response Parameters
    instances_set = response.get('instances-info')	 // Set of Amazon EC2 described instances
    if (instances_set == null){
            instances_set = []
    }
     

    if (response_exitcode == 0 && instances_set != ""){
         log.info("SUCCESS in executing  ${connector_name} where, exitcode :  ${response_exitcode} | message :  ${response_message}")
        instances_set.each { instance ->
             log.info("Amazon EC2 instance image id :  ${instance.get('image-id')} | public ip :  ${instance.get('public-ip')} | instance type :  ${instance.get('instance-type')} |key-name :  ${instance.get('key-name')} |private ip :  ${instance.get('private-ip')} | hypervisor :  ${instance.get('hypervisor')} | kernel id :  ${instance.get('kernel-id')} | instance id :  ${instance.get('instance-id')} | architecture :  ${instance.get('architecture')} | client-token :  ${instance.get('client-token')} | instance-lifecycle :  ${instance.get('instance-lifecycle')} | platform :  ${instance.get('platform')} | state code :  ${instance.get('instance-state-code')} | state name :  ${instance.get('instance-state-name')} | ramdisk id :  ${instance.get('ramdisk-id')} | ebs optimized :  ${instance.get('ebs-optimized')} | placement tenancy :  ${instance.get('placement-tenancy')} |placement group name :  ${instance.get('placement-group-name')} | public DNS name :  ${instance.get('public-DNSname')} |root device name :  ${instance.get('root-device-name')} | root device type :  ${instance.get('root-device-type')} |launch time :  ${instance.get('launch-time')} | subnet id : {instance.get('subnet-id')} | virtualization type :   ${instance.get('virtualization-type')} |vpc id :  ${instance.get('vpc-id')} | ami launch index :  ${instance.get('ami-launch-index')} |")
        }
        output.set('exit-code', 0).setraw('instances-info', instances_set.toString());
    }
      
    else{
         log.error("ERROR in executing  ${connector_name} where, exitcode :  ${response_exitcode} | message :   ${response_message}")
        response=response.toString()
        if (response == "")
         output.set('message', response_message).set('exit-code', 1).setraw('error-details',response)
        else
         output.set('message', response_message).set('exit-code', 1)
    }
 }
     
 catch( Exception e){
     log.error(e.message)
     output.set('exit-code', 1).set('message', e.message)
 }
     
 log.trace("Finished executing 'fb-cloud:aws-ec2:operation:describe_instance.groovy' flintbit")  
