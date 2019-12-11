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

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:create_classic_lb_listeners.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "create-listener-for-classic-load-balancer";
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

    //Load Balancer Name
    if(input_scope.hasOwnProperty("load_balancer_name")){
        load_balancer_name = input.get("load_balancer_name");
        if(load_balancer_name!=null || load_balancer_name!=""){
            connector_call.set("load-balancer-name",load_balancer_name); 
            log.info("Load Balancer Name: "+load_balancer_name);
        }
        else{
            log.error("Load Balancer Name is null or empty string.")
        }
    }
    else{  //load_balancer_name key not present in input JSON 
        log.error("Input does not contain the key 'load_balancer_name'")
    }

    //Listener
    json_listener='{'; //to transform input into JSON
    //Listener Protocol
    if(input_scope.hasOwnProperty("listener_-_load_balancer_protocol")){
        lb_listener_protocol = input.get("listener_-_load_balancer_protocol");
        if(lb_listener_protocol!=null || lb_listener_protocol!=""){
            json_listener = json_listener + '"protocol":"'+lb_listener_protocol+'",';
            log.info("Listener Protocol: "+lb_listener_protocol);
        }
        else{
            log.error("lb_listener_protocol is null or empty string.")
        }
    }
    else{  //lb_listener_protocol key not present in input JSON 
        log.error("Input does not contain the key 'lb_listener_protocol'")
    }
    //LB Listener Port
    if(input_scope.hasOwnProperty("listener_-_load_balancer_port")){
        lb_listener_port = input.get("listener_-_load_balancer_port");
        if(lb_listener_port!=null || lb_listener_port!=""){
            json_listener = json_listener + '"loadBalancerPort":'+lb_listener_port+',';
            log.info("Load Balancer Listener Port: "+lb_listener_port);
        }
        else{
            log.error("lb_listener_port is null or empty string.")
        }
    }
    else{  //lb_listener_port key not present in input JSON 
        log.error("Input does not contain the key 'lb_listener_port'")
    }
    //LB Listener Instance Port
    if(input_scope.hasOwnProperty("listener_-_instance_port")){
        lb_listener_instance_port = input.get("listener_-_instance_port");
        if(lb_listener_instance_port!=null || lb_listener_instance_port!=""){
            json_listener = json_listener + '"instancePort":'+lb_listener_instance_port+'}';
            log.info("Load Balancer Listener Instance Port: "+lb_listener_instance_port);
        }
        else{
            log.error("lb_listener_instance_port is null or empty string.")
        }
    }
    else{  //lb_listener_instance_port key not present in input JSON 
        log.error("Input does not contain the key 'lb_listener_instance_port'")
    }
    
    if(json_listener.length>1){
        listener = JSON.parse(json_listener); //converting the string into JSON
        listener_array = []; 
        listener_array.push(listener); //Putting the JSON in an array to be passed in the connector
        connector_call.set("listeners",listener_array);
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
        log.info("Classic Load Balancer's Listener has been Created Successfully.");
        output.set("user_message","Classic Load Balancer's Listener has been Created Successfully.")
                .set("exit-code",response_exitcode)
                .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_classic_lb_listeners.js' successfully");
    }
    else{
        log.error("Failure in creating classic listeners, message: "+response_message+" | exitcode:"+response_exitcode);
        output.set("exit-code",response_exitcode).set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_classic_lb_listeners.js' with errors");
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
