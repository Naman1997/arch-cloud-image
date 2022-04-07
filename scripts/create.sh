#!/bin/bash
sed -i -E "s/(hostname: ).*/\1$1/" cloud-init/user-data
sed -i -E "s/(user: ).*/\1$1/" cloud-init/user-data
sed -i -E "s/(\s+- ).*:/\1$1:/" cloud-init/user-data
rm -rf output-archlinux
version=`curl -s https://gitlab.archlinux.org/api/v4/projects/10177/releases/ | jq '.[]' | jq -r '.name' | head -1 | cut -c2-`
packer build -var 'username='"$1"'' -var 'version='"$version"'' archlinux.pkr.hcl
echo "Successfully created golden arch image using version $version"