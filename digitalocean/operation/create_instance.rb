# begin
@log.trace("Started executing 'flint-cloud:digitalocean:operation:create_instance.rb' flintbit...")
begin
    # Flintbit Input Parameters
    # Mandatory
    @connector_name = @input.get('connector_name') # Name of the Digitalocean Connector
    @action = @input.get('action') # Action(create)
    @name = @input.get('name')	# name of the machine to be created
    @region = @input.get('region')	# Region name where machine is to be created
    @image = @input.get('image')	# Name of the operating system which is to be in machine
    @size = @input.get('size')
    # optional
    @cpu = @input.get('cpu') # No of cpu required
    @memory = @input.get('memory') # Memory of the Droplet in megabytes.
    @disksize = @input.get('disksize') # The size of the Droplet's disk in gigabytes.
    @token = @input.get('token') # token

    @request_timeout = @input.get('timeout') # timeout

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | action :: #{@action}| name :: #{@name}| region :: #{@region}|
    cpu :: #{@cpu}| image :: #{@image}| size :: #{@size}| memory :: #{@memory}| disksize :: #{@disksize}| timeout :: #{@request_timeout}")

    connector_call = @call.connector(@connector_name)
                          .set('action', @action)
                          .set('name', @name)
                          .set('region', @region)
                          .set('image', @image)
                          .set('size', @size)
                          .set('token', @token)

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
