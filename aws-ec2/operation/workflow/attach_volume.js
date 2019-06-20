/*
 * Creation Date: 28/05/2019
 * Summary: To attach volume on AWS
 * Description: To attach volume on AWs using aws-ec2 connector
 */

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:attach_volume.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "attach-volume";
log.info("Action: "+action);

//Timeout
request_timeout = 60000;
log.info("Timeout: "+timeout);

connector_call.set("action",action).set("timeout",request_timeout);

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

    //Volume ID
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

    //Instance ID
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

    //Device Name
    if(input_scope.hasOwnProperty("device_name")){
        device_name = input.get("device_name");
        if(device_name!=null || device_name!=""){
            connector_call.set("device-name",device_name); 
            log.info("Device Name: "+device_name);
        }
        else{
            log.error("Device Name is null or empty string.")
        }
    }
    else{  //device_name key not present in input JSON 
        log.error("Input does not contain the key 'device_name'")
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

    //Connnector Call
    response = connector_call.sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        log.info("Successfully Attached Volume.");
        output.set("user_message","Successfully Attached Volume.")
                .set("exit-code",response_exitcode)
                .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:attach_volume.js' successfully");
    }
    else{
        log.error("Failure in attaching the volume, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("message",response_message).set("exit-code",response_exitcode);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:attach_volume.js' with errors");
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}