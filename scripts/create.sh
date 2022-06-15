#!/bin/bash
sed -i -E "s/(hostname: ).*/\1$1/" cloud-init/user-data
sed -i -E "s/(user: ).*/\1$1/" cloud-init/user-data
sed -i -E "s/(\s+- ).*:/\1$1:/" cloud-init/user-data
rm -rf output-archlinux
packer build -var 'username='"$1"'' archlinux.pkr.hcl
echo "Successfully created golden arch image."