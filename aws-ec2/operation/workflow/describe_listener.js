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

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:describe_listener.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "describe-listener";
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

    //Load Balancer ARN
    if(input_scope.hasOwnProperty("load_balancer_arn")){
        load_balancer_arn = input.get("load_balancer_arn");
        if(load_balancer_arn!=null || load_balancer_arn!=""){
            connector_call.set("load-balancer-arn",load_balancer_arn); 
            log.info("Load Balancer ARN: "+load_balancer_arn);
        }
        else{
            log.error("Load Balancer ARN is null or empty string.")
        }
    }
    else{  //load_balancer_arn key not present in input JSON 
        log.error("Input does not contain the key 'load_balancer_arn'")
    }

    //Region -mandatory
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

    //Response Parameters
    listener_details = response.get('listener-details');

    if(response_exitcode==0){
        if(listener_details.length==0){
            user_message = "There are NO Listeners Configured to this Load Balancer.";
        }
        else{
            user_message = "<b>The Load Balancer Listener Details are:</b><ul>";
            for( i = 0 ; i < listener_details.length ; i++ ){
                user_message = user_message + "    <li><b>Listener " + (i+1) + "</b><ol>"
                           +"        <li><b>Listener ARN:</b> "+listener_details[i].get("listener-arn")+"</li>"
                           +"        <li><b>Port:</b> "+listener_details[i].get("port")+"</li>"
                           +"        <li><b>Protocol:</b> "+listener_details[i].get("protocol")+"</li></ol></li>"
            }
            user_message = user_message + "</ul>";
        }
        log.info(user_message);
        output.set("exit-code",0)
              .set("user_message",user_message)
              .set("message",response_message)
              .set("result",listener_details);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_listeners.js' successfully.");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_listeners.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
