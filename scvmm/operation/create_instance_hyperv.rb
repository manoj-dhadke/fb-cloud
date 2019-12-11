=begin
##########################################################################
#
#  INFIVERVE TECHNOLOGIES PTE LIMITED CONFIDENTIAL
#  __________________
# 
#  (C) INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE
#  All Rights Reserved.
#  Product / Project: Flint IT Automation Platform
#  NOTICE:  All information contained herein is, and remains
#  the property of INFIVERVE TECHNOLOGIES PTE LIMITED.
#  The intellectual and technical concepts contained
#  herein are proprietary to INFIVERVE TECHNOLOGIES PTE LIMITED.
#  Dissemination of this information or any form of reproduction of this material
#  is strictly forbidden unless prior written permission is obtained
#  from INFIVERVE TECHNOLOGIES PTE LIMITED, SINGAPORE.
=end

require 'json'
@log.trace("Started execution 'flintcloud-integrations:services:hyperv:create_instance_hyperv.rb' flintbit...") # execution Started
begin

    # Flintbit input parametes
    @connector_name = @input.get('connector_name') #Name of the Hyper-V Connector
    if @connector_name.nil?
        @connector_name = @config.global('flintcloud-integrations.hyperv.name')
    end
    @instance_type = @input.get('vm_type')
    @vmname = @input.get("vmname")                                                             #Name of the vm
    @boot_device = @input.get("boot_device")                                                   #Boot device to be used                      
    @computer_name = @input.get("computer_name")                                               #Computer name on which vm is created
    @path = @config.global("flintcloud-integrations.hyperv.create_vm.path")+"#{@vmname}"       #Directory path to store files of vmname
    @new_vhd_path = "#{@path}/hard-disk/#{@vmname}.vhdx"                                       #Path to create new virtual hard disk 
    @generation = @input.get("generation")                                                     #Generation of windows
    @shell = "ps"               			                                                   #Shell Type
    @operation_timeout = 80               		                                               #Operation Timeout                                                    #Timeout
    @providerId = @input.get('provider_id')
    @providerSubtype = @input.get('subtype')

    @log.info("Instance type: #{@instance_type}")

    if @instance_type.include? 'Gold'
        memory_startup_bytes = @config.global("flintcloud-integrations.create_vm_template.hyperv.gold.memory_startup_bytes")
        new_vhd_size_bytes = @config.global("flintcloud-integrations.create_vm_template.hyperv.gold.new_vhd_size_bytes")
        cpu_count = @config.global("flintcloud-integrations.create_vm_template.hyperv.gold.cpu_count")
        @instance_type = "Gold" 
    elsif @instance_type.include? 'Silver'
        memory_startup_bytes = @config.global("flintcloud-integrations.create_vm_template.hyperv.silver.memory_startup_bytes")
        new_vhd_size_bytes = @config.global("flintcloud-integrations.create_vm_template.hyperv.silver.new_vhd_size_bytes")
        cpu_count = @config.global("flintcloud-integrations.create_vm_template.hyperv.silver.cpu_count") 
        @instance_type = "Silver" 
    else @instance_type.include? 'Bronze'
        memory_startup_bytes = @config.global("flintcloud-integrations.create_vm_template.hyperv.bronze.memory_startup_bytes")
        new_vhd_size_bytes = @config.global("flintcloud-integrations.create_vm_template.hyperv.bronze.new_vhd_size_bytes")
        cpu_count = @config.global("flintcloud-integrations.create_vm_template.hyperv.bronze.cpu_count") 
        @instance_type = "Bronze" 
    end
    
    @command = "new-vm -Name #{@vmname} -BootDevice #{@boot_device} -MemoryStartupBytes #{memory_startup_bytes} -ComputerName #{@computer_name} -Path #{@path} –NewVHDPath #{@new_vhd_path} -NewVHDSizeBytes #{new_vhd_size_bytes} -Generation #{@generation} 2>&1 | convertto-json"
    @command1 = "set-vmprocessor -vmname #{@vmname} -count #{cpu_count}"

    if !@providerId.nil? || !@providerId.to_s.empty?
        json_body = {}
        json_body['_key'] = @providerId
        json_body['subtype'] = @providerSubtype

        j_body = @util.json(json_body)
        @log.trace('calling http flintbit to get the details of the provider')
        http_response = @call.bit('flintcloud-integrations:services:http:http_services_helper.rb')
                             .set('body', j_body.to_json)
                             .set('action', 'fetch_details')
                             .set('provide_ID', @providerId).sync

        response_body = @util.json(http_response.get('result'))
    
        credential = @util.json(response_body.get('data'))

        @providerType = credential.get('name')
        @providerName = credential.get('category')
        @target = credential.get('credentials').get('target')
        @username = credential.get('credentials').get('username')
        @password = credential.get('credentials').get('password')
        @transport = credential.get('credentials').get('transport').strip
        @port = credential.get('credentials').get('port').strip
        @no_ssl_peer_verification = credential.get('credentials').get('no_ssl_peer_verification').strip


        @log.info("Flintbit input parameters are, connector name           ::    #{@connector_name} |
                                                  target                   ::    #{@target} |
                                                  username                 ::    #{@username}|
                                                  password                 ::    #{@password} |
                                                  shell                    ::    #{@shell}|
                                                  transport                ::    #{@transport}|
                                                  command                  ::    #{@command}|
                                                  operation_timeout        ::    #{@operation_timeout}|
                                                  no_ssl_peer_verification ::    #{@no_ssl_peer_verification}|
                                                  port                     ::    #{@port}")
                                                
        connector_call = @call.connector(@connector_name)
                    .set("target",@target)
                    .set("username",@username)
                    .set("password",@password)
                    .set("transport",@transport)
                    .set("command",@command)
                    .set("port",@port.to_i)
                    .set("shell",@shell)
                    .set("operation_timeout",@operation_timeout)
                    .set("timeout",@request_timeout)
                    .timeout(60000)

    else
        @log.info("Flintbit input parameters are, connector name           ::    #{@connector_name} |
                                                  shell                    ::    #{@shell}|
                                                  command                  ::    #{@command}|
                                                  operation_timeout        ::    #{@operation_timeout}")
                                                
        connector_call = @call.connector(@connector_name)
                              .set("command",@command)
                              .set("shell",@shell)
                              .set("operation_timeout",@operation_timeout)
                              .set("timeout",@request_timeout)
                              .timeout(60000)
    end

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{@request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end
    
    response_exitcode = response.exitcode # Exit status code
    response_message =  response.message # Execution status message

    #Winrm Connector Response Parameters
    result = response.get("result")            #Response Body
    
    if response_exitcode == 0
        # Connector call to set the processor count
        set_processor_count = @call.connector(@connector_name)
                        .set("command",@command1)
                        .set("shell",@shell)
                        .set("operation_timeout",@operation_timeout)
                        .set("timeout",@request_timeout)
                        .timeout(60000)
        @log.info("Setting the proccessor count..")       
        if @request_timeout.nil? || @request_timeout.is_a?(String)
            processor_count_response = set_processor_count.sync
        else
            processor_count_response = set_processor_count.timeout(@request_timeout).sync
        end


        result_vm_create = @util.json(result)
        @vm_identifier = result_vm_create.get('VMId')
        @log.info("Instance Id of VM :  #{@vm_identifier}")
        
        @command_details = "get-vm -id #{@vm_identifier} 2>&1 | convertto-json"
        @command_disksize = "(get-vhd -path (get-vm -id #{@vm_identifier}).harddrives.path).size 2>&1"
        
        #==========================================
        # Connector call to get the details of VM
        details_action = @call.connector(@connector_name)
                        .set("command",@command_details)
                        .set("shell",@shell)
                        .set("operation_timeout",@operation_timeout)
                        .set("timeout",@request_timeout)
                        .timeout(60000)
                        
        @log.info("Getting VM Details..")       
        if @request_timeout.nil? || @request_timeout.is_a?(String)
            details_action_response = details_action.sync
        else
            details_action_response = details_action.timeout(@request_timeout).sync
        end
        details_action_response_exitcode = details_action_response.exitcode # Exit status code
        details_action_response_message =  details_action_response.message # Execution status message

        if details_action_response_exitcode == 0
           @log.info("Inside Exitcode details_action_response")
           virtual_machine = @util.json(details_action_response.get("result")) 
           @proccessor_count = virtual_machine.get('ProcessorCount')
           @memory = virtual_machine.get('MemoryStartup').to_i/1048576
           @log.info("VM Details: #{virtual_machine}")
        else
           @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
           @log.info("Unable to get VM Details for #{@vm_identifier}")            
           @output.set('message', response_message).set('exit-code', -1)
        end

        #==========================================
        # Connector call to get the disk size of VM
        disk_size_action = @call.connector(@connector_name)
                                .set("command",@command_disksize)
                                .set("shell",@shell)
                                .set("operation_timeout",@operation_timeout)
                                .set("timeout",@request_timeout)
                                .timeout(60000)
                        
        @log.info("Getting disk size VM..")       
        if @request_timeout.nil? || @request_timeout.is_a?(String)
            disk_size_action_response = disk_size_action.sync
        else
            disk_size_action_response = disk_size_action.timeout(@request_timeout).sync
        end
        disk_size_action_response_exitcode = disk_size_action_response.exitcode # Exit status code
        disk_size_action_response_message =  disk_size_action_response.message # Execution status message
        
        if disk_size_action_response_exitcode == 0
            disksize = disk_size_action_response.get("result") 
            if disksize != nil
                disksize = disksize.to_f/1073741824
            end
            @log.info("Disk Size: #{disksize} GB")            
        else
            @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
            @log.info("Unable to get Disk Size for #{@vm_identifier}")
            @output.set('message', response_message).set('exit-code', -1)
        end


        if !@providerId.nil? || !@providerId.to_s.empty?
            @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
            @output.setraw('details:', result.to_s)
            
            if details_action_response_exitcode == 0
                @log.info("Request from cloud---")
                vm_info = {} 

                case virtual_machine.get('State')
                    when 2
                    vm_info['state'] ='running'
                    when 3
                    vm_info['state'] ='stopped'
                    when 9
                    vm_info['state'] ='paused'
                    else
                    vm_info['state'] ='unknown'
                end
                        
                vm_info['name'] = virtual_machine.get('Name')
                vm_info['cpu'] = virtual_machine.get('ProcessorCount')
                vm_info['instance-id'] =virtual_machine.get('VMId')
                vm_info['provider-id'] = @providerId
                vm_info['provider-name'] = @providerName
                vm_info['provider-type'] = @providerType
                vm_info['provider-subtype'] = @providerSubtype
                memory = virtual_machine.get('MemoryStartup')
                memory = memory.to_f/1073741824
                vm_info['memory'] = memory
                vm_info['disk-size'] = disksize
                vm_info['disk-unit'] = "GB"
                vm_info['memory-unit'] = "GB"
                vm_info['provider-vm-id'] = @providerId.to_s + '-' + virtual_machine.get('VMId').to_s
                
                # Check for operating system
                if virtual_machine.get('OperatingSystem') == nil
                    vm_info['operating-system'] = 'NA'
                    vm_info['image-name'] = 'NA'
                end

                networkAdapters = virtual_machine.get('NetworkAdapters')
                
                # Check for network adapters         
                if networkAdapters[0].get('IPAddresses') == '' 
                    vm_info['private-ip'] = ''  
                else
                    vm_info['private-ip'] = networkAdapters[0].get('IPAddresses')     
                end
                
                vm_info['public-ip'] = ''
                        
                        
                details = {}
                details['Floppy Drive']= virtual_machine.get('FloppyDrive')
                details['Replication Health']= virtual_machine.get('ReplicationHealth')
                details['Version']= virtual_machine.get('Version')
                details['Is Deleted']= virtual_machine.get('IsDeleted')
                details['Integration Services State'] = virtual_machine.get('IntegrationServicesState')
                details['Operational Status'] = virtual_machine.get('OperationalStatus')
                details['Primary Operational Status'] = virtual_machine.get('PrimaryOperationalStatus')
                details['Secondary Operational Status'] = virtual_machine.get('SecondaryOperationalStatus')
                details['Status Descriptions'] = virtual_machine.get('StatusDescriptions')
                details['Primary Status Description'] = virtual_machine.get('PrimaryStatusDescription')
                details['Secondary Status Description'] = virtual_machine.get('SecondaryStatusDescription')
                details['Status'] = virtual_machine.get('Status')
                details['Heartbeat'] = virtual_machine.get('Heartbeat')
                details['Replication State'] = virtual_machine.get('ReplicationState')
                details['Replication Mode'] = virtual_machine.get('ReplicationMode')
                details['CPU Usage'] = virtual_machine.get('CPUUsage')
                details['Memory Demand'] = virtual_machine.get('MemoryDemand')
                details['Memory Status'] = virtual_machine.get('MemoryStatus')
                details['Smart Paging FileInUse'] = virtual_machine.get('SmartPagingFileInUse')
                details['Integration Services Version'] = virtual_machine.get('IntegrationServicesVersion')
                details['Uptime'] = virtual_machine.get('Uptime')
                details['Resource Metering Enabled'] = virtual_machine.get('ResourceMeteringEnabled')
                details['Configuration Location'] = virtual_machine.get('ConfigurationLocation')
                details['Snapshot FileLocation'] = virtual_machine.get('SnapshotFileLocation')
                details['Automatic Start Action'] = virtual_machine.get('AutomaticStartAction')
                details['Automatic Stop Action'] = virtual_machine.get('AutomaticStopAction')
                details['Automatic Start Delay'] = virtual_machine.get('AutomaticStartDelay')
                details['Smart Paging File Path'] = virtual_machine.get('SmartPagingFilePath')
                details['Numa Aligned'] = virtual_machine.get('NumaAligned')
                details['Numa Nodes Count'] = virtual_machine.get('NumaNodesCount')
                details['Numa Socket Count'] = virtual_machine.get('NumaSocketCount')
                details['Key'] = virtual_machine.get('Key')
                details['Computer Name'] = virtual_machine.get('ComputerName')
                details['Version'] = virtual_machine.get('Version')
                details['Notes'] = virtual_machine.get('Notes')
                details['Generation'] = virtual_machine.get('Generation')
                details['Path'] = virtual_machine.get('Path')
                details['Creation Time'] = virtual_machine.get('CreationTime')
                details['Is Clustered'] = virtual_machine.get('IsClustered')
                details['Size Of System Files'] = virtual_machine.get('SizeOfSystemFiles')
                details['Parent Snapshot Id'] = virtual_machine.get('ParentSnapshotId')
                details['Parent Snapshot Name'] = virtual_machine.get('ParentSnapshotName')
                details['Memory Startup'] = virtual_machine.get('MemoryStartup')
                details['Dynamic Memory Enabled'] = virtual_machine.get('DynamicMemoryEnabled')
                details['Memory Minimum'] = virtual_machine.get('MemoryMinimum')
                details['Memory Maximum'] = virtual_machine.get('MemoryMaximum')
                details['Remote FxAdapter'] = virtual_machine.get('RemoteFxAdapter')
                details['Network Adapters'] = virtual_machine.get('NetworkAdapters')
                details['Fibre Channel Host Bus Adapters'] = virtual_machine.get('FibreChannelHostBusAdapters')
                details['Com Port 1'] =virtual_machine.get('ComPort1')
                details['Com Port 2'] =  virtual_machine.get('ComPort2')
                details['Floppy Drive'] = virtual_machine.get('FloppyDrive')
                details['DVD Drives'] = virtual_machine.get('DVDDrives')
                details['Hard Drives'] = virtual_machine.get('HardDrives')
                details['VM Integration Service'] = virtual_machine.get('VMIntegrationService')
                details['IP Address'] = []

                # Insert Network adapters data in details
                networkAdapters.each do |networkAdapter|
                    if networkAdapter.get('IPAddresses') != '' 
                        details['IP Address'].push(networkAdapter.get('IPAddresses')) 
                    end
                end # end loop of networkAdapters

                vm_info['data'] = details

                @log.trace(" calling flintbit : flintcloud-integrations:utils:http_request_helper.rb" )
                @call.bit('flintcloud-integrations:utils:http_request_helper.rb')
                        .set('action', 'save')
                        .set('method', 'post')
                        .set('category','COMPUTE')
                        .set('type','VIRTUAL_MACHINE')
                        .set('subtype','MS_HYPERV')
                        .set('body', @util.json(vm_info).to_s)
                        .async
                user_message = """**Successfully Saved Virtual Machine Details**"""
                @output.set('user_message', user_message)
            else
                user_message = """**Unable to save Virtual Machine Details**"""
                @output.set('user_message', user_message)
            end
            user_message = """**HyperV #{@instance_type} Instance created successfully**

**Details :**
* HyperV Instance ID : #{@vm_identifier}
* No of CPU : #{@proccessor_count}
* Disk Size : #{disksize} GB
* Memory : #{@memory} MB"""
            @output.set('user_message', user_message)                       
        else    
            @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
            user_message = """**HyperV #{@instance_type} Instance created successfully**

**Details :**
* HyperV Instance ID : #{@vm_identifier}
* No of CPU : #{@proccessor_count}
* Disk Size : #{disksize} GB
* Memory : #{@memory} MB"""
            
            @output.set('user_message', user_message)
        end

    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response_exitcode} | message : #{response_message}")
        @log.info('output in exitcode -1')
        user_message = """**Failed to create Virtual Machine**"""
        @output.set('message', response_message).set('exit-code', -1).set('user_message', user_message)
    end
rescue Exception => e
    @log.error(e.message)
    user_message = """**There is an issue while creating Virtual Machine**"""
    @output.set('exit-code', 1).set('message', e.message).set('user_message', user_message)
end

@log.trace("Finished 'flintcloud-integrations:services:hyperv:create_instance_hyperv.rb' flintbit...") # execution terminated
