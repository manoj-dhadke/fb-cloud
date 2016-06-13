# begin
@log.trace("Started executing 'fb-cloud:digitalocean:operation:create_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters

    # Mandatory
    @connector_name = @input.get('connector_name') # Name of the Digitalocean Connector
    @action = 'create'                             # Action(create)
    @token = @input.get('token')                   # token
    @name = @input.get('name')                     # name of the machine to be created
    @region = @input.get('region')                 # Region name where machine is to be created
    @size = @input.get('size')
    @image = @input.get('image') # Name of the operating system which is to be in machine

    # optional
    @ssh_keys = @input.get('ssh_keys')             # Array of SSH key that you wants to embed in droplet.
    @backups = @input.get('backups')               # Autometed backup should be enable or not
    @ipv6 = @input.get('ipv6')                     # IPV6 enable or not
    @user_data = @input.get('user_data')           # User data for the droplet
    @private_networking = @input.get('private_networking') # Private networking enable or not

    @request_timeout = @input.get('timeout') # timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | action :: #{@action}|
    name :: #{@name}| region :: #{@region}| backups :: #{@backups}| image :: #{@image}| size :: #{@size}|
    ipv6 :: #{@ipv6}| user data :: #{@user_data}| timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('token', @token)
                          .set('name', @name)
                          .set('region', @region)
                          .set('size', @size)
                          .set('image', @image)
                          .set('ssh_keys', @ssh_keys)
                          .set('backups', @backups)
                          .set('ipv6', @ipv6)
                          .set('user_data', @user_data)
                          .set('private_networking', @private_networking)

    if @request_timeout.nil? || @request_timeout.is_a?(String)
        @log.trace("Calling #{@connector_name} with default timeout...")
        response = connector_call.sync
    else
        @log.trace("Calling #{@connector_name} with given timeout #{request_timeout}...")
        response = connector_call.timeout(@request_timeout).sync
    end

    # DigitalOcean Connector Response Meta Parameters
    response_exitcode = response.exitcode           # Exit status code
    response_message = response.message             # Execution status message

    # DigitalOcean Connector Response Parameters
    id = response.get('id') # Machine Id
    name = response.get('name') # Machine Name

    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @log.info("#{@connector_name} Machine  Id :: #{id} | Machine Name ::#{name}")
        @output.setraw('response', response.to_s)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message ::  #{response_message}")
        @output.exit(1, response_message)
    end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished executing 'flint-cloud:digitalocean:operation:create_instance.rb' flintbit...")
# end
