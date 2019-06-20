/**
 * Creation Date: 28/05/2019
 * Summary: To reboot one or more instance on AWS
 * Description: To reboot one or more instance on AWS using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:reboot_instance.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "reboot-instances";
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

    //Instance ID - mandatory
    if(input_scope.hasOwnProperty("instance_id")){
        instance_id = input.get("instance_id");
        if(instance_id!=null || instance_id!=""){
            index = instance_id.indexOf(","); //to check if the user has entered more than one instance-IDs
            if(index!=-1){
                instance_id = instance_id.split(","); //to form an array
                connector_call.set("instance-id",instance_id); 
                log.info("Instance ID: "+instance_id);
            }
            else{
                instance_id_array = []; //to form an array
                instance_id_array.push(instance_id);
                connector_call.set("instance-id",instance_id_array); 
                log.info("Instance ID: "+instance_id_array);
            }
        }
        else{
            log.error("Instance ID is null or empty string.")
        }
    }
    else{  //instance_id key not present in input JSON 
        log.error("Input does not contain the key 'instance_id'")
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

    //Connector Call
    response = connector_call.sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    //Response Parameters
    instance_set = response.get("reboot-instance-id");

    if(response_exitcode==0){
        /*user_message = "";
        for(i = 0; i<instance_set.length ; i++){
            log.info("Instance ID: "+instance_set[i].get("instance-id")+" | Current State: "+instance_set[i].get("current-state")+" | Previous State: "+instance_set[i].get("previous-state"));
            user_message = user_message + "Instance ID: "+instance_set[i].get("instance-id")+" | Current State: "+instance_set[i].get("current-state")+" | Previous State: "+instance_set[i].get("previous-state")+"<br>";
        }*/
        log.info("Instances Rebooted Successfully");
        output.set("user_message",instance_set)
            .set("exit-code",response_exitcode)
            .set("message",response_message)
            .set("result",instance_set);
        log.trace("Finished executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:reboot_instance.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:reboot_instance.js' with errors")
    }
}
else{ //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}