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

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:add_security_group_rule.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "security-group-add-rule";
log.info("Action: "+action);

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

    //Security Group ID - mandatory
    if(input_scope.hasOwnProperty("security_group_id")){
        security_group_id = input.get("security_group_id");
        if(security_group_id!=null || security_group_id!=""){
            connector_call.set("security-group-id",security_group_id); 
            log.info("Security Group ID: "+security_group_id);
        }
        else{
            log.error("Security Group ID is null or empty string.")
        }
    }
    else{  //security_group_id key not present in input JSON 
        log.error("Input does not contain the key 'security_group_id'")
    }

    //Direction - mandatory
    if(input_scope.hasOwnProperty("direction")){
        direction = input.get("direction");
        if(direction!=null || direction!=""){
            connector_call.set("direction",direction); 
            log.info("Direction: "+direction);
        }
        else{
            log.error("Direction is null or empty string.")
        }
    }
    else{  //direction key not present in input JSON 
        log.error("Input does not contain the key 'direction'")
    }

    //Protocol - mandatory
    if(input_scope.hasOwnProperty("protocol")){
        protocol = input.get("protocol");
        if(protocol!=null || protocol!=""){
            connector_call.set("protocol",protocol); 
            log.info("Protocol: "+protocol);
        }
        else{
            log.error("Protocol is null or empty string.")
        }
    }
    else{  //protocol key not present in input JSON 
        log.error("Input does not contain the key 'protocol'")
    }

    //From port - mandatory
    if(input_scope.hasOwnProperty("from_port")){
        from_port = input.get("from_port");
        if(from_port!=null || from_port!=""){
            connector_call.set("from-port",from_port); 
            log.info("From port: "+from_port);
        }
        else{
            log.error("from_port is null or empty string.")
        }
    }
    else{  //from_port key not present in input JSON 
        log.error("Input does not contain the key 'from_port'")
    }

    //To port - mandatory
    if(input_scope.hasOwnProperty("to_port")){
        to_port = input.get("to_port");
        if(to_port!=null || to_port!=""){
            connector_call.set("to-port",to_port); 
            log.info("To port: "+to_port);
        }
        else{
            log.error("to_port is null or empty string.")
        }
    }
    else{  //to_port key not present in input JSON 
        log.error("Input does not contain the key 'to_port'")
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

    //IP Range - NOT mandatory
    if(input_scope.hasOwnProperty("ip_range")){
        ip_range = input.get("ip_range");
        if(ip_range!=null || ip_range!=""){
            connector_call.set("ip-range",ip_range); 
            log.info("IP range: "+ip_range);
        }
        else{
            log.info("IP Range not given");
        }
    }
    else{
        log.info("Input does not contain the key 'ip_range'");
    }

    //CIDR Block - NOT mandatory
    if(input_scope.hasOwnProperty("cidr_block")){
        cidr_block = input.get("cidr_block");
        if(cidr_block!=null || cidr_block!=""){
            connector_call.set("cidr-block",cidr_block); 
            log.info("CIDR block: "+cidr_block);
        }
        else{
            log.info("CIDR Block not given");
        }
    }
    else{
        log.info("Input does not contain the key 'cidr_block'");
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
    response = connector_call.set("action",action).sync();

    //Response meta-parameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        log.info("Successfully added a Security Group Rule");
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message","Successfully added a Security Group Rule");
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:add_security_group_rule.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:add_security_group_rule.js' with errors")
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
