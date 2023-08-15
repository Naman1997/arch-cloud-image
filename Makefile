all: template

clean:
	@rm -rf output-archlinux
	@cp cloud-init/user-data.backup cloud-init/user-data

check_dependencies:
	@which packer >/dev/null || (echo "Error: packer not found. Please install packer before proceeding." && exit 1)
	@which jq >/dev/null || (echo "Error: jq not found. Please install jq before proceeding." && exit 1)

image: check_dependencies
	@chmod +x scripts/create.sh
	@packer init archlinux.pkr.hcl
	@./scripts/create.sh $(CLOUD_USER) || (echo -e "\nError: Creating image failed. Check usage below:" && make usage_image && exit 1)

template: check_dependencies
	@chmod +x scripts/create.sh
	@packer init archlinux.pkr.hcl
	@./scripts/create.sh $(CLOUD_USER) || true
	@chmod +x scripts/proxmox.sh && ./scripts/proxmox.sh $(PROXMOX_USERNAME) $(PROXMOX_IP) $(CLOUD_USER) $(PATH_TO_PUB_KEY) || (echo -e "\nError: Creating template failed. Check usage below:" && make usage_template && exit 1)
	@echo "Successfully created template with ID: 9000"

usage_image:
	@echo "Usage:"
	@echo "make -s image CLOUD_USER=<your_cloud_user>"

usage_template:
	@echo "Usage:"
	@echo "make -s template CLOUD_USER=<your_cloud_user> PROXMOX_USERNAME=<your_proxmox_username> PROXMOX_IP=<your_proxmox_ip> PATH_TO_PUB_KEY=<your_path_to_pub_key>"

.PHONY: all clean image template check_dependencies usage usage_image usage_template