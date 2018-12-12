log.trace("Started executing 'fb-cloud:azure-stack:operation:create_azurestack_vm_scsm_wrapper_oldasdk.groovy' flintbit...")

//log.info("Input:: ${input}")

    sr_request_id= input.get("sr_request_id")
    title= input.get("title")
    description= input.get("description")
    connector_name= config.global("create_as_vm").get("connector_name")                      //Name of the Connector
    target= config.global("create_as_vm").get("target")                                           //Target address
    username = config.global("create_as_vm").get("username")                                    //Username
    password = config.global("create_as_vm").get("password")                                    //Password
    shell = "ps"                                                          //Shell Type
    transport = config.global("create_as_vm").get("transport")                                    //Transport
    operation_timeout = 1000                                         //Operation Timeout
    no_ssl_peer_verification = config.global("create_as_vm").get("no_ssl_peer_verification")    //SSL Peer Verification
    port = config.global("create_as_vm").get("port")                                            //Port Number
    request_timeout=1000000                                              //Timeout
    azure_ad_tenant_name= config.global("create_as_vm").get("azure_ad_tenant_name")                   //tenant-name for the tenant
    tenant_username = config.global("create_as_vm").get("tenant-username")                   //tenant-username of the tenant
    tenant_password= config.global("create_as_vm").get("tenant-password")                   //tenant-password for the tenant user
    subscription_name= config.global("create_as_vm").get("subscription-name")
    resourcegroup= config.global("create_as_vm").get("resourcegroup")               //subscription name
    vmsize="Standard_A1"
    publishername="OpenLogic"
    offer="CentOS"
    skus="7.4"
    //log.info"----------------${tenant_username}------------------------${tenant_password}----------------------${subscription_name}"
create_vm = call.bit("fb-cloud:azure-stack:operation:create_vm_scsm_oldasdk.groovy")
                .set("connector_name",connector_name)
                .set("target",target)
                .set("username",username)
                .set("password",password)
                .set("transport",transport)
                .set("port",port)
                .set("tenant-username",tenant_username)
                .set("tenant-password",tenant_password)
                .set("subscription-name",subscription_name)
                .set("azure-ad-tenant-name",azure_ad_tenant_name)
                .set("resourcegroup",resourcegroup)
                .set("vmsize",vmsize)
                .set("publishername",publishername)
                .set("offer",offer)
                .set("skus",skus)
                .sync()

result=create_vm.get('result')
log.info("Result::${result}")
log.info("Success in triggering the create azurestack VM flintbit....")

log.trace("Finished executing 'fb-cloud:azure-stack:operation:create_azurestack_vm_scsm_wrapper_oldasdk.groovy' flintbit...")
