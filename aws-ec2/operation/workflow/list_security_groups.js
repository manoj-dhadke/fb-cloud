/*
*Creation Date: 7/06/2019
*Summary: To List Security Groups on AWS EC2
*Description: To List Seurity Groups on AWS EC2 using aws-ec2 Connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:list_security_groups.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "list-security-group";
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

    //Connector Call
    response = connector_call.sync();

    //Response Metaparameters
    response_exitcode = response.exitcode();
    response_message = response.message();

    //Response Parameters
    security_group_list = response.get('security-group-list');

    if(response_exitcode==0){
        
        if(security_group_list.length>0){
            user_message = "The Security Groups are:<br>";

            for(i=0;i<security_group_list.length;i++){
                user_message = user_message + "Security Group"+(i+1)+"<br>"+
                                "Group ID: "+security_group_list[i].get("group-id")+"<br>"+
                                "Group Name: "+security_group_list[i].get("group-name")+"<br>"+
                                "Group Description: "+security_group_list[i].get("group-description")+"<br>"+
                                "VPC ID: "+security_group_list[i].get("vpc-id")+"<br>"+
                                "IP Permissions: "+security_group_list[i].get("ip-permissions")+"<br>";
            }
            log.info(user_message);
            output.set("user_message",user_message);
        }
        else{
            user_message = "No Security Groups in this Region.";
            log.info(user_message);
            output.set("user_message",user_message);
        }
        output.set("exit-code",response_exitcode)
            .set("message",response_message)
            .set("result",security_group_list);
        log.trace("Finished executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:list_security_groups.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:list_security_groups.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}