/*
 * Creation Date: 31/05/2019
 * Summary: To describe load balancer
 * Description: To describe load balancer AWs using aws-ec2 connector
 */

log.trace("Started executing 'fb-cloud:aws-ec2:operation:workflow:describe_load_balancer.js'");

input_scope = JSON.parse(input);   //For checking if the input contains the necessary keys

//Connector Name  - mandatory
connector_name = "amazon-ec2";
connector_call = call.connector(connector_name);
log.info("Connector Name: "+connector_name);

//Action - mandatory
action = "describe-load-balancer";
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

    //Load Balancer Name
    if(input_scope.hasOwnProperty("load_balancer_name")){
        load_balancer_name = input.get("load_balancer_name");
        if(load_balancer_name!=null || load_balancer_name!=""){
            connector_call.set("name",load_balancer_name); 
            log.info("Load Balancer Name: "+load_balancer_name);
        }
        else{
            log.error("Load Balancer Name is null or empty string.")
        }
    }
    else{  //load_balancer_name key not present in input JSON 
        log.error("Input does not contain the key 'load_balancer_name'")
    }

    //Region -mandatory
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

    //Response Parameters
    load_balancers_details = response.get("load-balancers-details"); //array containing a JSON Object
    load_balancers_details = load_balancers_details[0];

    if(response_exitcode==0){
        user_message = "Application Load Balancer Details are:<br>"
                        +"Name: "+load_balancers_details.get("name")+"<br>"
                        +"VPC ID: "+load_balancers_details.get("vpc-id")+"<br>";
        log.info(user_message);
        output.set("exit-code",0)
              .set("user_message",user_message)
              .set("message",response_message)
              .set("result",load_balancers_details);
        log.trace("Finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_load_balancer.js' successfully.");
    }
    else{
        log.error("Failure in execution, message:"+response_message+" | exitcode:"+response_exitcode);
        output.set("error",response_message).set("exit-code",-1);
        log.trace("finished executing 'fb-cloud:aws-ec2:operation:workflow:describe_load_balancer.js' with errors")
    }
}
else{   //cloud_connection key not present in input JSON
    log.error("Cloud Connection not given. Can not authenticate without Secret-Key and Access-Key");
}

/*{
      "name": "Test",
      "schema": "internet-facing",
      "vpc-id": "vpc-4ede6d34",
      "dns-name": "Test-510573296.us-east-1.elb.amazonaws.com",
      "canonical-hosted-zone-name": "Test-510573296.us-east-1.elb.amazonaws.com",
      "canonical-hosted-zone-id": "Z35SXDOTRQ7X7K",
      "created-time": "Fri May 31 15:57:21 IST 2019",
      "listener-details": [
        {
          "key": 8081,
          "instance-port": 8081,
          "instance-protocol": "HTTP",
          "protocol": "HTTP",
          "ssl-certificate-id": null,
          "load-balancer-port": 26
        }
      ],
      "availability-zone": [
        "us-east-1b",
        "us-east-1c"
      ],
      "backend-server-description": [],
      "healthcheck-details": {
        "healthy-threshold": 10,
        "interval": 30,
        "target": "TCP:8081",
        "timeout": "TCP:8081",
        "unhealthy-threshold": 2
      },
      "policy-details": {
        "app-cookie-stickness-policy-details": [],
        "lb-cookie-stickness-policy-details": [],
        "other-policy-details": []
      },
      "subnet-list": [
        "subnet-c6eadd8c",
        "subnet-dab8daf4"
      ],
      "security-group-list": [
        "sg-509aa312"
      ],
      "source-security-group-details": {
        "group-name": "default",
        "owner-alias": "026434237240"
      },
      "instance-id-list": []
    } */