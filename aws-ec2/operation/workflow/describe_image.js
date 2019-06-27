/**
 * Creation Date: 7/06/2019
 * Summary: To Describe Image on AWS
 * Description: To Describe Image on AWS EC2 using aws-ec2 connector
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:describe_image.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "describe-image";
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

    //Image ID
    if(input_scope.hasOwnProperty("image_id")){
        image_id = input.get("image_id");
        if(image_id!=null || image_id!=""){
            connector_call.set("image-id",image_id); 
            log.info("Image ID: "+image_id);
        }
        else{
            log.error("Image ID is null or empty string.")
        }
    }
    else{  //image_id key not present in input JSON 
        log.error("Input does not contain the key 'image_id'")
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
    image_info = response.get("image-info");

    if(response_exitcode==0){
        user_message = "<b>The Image Description is:</b><ul>";
        user_message = user_message + "    <li><b>Architecture:</b> "+image_info.get("architecture")+"</li>"+
                        "    <li><b>Description:</b> "+image_info.get("description")+"</li>"+
                        "    <li><b>Image Type:</b> "+image_info.get("image-type")+"</li>"+
                        "    <li><b>Image Name:</b> "+image_info.get("image-name")+"</li>"+
                        "    <li><b>Image Location:</b> "+image_info.get("image-location")+"</li>"+
                        "    <li><b>Kernel ID:</b> "+image_info.get("kernel-id")+"</li>"+
                        "    <li><b>Hypervisor:</b> "+image_info.get("hypervisor")+"</li></ul>";
        log.info(user_message);
        output.set("user_message",user_message)
            .set("exit-code",response_exitcode)
            .set("message",response_message)
            .set("result",image_info);
        log.trace("Finished executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:describe_image.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_image.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}