/**
** Creation Date: 11th Oct 2019
** Summary: Create Azure instance flintbit.
** Description: This flintbit is developed to create an Azure instance.
**/
// begin
log.trace("Started executing 'fb-cloud:azure:operation:create_instance.groovy' flintbit...")
try{

    // Flintbit Input Parameters
    // Mandatory
    connector_name = input.get('connector_name')
    action = 'create-instance'
    name = input.get('instance_name')
    region = input.get('region')
    resource_group = input.get('resource_group')
    network_name = input.get('network_name')
    public_ip = name+ '_ip'
    subnet_id = input.get('subnet_id')
    username = input.get('username')
    password = input.get('password')
    os_type = input.get('os_type')
    size = input.get('size')
    image = input.get('image')

    log.trace(connector_name)
    log.trace(action)
    log.trace(name)
    log.trace(region)
    log.trace(resource_group)
    log.trace(network_name)
    log.trace(public_ip)
    log.trace(subnet_id)
    log.trace(username)
    log.trace(password)
    log.trace(os_type)
    log.trace(size)
    log.trace(image)

    // Optional
    key = input.get('key')
    tenant_id = input.get('tenant_id')
    subscription_id = input.get('subscription_id')
    client_id = input.get('client_id')
    log.info("Flintbit input parameters are, action : ${action} | Group name : ${resource_group} | Instance Name : ${name}")
    
    if (connector_name == null || connector_name  ==""){
        throw new Exception('Please provide "MS Azure connector name (connector_name)" to create Instance')
    }

    if (name == null || name  ==""){
        throw new Exception('Please provide "Azure instance name to create Instance')
    }
    if (region == null || region  ==""){
        throw new Exception('Please provide region  to create Instance')
    }
    if (resource_group == null || resource_group  ==""){
        throw new Exception('Please provide resource group name to create Instance')
    }
    if (network_name == null || network_name  ==""){
        throw new Exception('Please provide network name to create Instance')
    }
    if (subnet_id == null || subnet_id  ==""){
        throw new Exception('Please provide subnet id to create Instance')
    }
    if (username == null || username  ==""){
        throw new Exception('Please provide username to create Instance')
    }
    if (password == null || password  ==""){
        throw new Exception('Please provide password to create Instance')
    }
    if (os_type == null || os_type  ==""){
        throw new Exception('Please provide OS type to create Instance')
    }
    if (size == null || size  ==""){
        throw new Exception('Please provide instance size to create Instance')
    }
    if (image == null || image  ==""){
        throw new Exception('Please provide image name to create Instance')
    }
     response = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('client-id', client_id)
                          .set('key', key)
                          .set('instance-name', name)
                          .set('region', region)
                          .set('resource-group', resource_group)
                          .set('public-ip', public_ip)
                          .set('subnet-id', subnet_id)
                          .set('username', username)
                          .set('password', password)
                          .set('os-type', os_type)
                          .set('size', size)
                          .set('image', image)
                          .set('network-name', network_name)
                          .set('network-id', '1')
                          .timeout(2800000)
                          .sync()

    // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if (response_exitcode == 0){
        log.info("SUCCESS in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 0).set('message', response_message)
    }
    else{
        log.error("ERROR in executing ${connector_name} where, exitcode : ${response_exitcode} | message : ${response_message}")
        output.set('exit-code', 1).set('message', response_message)
        // output.exit(1,response_message)														//Use to exit from flintbit
    }
}
catch(Exception e){
    log.error(e.message)
    output.set('exit-code', 1).set('message', e.message)
}
log.trace("Finished executing 'fb-cloud:azure:operation:create_instance.groovy' flintbit")
// end
