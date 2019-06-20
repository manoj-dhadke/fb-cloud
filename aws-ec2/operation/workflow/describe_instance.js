/**
 * Creation Date: 23/05/2019
 * Summary: To describe one or more instance on AWS
 * Description: To describe one or more instance on AWS using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:describe_instance.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "describe-instances";
log.info("Action: "+action);

//Timeout
request_timeout = 60000;
log.info("Timeout: "+request_timeout);

if(input_scope.hasOwnProperty("cloud_connection")){

    //Access-Key & Security-Key - mandatory
    access_key = input_scope.cloud_connection.encryptedCredentials["access_key"];
    if(access_key!=null || access_key!=""){
       connector_call.set("access-key",access_key); 
       log.info("Access Key is given");
    }
    else{
        log.error("Access-Key is null or empty string.");
    }

    secret_key = input_scope.cloud_connection.encryptedCredentials["secret_key"];
    if(secret_key!=null || secret_key!=""){
        connector_call.set("security-key",secret_key); 
        log.info("Security Key is given");
     }
     else{
         log.error("Security-Key is null or empty string.");
     }

    //Instance ID - mandatory
    if(input_scope.hasOwnProperty("instance_id")){
        instance_id = input.get("instance_id");
        if(instance_id!=null || instance_id!=""){
            connector_call.set("instance-id",instance_id); 
            log.info("Instance ID: "+instance_id);
        }
        else{
            log.error("Instance ID is null or empty string.")
        }
    }
    else{  //instance_id key not present in input JSON 
        log.error("Input does not contain the key 'instance_id'")
    }

    //Region - mandatory
    if(input_scope.hasOwnProperty("region")){
        region = input.get("region");
        if(region!=null || region!=""){
            connector_call.set("region",region); 
            log.info("Region: "+region);
        }
        else{
            log.error("Region is null or empty string.");
        }
    }
    else{  //region key not present in input JSON 
        log.error("Input does not contain the key 'region'");
    }

    //Connector Call
    response = connector_call.set("action",action).timeout(request_timeout).sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    //Response Parameters
    instance_set = response.get("instances-info");

    if(response_exitcode==0){
        user_message = "";
        for( i = 0 ; i < instance_set.length ; i++){
            log.info("Amazon EC2 instance image id :"+instance_set[i].get("image-id")+
                " | public ip :"+instance_set[i].get("public-ip")+
                " | instance type :"+instance_set[i].get("instance-type")+
                " | key-name : "+instance_set[i].get("key-name")+
                " | private ip : "+instance_set[i].get("private-ip")+
                " | hypervisor : "+instance_set[i].get("hypervisor")+
                " | kernel id : "+instance_set[i].get("kernel-id")+
                " | instance id : "+instance_set[i].get("instance-id")+
                " | architecture : "+instance_set[i].get("architecture")+
                " | client-token : "+instance_set[i].get("client-token")+
                " | instance-lifecycle : "+instance_set[i].get("instance-lifecycle")+
                " | platform : "+instance_set[i].get("platform")+
                " | state code : "+instance_set[i].get("instance-state-code")+
                " | state name : "+instance_set[i].get("instance-state-name")+
                " | ramdisk id : "+instance_set[i].get("ramdisk-id")+
                " | ebs optimized : "+instance_set[i].get("ebs-optimized")+
                " | placement tenancy : "+instance_set[i].get("placement-tenancy")+
                " | placement group name : "+instance_set[i].get("placement-group-name")+
                " | public DNS name : "+instance_set[i].get("public-DNSname")+
                " | root device name : "+instance_set[i].get("root-device-name")+
                " | root device type : "+instance_set[i].get("root-device-type")+
                " | launch time : "+instance_set[i].get("launch-time")+
                " | subnet id : "+instance_set[i].get("subnet-id")+
                " | virtualization type : "+instance_set[i].get("virtualization-type")+
                " | vpc id : "+instance_set[i].get("vpc-id")+
                " | ami launch index : "+instance_set[i].get("ami-launch-index"));
                
            user_message = user_message + "Amazon EC2 instance image id :"+instance_set[i].get("image-id")+
                        " | public ip :"+instance_set[i].get("public-ip")+
                        " | instance type :"+instance_set[i].get("instance-type")+
                        " | key-name : "+instance_set[i].get("key-name")+
                        " | private ip : "+instance_set[i].get("private-ip")
        }
        log.info("Instances Described Successfully");
        output.set("user_message",user_message)
            .set("exit-code",response_exitcode)
            .set("message",response_message)
            .set("result",instance_set);
        log.trace("Finished executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:describe_instance.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_instance.js' with errors")
    }
}
else{  //cloud_connection key not present in input JSON 
   log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}

