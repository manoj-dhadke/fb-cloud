/*
 * Creation Date: 31/05/2019
 * Summary: To delete virtual private cloud
 * Description: To delete virtual private cloud on AWs using aws-ec2 connector
 */

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:delete_virtual_private_cloud.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "delete-vpc";
log.info("Action: "+action);

//Timeout
request_timeout = 60000;
log.info("Timeout: "+request_timeout);

connector_call.set("timeout",request_timeout).set("action",action);

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
            log.error("VPC ID is null or empty string.")
        }
    }
    else{  //vpc_id key not present in input JSON 
        log.error("Input does not contain the key 'vpc_id'")
    }

    //Region - not mandatory
    if(input_scope.hasOwnProperty("region")){
        region = input.get("region");
        if(region!=null || region!=""){
            connector_call.set("region",region); 
            log.info("Region: "+region);
        }
        else{
            log.info("Region is null or empty string.");
        }
    }
    else{  //region key not present in input JSON 
        log.info("Input does not contain the key 'region'");
    }

    //Connector call
    response = connector_call.sync();

    //Response meta-parameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        log.info("Virtual Private Cloud Deleted Successfully.");
        user_message = "Virtual Private Cloud Deleted Successfully.";
        output.set("exit-code",0)
              .set("user_message",user_message)
              .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_virtual_private_cloud.js' successfully.");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_virtual_private_cloud.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}