/**
 * Creation Date:6/06/2019
 * Summary: To subnet on AWS
 * Description: To subnet on AWS using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:describe_subnet.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "describe-subnet";
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

    //Subnet ID 
    if(input_scope.hasOwnProperty("subnet_id")){
        subnet_id = input.get("subnet_id");
        if(subnet_id!=null || subnet_id!=""){
            connector_call.set("subnet-id",subnet_id); 
            log.info("Subnet ID: "+subnet_id);
        }
        else{
            log.info("Subnet ID is null or empty string.")
        }
    }
    else{  //subnet_id key not present in input JSON 
        log.info("Input does not contain the key 'subnet_id'")
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

    //Response Parameter
    subnet_details = response.get("subnet-details");

    if(response_exitcode==0){
        user_message = "<b>The Subnet Details are:</b><ul>" + 
                        "    <li><b>Subnet ID:</b> "+subnet_details.get("subnet-id")+"</li>"+
                        "    <li><b>CIDR Block:</b> "+subnet_details.get("cidr-block")+"</li>"+
                        "    <li><b>VPC ID:</b> "+subnet_details.get("vpc-id")+"</li>"+
                        "    <li><b>Availabilty Zone:</b> "+subnet_details.get("availability-zone")+"</li></ul>";
        log.info(user_message);
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("user_message",user_message)
            .set("result",subnet_details);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_subnet.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_subnet.js' with errors")
    }

}
else{    //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}