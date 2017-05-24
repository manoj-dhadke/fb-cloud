@log.trace("Started execution'flint-o365:customer:create_customer.rb' flintbit...")
begin
    # Flintbit Input Parameters
    @connector_name = @input.get('connector-name')        # Name of the Connector
    @microsoft_id = @input.get('customer-id')             # id of the Microsoft Account
    @action = 'create-customer' # @input.get("action")
    @billing_fisrt_name = @input.get('billing-fisrt-name')
    @billing_last_name = @input.get('billing-last-name')
    @email = @input.get('email')
    @culture = @input.get('culture')
    @language = @input.get('language')
    @country = @input.get('country')
    @city = @input.get('city')
    @State = @input.get('State')
    @address_line1 = @input.get('address-line1')
    @postal_code = @input.get('postal-code')
    @phone_number = @input.get('phone-number')
    @first_name = @input.get('first-name')
    @last_name = @input.get('last-name')
    @company_name = @input.get('company-name')
    @domain = @input.get("domain")

    @log.info("Flintbit input parameters are, connector name :: #{@connector_name} | MICROSOFT ID :: #{@microsoft_id}")

    response = @call.connector(@connector_name)
                    .set('action', @action)
                    .set('microsoft-id', @microsoft_id)
                    .set('billing-fisrt-name', @billing_fisrt_name)
                    .set('display-name', @display_name)
                    .set('email', @email)
                    .set('culture', @culture)
                    .set('language', @language)
                    .set('State', @State)
                    .set('country', @country)
                    .set('city', @city)
                    .set('address-line1', @address_line1)
                    .set('postal-code', @postal_code)
                    .set('phone-number', @phone_number)
                    .set('first-name', @first_name)
                    .set('last-name', @last_name)
                    .set('domain', @domain)
                    .set('company-name', @company_name)
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
@log.trace("Finished execution 'flint-o365:microsoft-cloud:customer:create_customer.rb' flintbit...")
