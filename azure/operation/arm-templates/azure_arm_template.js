log.trace("Started executing example:azure_arm_template.js flintbit")
try {

    log.trace("Inputs are :: " + input)
    // TOD input
    // stack_name = input.get('stack-name')
    // connector_name = input.get('connector-name')
    // log.trace(connector_name)
    // template = input.get('template')
    // deployment_name = input.get('deployment-name')
    // resource_group_name = input.get('resource-group-name')
    // action = input.get('action')
    // template_parameters = input.get('parameters')

    // Service configuration Inputs
    stack_name = input.get('azure-arm-vm-config').get('stack-name')
    connector_name = input.get('azure-arm-vm-config').get('connector-name')
    action = input.get('azure-arm-vm-config').get('action')
    log.trace(connector_name)
    template = input.get('azure-arm-vm-config').get('template')
   
    template_parameters = util.json(input.get('azure-arm-vm-config').get('parameters'))

    // Azure Credentials
    client_id = input.get('azure-arm-vm-config').get('client-id')
    azure_key = input.get('azure-arm-vm-config').get('key')
    subscription_id = input.get('azure-arm-vm-config').get('subscription-id')
    tenant_id = input.get('azure-arm-vm-config').get('tenant-id')
    //


    // Service form
    deployment_name = input.get('deployment_name')
    resource_group_name = input.get('resource_group_name')


    switch (stack_name) {
        case 'Ubuntu VM':
            log.trace("util.json parsed template parameters :: " + template_parameters)


            // Service form parameter inputs?
            // location = input.get('location')
            // networkInterfaceName = input.get('etworkInterfaceName')
            // networkSecurityGroupName = input.get('networkSecurityGroupName')
            // networkSecurityGroupRules = input.get('networkSecurityGroupRules')
            // virtualNetworkName = input.get('virtualNetworkName')
            // addressPrefix = input.get('addressPrefix')
            // subnetName = input.get('subnetName')
            // subnetPrefix = input.get('subnetPrefix')
            // publicIpAddressName = input.get('publicIpAddressName')
            // publicIpAddressType = input.get('publicIpAddressType')
            // publicIpAddressSku = input.get('publicIpAddressSku')
            // virtualMachineName = input.get('virtualMachineName')
            // virtualMachineRG = input.get('virtualMachineRG')
            // osDiskType = input.get('osDiskType')
            // diagnosticsStorageAccountName = input.get('diagnosticsStorageAccountName')
            // diagnosticsStorageAccountId = input.get('diagnosticsStorageAccountId')
            // diagnosticsStorageAccountType = input.get('diagnosticsStorageAccountType')
            // diagnosticsStorageAccountKind = input.get('diagnosticsStorageAccountKind')

            // These variable names will be used when the following three parameters are taken from service config
            // virtualMachineSize = input.get('virtualMachineSize')
            // adminUsername = input.get('adminUsername')
            // adminPassword = input.get('adminPassword')

            virtualMachineSize = input.get('virtual_machine_size')
            adminUsername = input.get('admin_username')
            adminPassword = input.get('admin_password')

            template_parameters.set('virtualMachineSize',virtualMachineSize)
            template_parameters.set('adminUsername',adminUsername)
            template_parameters.set('adminPassword',adminPassword)

            log.trace(template_parameters)
             
            // Test code ends here
            log.trace("Before connector call")
            connector_response = call.connector(connector_name)
                .set('template', template)
                .set('deployment-name', deployment_name)
                .set('resource-group-name', resource_group_name)
                .set('action', action)
                .set('template-parameters', template_parameters)
                .set('client-id',client_id)
                .set('key',azure_key)
                .set('subscription-id',subscription_id)
                .set('tenant-id',tenant_id)
                .timeout(300000)
                .sync()

            log.info("Connector call successfull")

            exit_code = connector_response.get('exit-code')
            message = connector_response.get('message')
            if (exit_code == 0) {
                user_message = "The request for a Ubuntu VM is completed. Here are the details. \n Deployment ID: "+connector_response.get('message')
                log.trace("Exit code is " + exit_code)
                log.trace("Response is :: " + connector_response)
                output.set('user_message',user_message)
            }
            else {
                log.trace("Exit-Code :: " + exit_code + "\nMessage :: " + message)
                output.set(connector_response)
            }
            break;
    }
} catch (error) {
    log.error(error)

}