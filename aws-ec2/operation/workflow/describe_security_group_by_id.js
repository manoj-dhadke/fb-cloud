/**
 * Creation Date: 3/06/2019
 * Summary: To describe security group on AWS
 * Description: To describe security group using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:describe_security_group_by_id.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "describe-security-group";
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

    //Group ID - mandatory
    if(input_scope.hasOwnProperty("security_group_id")){
        security_group_id = input.get("security_group_id");
        if(security_group_id!=null || security_group_id!=""){
            connector_call.set("security-group-id",security_group_id); 
            log.info("Group ID: "+security_group_id);
        }
        else{
            log.error("Group ID is null or empty string.")
        }
    }
    else{  //security_group_id key not present in input JSON 
        log.error("Input does not contain the key 'security_group_id'")
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

    //Response Parameter
    security_group_info = response.get('security-group-info'); //Array containing a single JSON
    security_group_info = security_group_info[0];

    if(response_exitcode==0){
        user_message = "The details of the Security Group are:<br>"
                        +"Group Name: "+security_group_info.get("group-name")+"<br>"
                        +"Group Description: "+security_group_info.get("group-description")+"<br>"
                        +"Group ID: "+security_group_info.get("group-id")+"<br>"
                        +"VPC ID: "+security_group_info.get("vpc-id")+"<br>";
        
        ip_info_array = security_group_info["ip-permissions"];
        
        for(i = 0 ; i < ip_info_array.length ; i++){
            ip_info = ip_info_array[i];
            user_message = user_message +"IP Permission "+"<br>"+"IP Protocol: "+ip_info.get("ip-protocol")+"<br>"
                        +"From Port: "+ip_info.get("from-port")+"<br>"
                        +"To Port: "+ip_info.get("to-port")+"<br>";
        }
        log.info(user_message);
        
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message",user_message)
            .set("result",security_group_info);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_security_group_by_id.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_security_group_by_id.js' with errors")
    }

}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}