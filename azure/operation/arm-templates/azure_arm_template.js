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

    value = "value"
    new_input = JSON.parse(input)
    // Service configuration Inputs
    if (new_input.hasOwnProperty('azure-arm-vm-config')) {
        stack_name = input.get('azure-arm-vm-config').get('stack-name')
    }
    else if (new_input.hasOwnProperty('azure-arm-lbs-vm-config')) {
        stack_name = input.get('azure-arm-lbs-vm-config').get('stack-name')
    }
    else if (new_input.hasOwnProperty('azure-arm-lamp')) {
        stack_name = input.get('azure-arm-lamp').get('stack-name')
    }

    switch (stack_name) {
        // Single linux instance
        case 'Ubuntu VM':
            log.trace("Inside Ubuntu VM switch case")
            // Service config
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

            // Service form
            deployment_name = input.get('deployment_name')
            resource_group_name = input.get('resource_group_name')
            virtualMachineSize = input.get('virtual_machine_size')
            adminUsername = input.get('admin_username')
            adminPassword = input.get('admin_password')
            netSecRules = template_parameters.get("networkSecurityGroupRules").get(value)
            log.trace("type of netSecRules :: " + typeof netSecRules)

            template_parameters = JSON.parse(template_parameters)
            template_parameters["virtualMachineSize"][value] = virtualMachineSize
            template_parameters["adminUsername"][value] = adminUsername
            template_parameters["adminPassword"][value] = adminPassword
            template_parameters["networkSecurityGroupRules"][value] = netSecRules
            // Converting again so that "networkSecurityGroupRules" can be passed as a blank array object, JSON.parse cannot do that 
            template_parameters = util.json(template_parameters)

            log.trace("Second util.json " + template_parameters)

            // Test code ends here
            log.trace("Before connector call")
            connector_response = call.connector(connector_name)
                .set('template', template)
                .set('deployment-name', deployment_name)
                .set('resource-group-name', resource_group_name)
                .set('action', action)
                .set('template-parameters', template_parameters)
                .set('client-id', client_id)
                .set('key', azure_key)
                .set('subscription-id', subscription_id)
                .set('tenant-id', tenant_id)
                .timeout(300000)
                .sync()

            log.info("Connector call successfull")

            exit_code = connector_response.get('exit-code')
            message = connector_response.get('message')
            if (exit_code == 0) {
                user_message = "The request to deploy an Ubuntu VM with ARM template is completed. Here are the details. \n <br><b>Deployment ID:</b> " + connector_response.get('message')
                log.trace("Exit code is " + exit_code)
                log.trace("Response is :: " + connector_response)
                output.set('user_message', user_message)
            }
            else {
                user_message = "Oops! The request failed with error:\n"

                log.trace("Exit-Code :: " + exit_code + "\nMessage :: " + message)
                output.set('user_message', user_message + connector_response)
            }
            break;

        // Complex tier case: Two instances and a load balancer
        case "Complex":
            log.trace("Inside complex ARM template switch case")
            // Azure credentials
            client_id = input.get('azure-arm-lbs-vm-config').get('client-id')
            azure_key = input.get('azure-arm-lbs-vm-config').get('key')
            subscription_id = input.get('azure-arm-lbs-vm-config').get('subscription-id')
            tenant_id = input.get('azure-arm-lbs-vm-config').get('tenant-id')

            // Service config
            connector_name = input.get('azure-arm-lbs-vm-config').get('connector-name')
            action = input.get('azure-arm-lbs-vm-config').get('action')
            log.trace(connector_name)
            

            template = input.get('azure-arm-lbs-vm-config').get('template')
            template_parameters = util.json(input.get('azure-arm-lbs-vm-config').get('parameters'))

            // Service form
            resource_group_name = input.get('resource_group_name')
            deployment_name = input.get('deployment_name')
            adminUsername = input.get('admin_username')
            adminPassword = input.get('admin_password')

            template_parameters = JSON.parse(template_parameters)
            template_parameters['adminUsername'][value] = adminUsername
            template_parameters['adminPassword'][value] = adminPassword

            template_parameters = util.json(template_parameters)

            log.trace("Before connector call")
            connector_response = call.connector(connector_name)
                .set('template', template)
                .set('deployment-name', deployment_name)
                .set('resource-group-name', resource_group_name)
                .set('action', action)
                .set('template-parameters', template_parameters)
                .set('client-id', client_id)
                .set('key', azure_key)
                .set('subscription-id', subscription_id)
                .set('tenant-id', tenant_id)
                .timeout(600000)
                .sync()

            log.info("Connector call successfull")

            exit_code = connector_response.get('exit-code')
            message = connector_response.get('message')
            if (exit_code == 0) {
                user_message = "The request for deployment of two virtual machines and a load balancer via an ARM template is completed. Here are the details for the request: \n <br><b>Deployment ID:</b> " + connector_response.get('message')
                log.trace("Exit code is " + exit_code)
                log.trace("Response is :: " + connector_response)
                output.set('user_message', user_message)
            }
            else {
                user_message = "Oops! The request failed with error:\n"
                log.trace("Exit-Code :: " + exit_code + "\nMessage :: " + message)
                output.set('user_message', user_message + connector_response)
            }
            break;

        // Third case: ARM LAMP stack
        case "LAMP":
            log.trace("Inside Azure ARM LAMP case")

            // Azure credentials
            client_id = input.get('azure-arm-lamp').get('client-id')
            azure_key = input.get('azure-arm-lamp').get('key')
            subscription_id = input.get('azure-arm-lamp').get('subscription-id')
            tenant_id = input.get('azure-arm-lamp').get('tenant-id')

            // Service config
            connector_name = input.get('azure-arm-lamp').get('connector-name')
            action = input.get('azure-arm-lamp').get('action')
            log.trace(connector_name)
            resource_group_name = input.get('azure-arm-lamp').get('resource_group_name')
            deployment_name = input.get('azure-arm-lamp').get('deployment_name')

            template = input.get('azure-arm-lamp').get('template')
            template_parameters = util.json(input.get('azure-arm-lamp').get('parameters'))

            log.trace("Before connector call")
            connector_response = call.connector(connector_name)
                .set('template', template)
                .set('deployment-name', deployment_name)
                .set('resource-group-name', resource_group_name)
                .set('action', action)
                .set('template-parameters', template_parameters)
                .set('client-id', client_id)
                .set('key', azure_key)
                .set('subscription-id', subscription_id)
                .set('tenant-id', tenant_id)
                .timeout(500000)
                .sync()

            log.info("Connector call successfull")

            exit_code = connector_response.get('exit-code')
            message = connector_response.get('message')
            if (exit_code == 0) {
                user_message = "The request for deployment of a single instance LAMP stack via an ARM template is completed. Here are the details for the request: \n <br><b>Deployment ID:</b> " + connector_response.get('message')
                log.trace("Exit code is " + exit_code)
                log.trace("Response is :: " + connector_response)
                output.set('user_message', user_message)
            }
            else {
                user_message = "Oops! The request failed with error:\n"
                log.trace("Exit-Code :: " + exit_code + "\nMessage :: " + message)
                output.set('user_message', user_message + connector_response)
            }

    }
} catch (error) {
    output.set('user_message', error)
    log.error(error)
}
