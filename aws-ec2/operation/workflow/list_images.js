/*************************************************************************
 * 
 * INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
 * __________________
 * 
 * (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
 * All Rights Reserved.
 * Product / Project: Flint IT Automation Platform
 * NOTICE:  All information contained herein is, and remains
 * the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
 * The intellectual and technical concepts contained
 * herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
 * Dissemination of this information or any form of reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
 */

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:list_images.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "list-image";
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

    //Account ID - mandatory
    account_id = input_scope.cloud_connection.encryptedCredentials["account_id"];
        if(account_id!=null || account_id!=""){
            connector_call.set("account-id",account_id); 
            log.info("Account ID: "+account_id);
        }
        else{
            log.error("Account ID is null or empty string.")
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
    

    if(response_exitcode==0){
        log.info(response);
        response = JSON.parse(response);
        list_image_array = response["image-list"];

        if(list_image_array.length==0){
            user_message = "The Given Region Does Not Contain any Images";
        }
        else{
            user_message = "<b>The List of Images is:</b><ul>";
            for(i=0 ; i<list_image_array.length ; i++){
                image_info = list_image_array[i]
                user_message = user_message + "    <li><b>Image "+(i+1)+"</b><ol>"+
                "        <li><b>Image ID:</b> "+image_info["image-id"]+"</li>"+
                "        <li><b>Image Type:</b> "+image_info["image-type"]+"</li>"+
                "        <li><b>Image Name:</b> "+image_info["image-name"]+"</li>"+
                "        <li><b>Image Location:</b> "+image_info["image-location"]+"</li>"+
                "        <li><b>Description:</b> "+image_info["description"]+"</li>"+
                "        <li><b>Hypervisor:</b> "+image_info["hypervisor"]+"</li></ol>";
            }
             
            user_message = user_message + "</ul>";
        }
        output.set("exit-code",response_exitcode)
            .set("message",response_message)
            .set("result",response)
            .set("user_message",user_message);
        log.trace("Finished executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:list_images.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:list_images.js' with errors")
    }

}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
