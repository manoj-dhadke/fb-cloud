/*
 * Creation Date: 29/05/2019
 * Summary: To create application load balancer
 * Description: To create application load balancer AWs using aws-ec2 connector
 */

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:create_classic_load_balancer.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "create-classic-load-balancer";
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
            connector_call.set("name",load_balancer_name); 
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
            log.info("Listener - Load Balancer Protocol: "+lb_listener_protocol);
        }
        else{
            log.error("'listener_-_load_balancer_protocol' is null or empty string.")
        }
    }
    else{  //listener_-_load_balancer_protocol key not present in input JSON 
        log.error("Input does not contain the key 'listener_-_load_balancer_protocol'")
    }

    //LB Listener Port
    if(input_scope.hasOwnProperty("listener_-_load_balancer_port")){
        lb_listener_port = input.get("listener_-_load_balancer_port");
        if(lb_listener_port!=null || lb_listener_port!=""){
            json_listener = json_listener + '"loadBalancerPort":'+lb_listener_port+',';
            log.info("Listener - Load Balancer Port: "+lb_listener_port);
        }
        else{
            log.error("'listener_-_load_balancer_port' is null or empty string.")
        }
    }
    else{  //listener_-_load_balancer_port key not present in input JSON 
        log.error("Input does not contain the key 'listener_-_load_balancer_port'")
    }

    //LB Listener Instance Port
    if(input_scope.hasOwnProperty("listener_-_instance_port")){
        lb_listener_instance_port = input.get("listener_-_instance_port");
        if(lb_listener_instance_port!=null || lb_listener_instance_port!=""){
            json_listener = json_listener + '"instancePort":'+lb_listener_instance_port+'}';
            log.info("Listener - Instance Port: "+lb_listener_instance_port);
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

    //Subnet ID - mandatory
    if(input_scope.hasOwnProperty("subnet_id")){
        subnet_id = input.get("subnet_id");
        index = subnet_id.indexOf(","); //to check that user has entered minimum 2 subnet-IDs
        if(index!=-1){
            subnet_id = subnet_id.split(","); //Splitting into an array
            connector_call.set("subnets",subnet_id); //Passing an array
            log.info("Subnets: "+subnet_id);
        }
        else if(subnet_id.length>1){ //If user enters only one Subnet-ID
            subnet_array = [];
            subnet_array.push(subnet_id);
            connector_call.set("subnets",subnet_array); //Passing an array
            log.info("Subnets: "+subnet_array);
        }
        else{
            log.error("subnet_id is null or empty.")
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

    //Scheme - not mandatory
    if(input_scope.hasOwnProperty("scheme")){
        scheme = input.get("scheme");
        if(scheme!=null || scheme!=""){
            connector_call.set("scheme",scheme); 
            log.info("scheme: "+scheme);
        }
        else{
            log.info("scheme is null or empty string.");
        }
    }
    else{  //scheme key not present in input JSON 
        log.info("Input does not contain the key 'scheme'");
    }

    //Security Groups - not mandatory
    if(input_scope.hasOwnProperty("security_groups")){
        security_groups = input.get("security_groups");
        if(security_groups!=null || security_groups!=""){
            index = security_groups.indexOf(",");
            if(index!=-1){
                security_groups = security_groups.split(",");
                connector_call.set("security-groups",security_groups); 
                log.info("security_groups: "+security_groups);
            }
            else{
                security_groups_array = [];
                security_groups_array.push(security_groups);
                connector_call.set("security-groups",security_groups_array); 
                log.info("security_groups: "+security_groups_array);
            }
        }
        else{
            log.info("security_groups is null or empty string.");
        }
    }
    else{  //security_groups key not present in input JSON 
        log.info("Input does not contain the key 'security_groups'");
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
        log.info("Classic Load Balancer Created Successfully.");
        user_message = "Classic Load Balancer Created Successfully.";
        output.set("exit-code",0)
              .set("user_message",user_message)
              .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_classic_load_balancer.js' successfully.");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:create_classic_load_balancer.js' with errors")
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
