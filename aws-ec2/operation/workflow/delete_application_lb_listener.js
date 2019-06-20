/*
*Creation Date: 31/05/2019
*Summary: To delete an Application Load Balancer Listener
*Description: To Delete an Application Load balancer Listener using aws-ec2 Connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:delete_application_lb_listener.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "delete-application-load-balancer-listener";
log.info("Action: "+action);

//Timeout
request_timeout = 60000;
log.info("Timeout: "+request_timeout);

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

    //Listeners ARN List - mandatory
    if(input_scope.hasOwnProperty("listener_arn_list")){
        listener_arn_list = input.get("listener_arn_list");
        if(listener_arn_list!=null || listener_arn_list!=""){
            index = listener_arn_list.indexOf(",");
            if(index!=-1){ //If list has more than one ARNs
                listener_arn_list = listener_arn_list.split(",");
                connector_call.set("arn-list",listener_arn_list); 
                log.info("Listener ARN List: "+listener_arn_list);
            }
            else{ //If list has only one ARN
                listener_arn_array = [];
                listener_arn_array.push(listener_arn_list);
                connector_call.set("arn-list",listener_arn_array); 
                log.info("Listener ARN List: "+listener_arn_array);
            }
        }
        else{
            log.error("listener_arn_list is null or empty string.")
        }
    }
    else{  //listener_arn_list key not present in input JSON 
        log.error("Input does not contain the key 'listener_arn_list'")
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
        log.info("Successfully deleted the Application LB Listener.");
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message","Successfully deleted the Application LB Listener.");
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_application_lb_listener.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_application_lb_listener.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}