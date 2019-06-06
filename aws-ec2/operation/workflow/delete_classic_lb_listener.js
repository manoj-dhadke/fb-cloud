/*
*Creation Date: 31/05/2019
*Summary: To delete an Classic Load Balancer Listener
*Description: To Delete an Classic Load balancer Listener using aws-ec2 Connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:delete_classic_lb_listener.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "delete-classic-load-balancer-listener";
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

    //List of Load Balancer Ports - mandatory
    if(input_scope.hasOwnProperty("list_of_load_balancer_ports")){
        list_of_load_balancer_ports = input.get("list_of_load_balancer_ports");
        if(list_of_load_balancer_ports!=null || list_of_load_balancer_ports!=""){
            index = list_of_load_balancer_ports.indexOf(",");

            if(index!=-1){ //If list has more than one Ports
                list_of_load_balancer_ports = list_of_load_balancer_ports.split(",");
                connector_call.set("list-of-load-balancer-ports",list_of_load_balancer_ports); 
                log.info("List of Load Balancer Ports: "+list_of_load_balancer_ports);
            }
            else{ //If list has only one Port
                arr = "\["+[list_of_load_balancer_ports]+"\]"
                //load_balancer_ports_array = [];
                arr = util.json(arr)
                //load_balancer_ports_array.push(parseInt(list_of_load_balancer_ports));
                connector_call.set("list-of-load-balancer-ports",arr); 
                log.info("Listener ARN List: "+arr);
            }
        }
        else{
            log.error("list_of_load_balancer_ports is null or empty string.")
        }
    }
    else{  //list_of_load_balancer_ports key not present in input JSON 
      log.error("Input does not contain the key 'list_of_load_balancer_ports'")
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
    response = connector_call.sync();

    //Response meta-parameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        log.info("Classic Load Balancer Listener Deleted Successfully.");
        user_message = "Classic Load Balancer Listener Deleted Successfully.";
        output.set("exit-code",0)
              .set("user_message",user_message)
              .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_classic_lb_listener.js' successfully.");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:delete_classic_lb_listener.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}