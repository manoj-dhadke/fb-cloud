@log.trace("Started execution'flint-o365:customer:list_offer_id_add_ons.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @connector_name = @input.get('connector-name')        # Name of the Connector
    @offer_id = @input.get('offer-id')             # id of the offer
    @action = 'list-offer-id-add-ons' # @input.get("action")
    @country = @input.get('country')

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | OFFER ID :: #{@offer_id}")

    response = @call.connector(@connector_name)
                    .set('action', @action)
                    .set('offer-id', @offer_id)
                    .set('country', @country)
                    .sync

    response_exitcode = response.exitcode # Exit status code
    response_message =  response.message # Execution status message
    response_body = response.get('body')

    if response_exitcode == 0
        @log.info("Success in executing #{@connector_name} Connector, where exitcode :: #{response_exitcode} | message :: #{response_message}")
        @log.info("#{response_body}")
        @output.setraw('result', response_body)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode :: #{response_exitcode} | message :: #{response_message}")
        @output.exit(1, response_message)
     end
rescue Exception => e
    @log.error(e.message)
    @output.set('exit-code', 1).set('message', e.message)
end
@log.trace("Finished execution 'flint-o365:microsoft-cloud:customer:list_offer_id_add_ons.rb' flintbit...")
