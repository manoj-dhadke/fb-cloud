/*
 * Creation Date: 28/05/2019
 * Summary: To associate subnet IPv6 CIDR Block
 * Description: To associate subnet IPv6 CIDR Block on AWS using aws-ec2 connector
 */

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:associate_subnet_ipv6_cidr_block.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "associate-subnet-ipv6-cidr-block";
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

    //Subnet ID - mandatory
    if(input_scope.hasOwnProperty("subnet_id")){
        subnet_id = input.get("subnet_id");
        if(subnet_id!=null || subnet_id!=""){
            connector_call.set("subnet-id",subnet_id); 
            log.info("Subnet ID: "+subnet_id);
        }
        else{
            log.error("Subnet ID is null or empty string.")
        }
    }
    else{  //subnet_id key not present in input JSON 
        log.error("Input does not contain the key 'subnet_id'")
    }

    //CIDR Block - mandatory
    if(input_scope.hasOwnProperty("cidr_block")){
        cidr_block = input.get("cidr_block");
        if(cidr_block!=null || cidr_block!=""){
            connector_call.set("cidr-block",cidr_block); 
            log.info("CIDR Block: "+cidr_block);
        }
        else{
            log.error("CIDR Block is null or empty string.")
        }
    }
    else{  //cidr_block key not present in input JSON 
        log.error("Input does not contain the key 'cidr_block'")
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
        log.info("Associated Subnet IPv6 CIDR Block successfully.");
        output.set("user_message","Associated Subnet IPv6 CIDR Block successfully.")
                .set("exit-code",response_exitcode)
                .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:associate_subnet_ipv6_cidr_block.js' successfully.")
    }
    else{
        log.error("Associating Subnet IPv6 CIDR Block Failed, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("message",response_message).set("exit-code",response_exitcode);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:associate_subnet_ipv6_cidr_block.js' with errors")
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");  
}