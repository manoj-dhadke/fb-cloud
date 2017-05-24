require 'json'
@log.trace("Started execution'flint-o365:customer:list_subscription_add_ons.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @connector_name = @input.get('connector-name')        # Name of the Connector
    @microsoft_id = @input.get('customer-id')             # id of the Microsoft Account
    @action = 'list-subscription-add-ons' # @input.get("action")
    @id_for_subscription = @input.get('id-for-subscription')

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | MICROSOFT ID :: #{@microsoft_id} |
                                    ID FOR SUBSCRIPTION :: #{@id_for_subscription}")

    response = @call.connector(@connector_name)
                    .set('action', @action)
                    .set('microsoft-id', @microsoft_id)
                    .set('id-for-subscription', @id_for_subscription)
                    .sync

    response_exitcode = response.exitcode # Exit status code
    response_message =  response.message # Execution status message
    response_body = response.get('body')    

    if response_exitcode == 0
        @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("RESPONSE :: #{response_body}")
        @output.setraw('result', response_body.to_json)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.exit(1, response_message)
     end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished execution 'flint-o365:microsoft-cloud:customer:list_subscription_add_ons.rb' flintbit...")
