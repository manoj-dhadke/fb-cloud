/**
 * Creation Date: 10/06/2019
 * Summary: To list Volumes
 * Description: To list Volumes on AWS EC2 using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:list_volumes.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "list-volumes";
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

    //Connector call
    response = connector_call.sync();
   
    //Response meta-parameters
    response_exitcode = response.exitcode();
    response_message = response.message();
   
    //Response Result
    volume_list = response.get("volume-list");
    
    if(response_exitcode==0){
       
       if(volume_list.length>1){
           user_message = "The List of Volumes is:<br>";
            for(i=0;i<volume_list.length;i++){
                user_message = user_message+"Volume"+(i+1)+":<br>"+
                               "Volume ID: "+volume_list[i].get("volume-id")+"<br>"+
                               "Volume Type: "+volume_list[i].get("volume-type")+"<br>"+
                               "Size: "+volume_list[i].get("size")+"<br>"+
                               "Snapshot ID: "+volume_list[i].get("snapshot-id")+"<br>"+
                               "Availability Zone: "+volume_list[i].get("availability-zone")+"<br>";
            }
            output.set("user_message",user_message);
        }
        else{ //If no volumes available in the given Region
            user_message = "No Volumes Available in the given Region.";
            output.set("user_message",user_message);
        }
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("result",volume_list);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:list_volumes.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:list_volumes.js' with errors")
    }

}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}