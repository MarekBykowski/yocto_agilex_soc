#!/bin/bash

function diamond-mesa-env {
    DEST=$1
    # Create a local/simple environment file.
    new_cross_compile=$(cat ${DEST}/tools/environment-setup-* | \
			       egrep CROSS | cut -d'=' -f2)
    new_path=$(dirname $(find ${DEST}/tools/sysroots/x86* \
			      -name ${new_cross_compile}gcc))
    new_sysroot=${DEST}/tools/sysroots/$(for path in $(ls -d \
								  ${DEST}/tools/sysroots/*) ; \
						 do echo $(echo $(basename $path) | egrep -v x86 | head -1); done)
    new_arch=$(${new_path}/${new_cross_compile}gcc -dumpmachine | \
		      cut -d'-' -f 1)

    if [ "aarch64" = "$new_arch" ]
    then
	new_arch=arm64
    fi

    cat <<EOF >${DEST}/tools/diamond-mesa.env
export PATH=${new_path}:\$PATH
export CROSS_COMPILE=${new_cross_compile}
export SYSROOT=${new_sysroot}
export ARCH=${new_arch}
export KDIR=${new_sysroot}/usr/src/kernel
export KSRC=${new_sysroot}/usr/src/kernel
export KERNELDIR=${new_sysroot}/usr/src/kernel
EOF
}
