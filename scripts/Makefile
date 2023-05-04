PROJECT_ID=$(shell gcloud config list --format 'value(core.project)'))
all:
	@echo "gce-list             - List all GCE instances"
	@echo "gce-stop-all         - Stop all GCE instances"
	@echo "gce-start-all        - Start all GCE instances"


gce-list:
	gcloud compute instances list

gce-stop-all:
	gcloud compute instances list --format="value(name, zone)" --filter="status=RUNNING" | \
	while read instance zone; do \
		echo "Stopping instance $$instance in zone $$zone..."; \
		gcloud compute instances stop $$instance --zone=$$zone --quiet; \
	done

gce-start-all:
	gcloud compute instances list --format="value(name, zone)" --filter="status=TERMINATED" | \
	while read instance zone; do \
		echo "Starting instance $$instance in zone $$zone..."; \
		gcloud compute instances start $$instance --zone=$$zone --quiet; \
	done