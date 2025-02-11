/*************************************************************************
 * 
 * INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
 * __________________
 * 
 * (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
 * All Rights Reserved.
 * Product / Project: Flint IT Automation Platform
 * NOTICE:  All information contained herein is, and remains
 * the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
 * The intellectual and technical concepts contained
 * herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
 * Dissemination of this information or any form of reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
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

    //Timeout - NOT mandatory
    if(input_scope.hasOwnProperty("request_timeout")){
        request_timeout = input.get("request_timeout");
        if(request_timeout!=null || request_timeout!=""){
            connector_call.set("timeout",request_timeout); 
            log.info("Request Timeout: "+request_timeout);
        }
        else{
            connector_call.set("timeout",240000); 
            log.info("request_timeout not given. Setting 240000 miliseconds as timeout");
        }
    }
    else{
        connector_call.set("timeout",240000); 
        log.info("request_timeout not given. Setting 240000 miliseconds as timeout");
    }

    //Connector Call
    response = connector_call.set("action",action).sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    //Response Parameters
    instance_set = response.get("instances-info");
    instance_set = instance_set[0]
    if(response_exitcode==0){
        user_message = "<b>The Instance Details are:</b><ul>";

            log.info("Amazon EC2 instance image id :"+instance_set.get("image-id")+
                " | public ip :"+instance_set.get("public-ip")+
                " | instance type :"+instance_set.get("instance-type")+
                " | key-name : "+instance_set.get("key-name")+
                " | private ip : "+instance_set.get("private-ip")+
                " | hypervisor : "+instance_set.get("hypervisor")+
                " | kernel id : "+instance_set.get("kernel-id")+
                " | instance id : "+instance_set.get("instance-id")+
                " | architecture : "+instance_set.get("architecture")+
                " | client-token : "+instance_set.get("client-token")+
                " | instance-lifecycle : "+instance_set.get("instance-lifecycle")+
                " | platform : "+instance_set.get("platform")+
                " | state code : "+instance_set.get("instance-state-code")+
                " | state name : "+instance_set.get("instance-state-name")+
                " | ramdisk id : "+instance_set.get("ramdisk-id")+
                " | ebs optimized : "+instance_set.get("ebs-optimized")+
                " | placement tenancy : "+instance_set.get("placement-tenancy")+
                " | placement group name : "+instance_set.get("placement-group-name")+
                " | public DNS name : "+instance_set.get("public-DNSname")+
                " | root device name : "+instance_set.get("root-device-name")+
                " | root device type : "+instance_set.get("root-device-type")+
                " | launch time : "+instance_set.get("launch-time")+
                " | subnet id : "+instance_set.get("subnet-id")+
                " | virtualization type : "+instance_set.get("virtualization-type")+
                " | vpc id : "+instance_set.get("vpc-id")+
                " | ami launch index : "+instance_set.get("ami-launch-index"));
                
            user_message = user_message + "    <li><b>Amazon EC2 Instance Image ID:</b> "+instance_set.get("image-id")+"</li>"+
                        "    <li><b>Public IP:</b> "+instance_set.get("public-ip")+"</li>"+
                        "    <li><b>Instance Type:</b> "+instance_set.get("instance-type")+"</li>"+
                        "    <li><b>Key-Name:</b> "+instance_set.get("key-name")+"</li>"+
                        "    <li><b>Private IP:</b> "+instance_set.get("private-ip")+"</li></ul>";

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
