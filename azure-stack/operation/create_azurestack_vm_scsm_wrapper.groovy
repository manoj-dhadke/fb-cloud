log.trace("Started executing 'fb-cloud:azure-stack:operation:create_azurestack_vm_scsm_wrapper.groovy' flintbit...")

log.info("Input:: ${input}")

sr_request_id= input.get("sr_request_id")
title= input.get("title")
description= input.get("description")

log.trace("Finished executing 'fb-cloud:azure-stack:operation:create_azurestack_vm_scsm_wrapper.groovy' flintbit...")
