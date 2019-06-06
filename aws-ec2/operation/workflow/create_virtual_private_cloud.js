/*
 * Creation Date: 29/05/2019
 * Summary: To create virtual private cloud
 * Description: To create virtual private cloud on AWs using aws-ec2 connector
 */

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:create_virtual_private_cloud.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "create-vpc";
log.info("Action: "+action);

//Timeout
request_timeout = 60000;
log.info("Timeout: "+request_timeout);

connector_call.set("timeout",request_timeout).set("action",action);

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

    //CIDR Block - mandatory
    if(input_scope.hasOwnProperty("cidr_block")){
        cidr_block = input.get("cidr_block");
        if(cidr_block!=null || cidr_block!=""){
            connector_call.set("cidr-block",cidr_block); 
            log.info("CIDR Block: "+cidr_block);
        }
        else{
            log.error("CIDR Block is null or empty string.")
        }
    }
    else{  //cidr_block key not present in input JSON 
        log.error("Input does not contain the key 'cidr_block'")
    }

    //Name - not mandatory
    if(input_scope.hasOwnProperty("name")){
        name = input.get("name");
        if(name!=null || name!=""){
            connector_call.set("name",name); 
            log.info("Name: "+name);
        }
        else{
            log.info("Name is null or empty string.")
        }
    }
    else{  //name key not present in input JSON 
        log.info("Input does not contain the key 'name'")
    }

    //Tenancy - not mandatory
    if(input_scope.hasOwnProperty("tenancy")){
        tenancy = input.get("tenancy");
        if(tenancy!=null || tenancy!=""){
            connector_call.set("tenancy",tenancy); 
            log.info("Tenancy: "+tenancy);
        }
        else{
            log.info("tenancy is null or empty string.")
        }
    }
    else{  //tenancy key not present in input JSON 
        log.info("Input does not contain the key 'tenancy'")
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
        log.info("Virtual Private Cloud Created Successfully.");
        user_message = "Virtual Private Cloud Created Successfully.";
        output.set("exit-code",0)
              .set("user_message",user_message)
              .set("message",response_message);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:create_virtual_private_cloud.js' successfully.");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:create_virtual_private_cloud.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}