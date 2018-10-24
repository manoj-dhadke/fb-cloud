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
    template_param = input.get('azure-arm-vm-config').get('parameters')
    log.trace("TYPEOF TEMPLATE_PARAMS :::: "+typeof template_param)
    template_parameters = util.json(input.get('azure-arm-vm-config').get('parameters'))

    // Azure Credentials
    client_id = input.get('azure-arm-vm-config').get('client-id')
    azure_key = input.get('azure-arm-vm-config').get('key')
    subscription_id = input.get('azure-arm-vm-config').get('subscription-id')
    tenant_id = input.get('azure-arm-vm-config').get('tenant-id')


    // Service form
    deployment_name = input.get('deployment_name')
    resource_group_name = input.get('resource_group_name')

    // Getting keys from parameter template
    keys = []
    for (key in template_parameters) {
        keys.push(key)
        log.trace(key)
    }

    // user_parameters_array = []

    switch (stack_name) {
        case 'Ubuntu VM':
            log.trace("JSON parsed template parameters :: " + template_parameters)

            // Service form parameter inputs?
            // location = input.get('location')
            // networkInterfaceName = input.get('networkInterfaceName')
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
            log.trace(virtualMachineSize)
            adminUsername = input.get('admin_username')
            log.trace(adminUsername)
            adminPassword = input.get('admin_password')
            log.trace(adminPassword)

            log.trace("VMSize :: "+virtualMachineSize+"\nAdminUser ::"+adminUsername+"\nAdminPassword :: "+adminPassword)

            // Getting all parameters from service form in an array, by using keys from parameters json
            // for (x in keys) {
            //     user_parameters_array.push(input.get(x))
            // }

            // for (x = 0; x <= keys.length - 1; x++) {
            //     //log.trace(keys[x])
            //     template_parameters[keys[x]].value = user_parameters_array[x]
            //     log.trace(template_parameters[keys[x]])

            // }

            // Test code
            user_parameters = {}
            user_parameters["virtualMachineSize"] = virtualMachineSize
            user_parameters["adminUsername"] = adminUsername
            user_parameters["adminPassword"] = adminPassword

            // user_parameters = '{"virtualMachineSize":"'+virtualMachineSize+'", "adminUsername":"'+adminUsername+'", "adminPassword":"'+adminPassword+'" }'
            
            //template_parameters = JSON.parse(template_parameters)

            for (key in user_parameters) {
                if (template_parameters.hasOwnProperty(key)) {
                    template_parameters[key]["value"] = user_parameters[key]
                }
            }
            // log.trace("Replaced values of template parameters :: "+template_parameters)

            for(x in template_parameters){
                log.trace("Template Replaced "+x+" :: "+template_parameters[x][value])
            }
            
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