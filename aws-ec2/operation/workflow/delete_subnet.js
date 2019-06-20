/*
 * Creation Date: 3/06/2019
 * Summary: To delete subnet on AWS EC2
 * Description: To delete subnet on AWS using aws-ec2 connector
 */

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:delete_subnet.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "delete-subnet";
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
            log.error("subnet_id Name is null or empty string.")
        }
    }
    else{  //subnet_id key not present in input JSON 
        log.error("Input does not contain the key 'subnet_id'")
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
        log.info("Subnet Deleted Successfully.");
        output.set("user_message","Subnet Deleted Successfully")
                .set("exit-code",response_exitcode)
                .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_subnet.js' successfully");
    }
    else{
        log.error("Failure in creating subnet, message: "+response_message+" | exitcode:"+response_exitcode);
        output.set("exit-code",response_exitcode).set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_subnet.js' with errors");
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}