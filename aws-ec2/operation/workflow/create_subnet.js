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

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:create_subnet.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "create-subnet";
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

    //VPC ID - mandatory
    if(input_scope.hasOwnProperty("vpc_id")){
        vpc_id = input.get("vpc_id");
        if(vpc_id!=null || vpc_id!=""){
            connector_call.set("vpc-id",vpc_id); 
            log.info("VPC ID: "+vpc_id);
        }
        else{
            log.error("vpc_id Name is null or empty string.")
        }
    }
    else{  //vpc_id key not present in input JSON 
        log.error("Input does not contain the key 'vpc_id'")
    }

    //CIDR Block - mandatory
    if(input_scope.hasOwnProperty("cidr_block")){ 
        cidr_block = input.get("cidr_block");
        if(cidr_block!=null || cidr_block!=""){
            connector_call.set("cidr-block",cidr_block); 
            log.info("CIDR Block: "+cidr_block);
        }
        else{
            log.error("cidr_block Name is null or empty string.")
        }
    }
    else{  //cidr_block key not present in input JSON 
        log.error("Input does not contain the key 'cidr_block'")
    }

    //Availability Zone - not mandatory
    if(input_scope.hasOwnProperty("availability_zone")){
        availability_zone = input.get("availability_zone");
        if(availability_zone!=null || availability_zone!=""){
            connector_call.set("availability-zone",availability_zone); 
            log.info("Availability Zone: "+availability_zone);
        }
        else{
            log.info("availability_zone Name is null or empty string.")
        }
    }
    else{  //availability_zone key not present in input JSON 
        log.info("Input does not contain the key 'availability_zone'")
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

    //Connnector Call
    response = connector_call.sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        log.info("Subnet Created Successfully.");
        output.set("user_message","Subnet Created Successfully")
                .set("exit-code",response_exitcode)
                .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_subnet.js' successfully");
    }
    else{
        log.error("Failure in creating subnet, message: "+response_message+" | exitcode:"+response_exitcode);
        output.set("exit-code",response_exitcode).set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_subnet.js' with errors");
    }

}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
