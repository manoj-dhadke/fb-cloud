/**
 * Creation Date: 10/06/2019
 * Summary: To take Snapshot of a Volume
 * Description: To take Snapshot of a Volume on AWS EC2 using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:take_snapshot.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "take-snapshot-of-volume";
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

    //Volume ID - mandatory
    if(input_scope.hasOwnProperty("volume_id")){
        volume_id = input.get("volume_id");
        if(volume_id!=null || volume_id!=""){
            connector_call.set("volume-id",volume_id); 
            log.info("Volume ID: "+volume_id);
        }
        else{
            log.error("Volume ID is null or empty string.")
        }
    }
    else{  //volume_id key not present in input JSON 
        log.error("Input does not contain the key 'volume_id'")
    }

    //Discription - mandatory
    if(input_scope.hasOwnProperty("description")){
        description = input.get("description");
        if(description!=null || description!=""){
            connector_call.set("description",description); 
            log.info("Description: "+description);
        }
        else{
            log.error("Description is null or empty string.")
        }
    }
    else{  //description key not present in input JSON 
        log.error("Input does not contain the key 'description'")
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

    if(response_exitcode==0){
        log.info("Snapshot of Volume taken Successfully");
        user_message = "Snapshot of Volume taken Successfully";
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message",user_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:take_snapshot.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:take_snapshot.js' with errors")
    }

}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}