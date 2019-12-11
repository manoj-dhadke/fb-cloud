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
log.trace("Started execution 'fb-cloud:vmware55:operation:rename_virtual_machine.groovy' flintbit...") // execution Started
try{
	// Flintbit input parametes
	// Mandatory
	connector_name = input.get('connector_name') // vmware connector name
	action ='rename-vm' // name of the operation:modify-cpu
	username = input.get('username') // username of vmware connector
	password = input.get('password') //  password of vmware connector
	url = input.get('url') // url for the vmware connector
	vm_name= input.get('vm-name') //name of the virtual machine wich you want update 
	new_name=input.get('new-name') //number of cpu which you are going to update for given virtual machine

	//optional
	request_timeout = input.get('timeout') // Execution time of the Flintbit in milliseconds (default timeout is 60000 milloseconds)

	if( connector_name == null || connector_name == ""){
		throw new Exception ('Please provide "vmware connector name (connector_name)" to update virtual machine')
	}

	//checking that the virtual machine name is provided or not 
	if (vm_name == null || vm_name == ""){
		throw new Exception ('Please provide "virtual machine name (vm_name)" to update virtual machine')
	}

	//checking that the virtual machine cpu is provided or not 
	if (new_name == null){
		throw new Exception ('Please provide "virtual machine new name (new_name)" to update virtual machine')
	}


	//calling vmware connector
	connector_call = call.connector(connector_name)
                    .set('action', action)
                    .set('url', url)
                    .set('username', username)
                    .set('password', password)
                    .set('new-name',new_name)
		            .set('vm-name', vm_name)
                   
	//if the request_timeout is not provided then call connector with default time-out otherwise call connector with given request time-out
	if( request_timeout == null || request_timeout instanceof String){
		log.trace("Calling ${connector_name} with default timeout...")
		//calling connector
		response = connector_call.sync()
    }
	else{
		log.trace("Calling ${connector_name} with given timeout ${request_timeout}...")
		//calling connector
		response = connector_call.timeout(request_timeout).sync()
	}

	//checking response of vmware connector
	response_exitcode = response.exitcode() // Exit status code
	response_message =  response.message() // Execution status message

	if (response_exitcode == 0){
		log.info("Success in executing ${connector_name} Connector, where exitcode :: ${response_exitcode} | message :: ${response_message}")
		output.set('exit-code', 0).set('message', response_message.toString())
    }
	else{
		log.error("ERROR in executing ${connector_name} where, exitcode :: ${response_exitcode} | message :: ${response_message}")
		output.set('exit-code', -1).set('message', response_message.toString())
	}
}
catch (Exception e){
	log.error(e.message)
	output.set('exit-code', 1).set('message', e.message)
}

log.trace("Finished execution 'fb-cloud:vmware55:operation:rename_virtual_machine.groovy' flintbit...")
// end

