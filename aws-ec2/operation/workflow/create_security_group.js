/**
 * Creation Date: 28/05/2019
 * Summary: To create security group on AWS
 * Description: To create security group using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:create_security_group.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "create-security-group";
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

    //Group Name - mandatory
    if(input_scope.hasOwnProperty("group_name")){
        group_name = input.get("group_name");
        if(group_name!=null || group_name!=""){
            connector_call.set("group-name",group_name); 
            log.info("Group Name: "+group_name);
        }
        else{
            log.error("Group Name is null or empty string.")
        }
    }
    else{  //group_name key not present in input JSON 
        log.error("Input does not contain the key 'group_name'")
    }

    //Group Discription - mandatory
    if(input_scope.hasOwnProperty("group_description")){
        group_description = input.get("group_description");
        if(group_description!=null || group_description!=""){
            connector_call.set("group-description",group_description); 
            log.info("Group Description: "+group_description);
        }
        else{
            log.error("Group Description is null or empty string.")
        }
    }
    else{  //group_description key not present in input JSON 
        log.error("Input does not contain the key 'group_description'")
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

    //Connector call
    response = connector_call.sync();

    //Response meta-parameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    //Response Result
    group_id = response.get("group-id");

    if(response_exitcode==0){
        log.info("Successfully created a Security Group");
        user_message = "Successfully created a Security Group with <b>Group-ID: "+group_id+"</b>";
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message",user_message)
            .set("result",group_id);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_security_group.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:create_security_group.js' with errors")
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}