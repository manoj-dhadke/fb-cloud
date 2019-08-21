log.trace("Started executing 'fb-cloud:azure:operation:add_frontend_pool.js' flintbit...")

    // Flintbit Input Parameters
    // Mandatory
    connector_name = 'msazure'
    group_name = input.get('group-name')
    load_balancer_name = input.get('load-balancer-name')
    frontend_pool_name = input.get('frontend-pool-name')
    public_ip_address_name = input.get('public-ip-address-name')
    action = 'add-frontend-pool'

    // Optional
    request_timeout = 180000
    key = input.get('key')
    tenant_id = input.get('tenant-id')
    subscription_id = input.get('subscription-id')
    client_id = input.get('client-id')

    log.info("Flintbit input parameters are,connector-name: "+connector_name+" | action :  "+action+" | group-name : "+group_name+" | load-balancer-name :  "+load_balancer_name+" | frontend-pool-name: "+frontend_pool_name+" | public-ip-address:  "+public_ip_address_name)


    if(connector_name == null || connector_name == ""){
        log.error('Please provide MS Azure connector name to add frontend pool to load balancer')
    }

    if(group_name == null || group_name == ""){
        log.error('Please provide MS Azure group name to add frontend pool to load balancer')
    }

    if(load_balancer_name == null || load_balancer_name == ""){
        log.error('Please provide MS Azure load balancer name to add frontend pool to load balancer')
    }

    if(frontend_pool_name == null || frontend_pool_name == ""){
        log.error('Please provide MS Azure frontend pool name to add frontend pool to load balancer')
    }

    if(public_ip_address_name == null || public_ip_address_name == ""){
        log.error('Please provide MS Azure public ip address name to add frontend pool to load balancer')
    }

    // Call to msazure connector
      connector_call = call.connector(connector_name)
                          .set('action', action)
                          .set('tenant-id', tenant_id)
                          .set('subscription-id', subscription_id)
                          .set('key', key)
                          .set('client-id', client_id)
                          .set('group-name', group_name)
                          .set('load-balancer-name', load_balancer_name)
                          .set('frontend-pool-name', frontend_pool_name)
                          .set('public-ip-address-name', public_ip_address_name)

    if(request_timeout == null){
        log.trace("Calling  "+connector_name+" with default timeout...")
        response = connector_call.sync()
    }else{
        log.trace("Calling  "+connector_name+" with given timeout  "+request_timeout)
        response = connector_call.timeout(request_timeout).sync()
    }

    // Amazon EC2 Connector Response Meta Parameters
    response_exitcode = response.exitcode()	// Exit status code
    response_message = response.message()	// Execution status messages

    if(response_exitcode == 0){
        log.info("SUCCESS in executing  "+connector_name+" where, exitcode :  "+response_exitcode+" | message :  "+response_message)
        output.set('exit-code', 0).set('message', response_message)
    }else{
        log.error("ERROR in executing  "+connector_name+" where, exitcode :  "+response_exitcode+" | message :  "+response_message)
        output.set('exit-code', 1).set('message', response_message)
    }


log.trace("Finished executing 'fb-cloud:azure:operation:add_frontend_pool.rb' flintbit")
