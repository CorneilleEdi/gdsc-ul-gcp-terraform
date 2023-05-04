import sys
from typing import Any

import functions_framework
from google.api_core.extended_operation import ExtendedOperation
from google.cloud import compute_v1


# https://cloud.google.com/compute/docs/samples/compute-stop-instance?hl=en#compute_stop_instance-python
def wait_for_extended_operation(
        operation: ExtendedOperation, verbose_name: str = "operation", timeout: int = 300
) -> Any:
    result = operation.result(timeout=timeout)

    if operation.error_code:
        print(
            f"Error during {verbose_name}: [Code: {operation.error_code}]: {operation.error_message}",
            file=sys.stderr,
            flush=True,
        )
        print(f"Operation ID: {operation.name}", file=sys.stderr, flush=True)
        raise operation.exception() or RuntimeError(operation.error_message)

    if operation.warnings:
        print(f"Warnings during {verbose_name}:\n", file=sys.stderr, flush=True)
        for warning in operation.warnings:
            print(f" - {warning.code}: {warning.message}", file=sys.stderr, flush=True)

    return result


PROJECT_ID = 'gdsc-ul-playground-eros'


@functions_framework.http
def handler(request):
    # Set up Compute Engine
    compute_client = compute_v1.InstancesClient()

    # Filter instances by tag
    request = compute_v1.AggregatedListInstancesRequest(
        project=PROJECT_ID,
    )

    # List instances
    aggregate_list = compute_client.aggregated_list(request=request)
    all_instances = []
    for zone, response in aggregate_list:

        if response.instances:
            for instance in response.instances:
                all_instances.append(
                    {
                        "name": instance.name,
                        "labels": instance.labels,
                        "zone": instance.zone.split("/")[-1],
                        "status": instance.status,
                    }
                )

    terraform_instances = [instance for instance in all_instances if instance['labels']['owner'] == 'terraform']
    non_terraform_instances = [instance for instance in all_instances if instance['labels']['owner'] != 'terraform']

    for instance in all_instances:
        if instance['status'] == 'RUNNING':
            print(f"Stopping instance {instance['name']} in zone {instance['zone']}")
            operation = compute_client.stop(project=PROJECT_ID, zone=instance['zone'], instance=instance['name'])
            wait_for_extended_operation(operation, verbose_name="stop instance")

    for instance in non_terraform_instances:
        print(f"Deleting instance {instance['name']} in zone {instance['zone']}")
        operation = compute_client.delete(project=PROJECT_ID, zone=instance['zone'], instance=instance['name'])
        wait_for_extended_operation(operation, verbose_name="delete instance")

    return 'Done!'
