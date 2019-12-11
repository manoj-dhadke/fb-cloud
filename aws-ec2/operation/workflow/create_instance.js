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

 log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:create_instance.js'");

 input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

 //Connector Name
 connector_name = "amazon-ec2";
 connector_call = call.connector(connector_name);
 log.info("Connector Name: "+connector_name);

 //Action
action = "create-instance";
log.info("Action: "+action);

connector_call.set("action",action);

if(input_scope.hasOwnProperty("cloud_connection")){

    //Access Key - mandatory
    access_key = input_scope.cloud_connection.encryptedCredentials["access_key"];
    if(access_key!=null || access_key!=""){
       connector_call.set("access-key",access_key); 
       log.info("Access Key is given");
    }
    else{
        log.error("Access-Key is null or empty string.");
    }

    //Security Key - mandatory
    secret_key = input_scope.cloud_connection.encryptedCredentials["secret_key"];
    if(secret_key!=null || secret_key!=""){
       connector_call.set("security-key",secret_key); 
       log.info("Security Key is given");
    }
    else{
        log.error("Security-Key is null or empty string.");
    }

    //Image-Id
    if(input_scope.hasOwnProperty("image_id")){
        image_id = input.get("image_id");
        if(image_id!=null || image_id!=""){
            connector_call.set("image-id",image_id); 
            log.info("Image-ID: "+image_id);
        }
        else{
            log.error("Image-ID is null or empty string.")
        }
    }
    else{  //image_id key not present in input JSON 
        log.error("Input does not contain the key 'image_id'")
    }

    //Instance Type
    if(input_scope.hasOwnProperty("instance_type")){
        instance_type = input.get("instance_type");
        if(instance_type!=null || instance_type!=""){
            connector_call.set("instance-type",instance_type); 
            log.info("Instance Type: "+instance_type);
        }
        else{
            log.error("Instance Type is null or empty string.")
        }
    }
    else{  //instance_type key not present in input JSON 
        log.error("Input does not contain the key 'instance_type'")
    }

    //Min Instances
    if(input_scope.hasOwnProperty("min_instance")){
        min_instance = input.get("min_instance");
        if(min_instance!=null || min_instance!=""){
            connector_call.set("min-instance",min_instance); 
            log.info("Min Instances: "+min_instance);
        }
        else{
            log.error("Min Instances is null or empty string.");
        }
    }
    else{  //min_instance key not present in input JSON 
        log.error("Input does not contain the key 'min_instance'");
    }

    //Max Instances
    if(input_scope.hasOwnProperty("max_instance")){
        max_instance = input.get("max_instance");
        if(max_instance!=null || max_instance!=""){
            connector_call.set("max-instance",max_instance); 
            log.info("Max Instances: "+max_instance);
        }
        else{
            log.error("Max Instances is null or empty string.");
        }
    }
    else{  //max_instance key not present in input JSON 
        log.error("Input does not contain the key 'max_instance'");
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

    //Availability Zone
    if(input_scope.hasOwnProperty("availability_zone")){
        availability_zone = input.get("availability_zone");
        if(availability_zone!=null || availability_zone!=""){
            connector_call.set("Availability Zone",availability_zone); 
            log.info("Availability Zone: "+availability_zone);
        }
        else{
            log.info("Availabilty Zone is null or empty string.");
        }
    }
    else{  //availability_zone key not present in input JSON 
        log.info("Input does not contain the key 'availability_zone'");
    }

    //Key Name
    if(input_scope.hasOwnProperty("key_name")){
        key_name = input.get("key_name");
        if(key_name!=null || key_name!=""){
            connector_call.set("Key Name",key_name); 
            log.info("Key Name: "+key_name);
        }
        else{
            log.info("Key Name is null or empty string.");
        }
    }
    else{  //key_name key not present in input JSON 
        log.info("Input does not contain the key 'key_name'");
    }

    //Subnet ID
    if(input_scope.hasOwnProperty("subnet_id")){
        subnet_id = input.get("subnet_id");
        if(subnet_id!=null || subnet_id!=""){
            connector_call.set("Subnet ID",subnet_id); 
            log.info("Subnet ID: "+subnet_id);
        }
        else{
            log.info("Subnet ID is null or empty string.");
        }
    }
    else{  //subnet_id key not present in input JSON 
        log.info("Input does not contain the key 'subnet_id'");
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

    //Connector call
    response = connector_call.sync();

    //Response meta-parameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    instance_info = response.get("instance-info");

    if(response_exitcode==0){
        user_message = "";
        for(i = 0; i<instance_info.length ; i++){
            log.info("Instance ID: "+instance_info[i].get("instance-id")+"  |  Instance Type: "+instance_info[i].get("instance-type")+"  |  Instance Public IP: "+instance_info[i].get("public-ip")+" | Instance Private IP: "+instance_info[i].get("private-ip"));
            user_message = user_message +(i+1) +". Instance ID: "+instance_info[i].get("instance-id")+"  |  Instance Type: "+instance_info[i].get("instance-type")+"  |  Instance Public IP: "+instance_info[i].get("public-ip")+" | Instance Private IP: "+instance_info[i].get("private-ip")+"<br>";
        }
        log.info("Successfully created an instance on AWS-EC2");
        log.info("Instance Information: "+instance_info);
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message",user_message)
            .set("result",instance_info);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_instance.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:create_instance.js' with errors")
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
