/*
*Creation Date: 30/05/2019
*Summary: To delete an Application Load Balancer
*Description: To Delete an Application Load balancer using aws-ec2 Connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:delete_application_load_balancer.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "delete-application-load-balancer";
log.info("Action: "+action);

//Timeout
request_timeout = 60000;
log.info("Timeout: "+request_timeout);

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

    //Load Balancer ARN - mandatory
    if(input_scope.hasOwnProperty("load_balancer_arn")){
        load_balancer_arn = input.get("load_balancer_arn");
        if(load_balancer_arn!=null || load_balancer_arn!=""){
            connector_call.set("load-balancer-arn",load_balancer_arn); 
            log.info("Load Balancer ARN: "+load_balancer_arn);
        }
        else{
            log.error("load_balancer_arn is null or empty string.")
        }
    }
    else{  //load_balancer_arn key not present in input JSON 
        log.error("Input does not contain the key 'load_balancer_arn'")
    }

    //Load Balancer Name - not Mandatory
    if(input_scope.hasOwnProperty("load_balancer_name")){
        load_balancer_name = input.get("load_balancer_name");
        if(load_balancer_name!=null || load_balancer_name!=""){
            connector_call.set("name",load_balancer_name); 
            log.info("Load Balancer Name: "+load_balancer_name);
        }
        else{
            log.info("load_balancer_name is null or empty string.")
        }
    }
    else{  //load_balancer_name key not present in input JSON 
        log.info("Input does not contain the key 'load_balancer_name'")
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
    response = connector_call.set("action",action).set("timeout",request_timeout).sync();

    //Response meta-parameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        log.info("Successfully deleted the Application Load Balancer.");
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message","Successfully deleted the Application Load Balancer.");
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_application_load_balancer.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_application_load_balancer.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}