/*
*Creation Date: 7/06/2019
*Summary: To Deregister Instances with Classic Load Balancer on AWS EC2
*Description: To Deregister Instances with Classic Load Balancer on AWS EC2 using aws-ec2 Connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:deregister_instances_with_classic_load_balancer.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "deregister-instance-with-classic-load-balancer";
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

    //Load Balancer Name - mandatory
    if(input_scope.hasOwnProperty("load_balancer_name")){
        load_balancer_name = input.get("load_balancer_name");
        if(load_balancer_name!=null || load_balancer_name!=""){
            connector_call.set("load-balancer-name",load_balancer_name); 
            log.info("Load Balancer Name: "+load_balancer_name);
        }
        else{
            log.error("load_balancer_name is null or empty string.");
        }
    }
    else{  //load_balancer_name key not present in input JSON 
        log.error("Input does not contain the key 'load_balancer_name'");
    }

    //Instances To Deregister - mandatory
    if(input_scope.hasOwnProperty("instances_to_deregister")){
        instances_to_deregister = input.get("instances_to_deregister");
        if(instances_to_deregister!=null || instances_to_deregister!=""){
            
            index = instances_to_deregister.indexOf(",");
            if(index!=-1){
                instances_to_deregister = instances_to_deregister.split(",");
                connector_call.set("instance-id-list",instances_to_deregister); 
                log.info("Instances to Deregister: "+instances_to_deregister);
            }
            else{
                instances_array = [];
                instances_array.push(instances_to_deregister);
                connector_call.set("instance-id-list",instances_array); 
                log.info("Instances to Deregister: "+instances_array);
            }
        }
        else{
            log.error("instances_to_deregister is null or empty string.");
        }
    }
    else{  //instances_to_deregister key not present in input JSON 
        log.error("Input does not contain the key 'instances_to_deregister'");
    }

    //Region - mandatory
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

    //Connector Call
    response = connector_call.sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    if(response_exitcode==0){
        output.set("exit-code",response_exitcode)
                .set("message",response_message)
                .set("user_message","Instances Deregistered Successfully.");
        log.info("Instances Deregistered Successfully.");
        log.trace("Finished executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:deregister_instances_with_classic_load_balancer.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:deregister_instances_with_classic_load_balancer.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}