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
@log.trace("Started executing 'fb-cloud:azure:operation:create_subnet.rb' flintbit...")

@connector_name = 'msazure' # name of Azure connector

connector_call = @call.connector(@connector_name)
                          .set('action', 'add-security-group')
                        response = connector_call.sync







    if response.exitcode == 0
        @log.info("SUCCESS in executing #{@connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
        @output.set('exit-code', 0).set('message', response.message)
    else
        @log.error("ERROR in executing #{@connector_name} where, exitcode : #{response.exitcode} | message : #{response.message}")
        @output.set('exit-code', 1).set('message', response.message)
    end

@log.trace("Finished executing 'fb-cloud:azure:operation:create_subnet.rb' flintbit")
