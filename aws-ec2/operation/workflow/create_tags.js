/**
 * Creation Date: 23/05/2019
 * Summary: To create tags on AWS
 * Description: To create tags on AWS using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:create_tags.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "create-tags";
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

    //Resource ID
    if(input_scope.hasOwnProperty("resource_id")){
        resource_id = input.get("resource_id");
        if(resource_id!=null || resource_id!=""){
            connector_call.set("resource-id",resource_id); 
            log.info("Resource ID: "+resource_id);
        }
        else{
            log.error("Resource ID is null or empty string.")
        }
    }
    else{  //resource_id key not present in input JSON 
        log.error("Input does not contain the key 'resource_id'")
    }

    //Tag Key
    if(input_scope.hasOwnProperty("tag_key")){
        tag_key = input.get("tag_key");
        if(tag_key!=null || tag_key!=""){
            connector_call.set("tag-key",tag_key); 
            log.info("Tag Key: "+tag_key);
        }
        else{
            log.error("Tag Key is null or empty string.")
        }
    }
    else{  //tag_key key not present in input JSON 
        log.error("Input does not contain the key 'tag_key'")
    }

    //Tag Value
    if(input_scope.hasOwnProperty("tag_value")){
        tag_value = input.get("tag_value");
        if(tag_value!=null || tag_value!=""){
            connector_call.set("tag-value",tag_value); 
            log.info("Tag Value: "+tag_value);
        }
        else{
            log.error("Tag value is null or empty string.")
        }
    }
    else{  //tag_value key not present in input JSON 
        log.error("Input does not contain the key 'tag_value'")
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
    response = connector_call.sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        log.info("Tags Created Successfully");
        output.set("user_message","Tags Created Successfully")
            .set("exit-code",response_exitcode)
            .set("message",response_message);
        log.trace("Finished executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:create_tags.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:create_tags.js' with errors")
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}