@log.trace("Started execution of 'flint-vmware:vc55:vm_cloud_actions.rb' flintbit..") 
@log.trace('Reading vmware connector name from Global Config')

@connector_name = @input.get('connector-name')
if @connector_name.nil? 
    @connector_name = @config.global('flintserve-integrations.vmware.connector-name')
end
action = @input.get('action')
@log.info("ConnectorName:: #{@connector_name} | action :: #{action}")

case action

when 'sync-vm' # case of action sync-vm
    @log.info("Calling 'flint-vmware:vc55:list_vm.rb' flintbit to get VM list")
    @call.bit('flint-vm:list_vm.rb').set('connector-name', @connector_name).set('action',action).setraw(@input.raw.to_s).timeout(120000).sync
         
when 'poweron-vm' # case of action for poweron VM
    @log.info("Calling 'flint-vm:list_vm.rb' flintbit to power-on VM")
    @call.bit('flint-vm:poweron_vm.rb').set('connector-name', @connector_name).setraw(@input.raw.to_s).timeout(120000).sync

when 'poweroff-vm' # case of action for poweroff VM
    @log.info("Calling 'flint-vm:poweroff_vm.rb' flintbit to power-off VM")
    @call.bit('flint-vm:poweroff_vm.rb').set('connector-name', @connector_name).setraw(@input.raw.to_s).timeout(120000).sync

when 'reboot-vm' # case of action for reboot VM
    @log.info("Calling 'flint-vm:reboot_vm.rb' flintbit to reboot VM")
    @call.bit('flint-vm:reboot_vm.rb').set('connector-name', @connector_name).setraw(@input.raw.to_s).timeout(120000).sync

when 'reset-vm' # case of action for reset VM
    @log.info("Calling 'flint-vm:reset_vm.rb' flintbit to reset VM")
    @call.bit('flint-vm:reset_vm.rb').set('connector-name', @connector_name).setraw(@input.raw.to_s).timeout(120000).sync


when 'suspend-vm' # case of action for suspend VM
    @log.info("Calling 'flint-vm:reset_vm.rb' flintbit to suspend VM")
    @call.bit('flint-vm:suspend_vm.rb').set('connector-name', @connector_name).setraw(@input.raw.to_s).timeout(120000).sync


else
  @log.error('Invalid action provided, Please provide valid action')
  @output.exit(4, 'Invalid action provided, Please provide valid action')
end

@log.trace("Finished execution of 'flint-vmware:vc55:vm_cloud_actions.rb' flintbit..") 
