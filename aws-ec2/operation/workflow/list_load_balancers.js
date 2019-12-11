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

log.trace("Started executing the flintbit 'fb-cloud:aws-ec2:operation:workflow:list_load_balancers.js'");


input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "list-load-balancer";
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
    load_balancers_list = response.get('load-balancers');

    if(response_exitcode==0){

        if(load_balancers_list.length>0){
            user_message = "<b>The Classic Load Balancer Details are:</b><ul>";

            for(i=0;i<load_balancers_list.length;i++){
                user_message = user_message + "    <li><b>Classic Load Balancer "+(i+1)+"</b><ol>"+
                            "        <li><b>Name:</b> "+load_balancers_list[i].get("name")+"</li>"+
                            "        <li><b>VPC ID:</b> "+load_balancers_list[i].get("vpc-id")+"</li>";
                user_message = user_message + "        <li><b>Subnet IDs:</b><ul>";
                subnet_list = load_balancers_list[i].get("subnet-list");
                for(j=0;j<subnet_list.length;j++){
                    user_message = user_message + "          <li>"+subnet_list[j]+"</li>";
                }
                user_message = user_message + "</ul>";
                user_message = user_message + "        <li><b>Instance IDs:</b><ul>";
                instance_id_list = load_balancers_list[i].get("instance-id-list");
                for(j=0;j<instance_id_list.length;j++){
                    user_message = user_message + "          <li>"+instance_id_list[j]+"</li>";
                }
                user_message = user_message + "</ul>";
                user_message = user_message + "</li></ol></li>"
            }
            user_message = user_message + "</ul>";
            log.info(user_message);
            output.set("user_message",user_message);
        }
        else{
            user_message = "No Classic Load Balancers available in the given Region";
            output.set("user_message",user_message);
            log.info(user_message);
        }
        output.set("message",response_message)
            .set("exit-code",response_exitcode)
            .set("result",load_balancers_list);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:list_load_balancers.js' successfully");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:list_load_balancers.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}
