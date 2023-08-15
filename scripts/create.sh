#!/bin/bash
sed -i -E "s/(hostname: ).*/\1$1/" cloud-init/user-data
sed -i -E "s/(user: ).*/\1$1/" cloud-init/user-data
sed -i -E "s/(\s+- ).*:/\1$1:/" cloud-init/user-data
rm -rf output-archlinux
packer build -var 'username='"$1"'' archlinux.pkr.hcl
if [ $? != "0" ]; then
    echo "Unable to create the golden arch image."
    exit 1
fi
echo "Successfully created golden arch image."