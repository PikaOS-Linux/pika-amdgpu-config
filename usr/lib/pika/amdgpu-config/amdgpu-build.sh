#!/usr/bin/bash

cat /tmp/zenity/pika-amdgpu-config/components | grep "'"amf-amdgpu-pro"'"  && export "AMF_MODIFY"=TRUE && export "VLKPRO_MODIFY"=TRUE ||  export "AMF_MODIFY"=FALSE

cat /tmp/zenity/pika-amdgpu-config/components | grep "'"vulkan-amdgpu-pro"'" && export "VLKPRO_MODIFY"=TRUE ||  export "VLKPRO_MODIFY"=FALSE

cat /tmp/zenity/pika-amdgpu-config/components | grep "'"amdvlk"'"  &&  export "VLKOPEN_MODIFY"=TRUE ||  export "VLKOPEN_MODIFY"=FALSE

cat /tmp/zenity/pika-amdgpu-config/components | grep "'"opencl-legacy-amdgpu-pro-icd"'" && export "OCL_MODIFY"=TRUE ||  export "OCL_MODIFY"=FALSE



(
# install pika-amdgpu-core
echo "5"
echo "# Installing AMDGPU base files." ; sleep 2
sudo pkcon install -y pika-amdgpu-core
# Install vulkan-amdgpu-pro
if [[ "$VLKPRO_MODIFY" == TRUE ]]; then
echo "10"
echo "# Installing vulkan-amdgpu-pro." ; sleep 2
sudo pkcon install -y vulkan-amdgpu-pro vulkan-amdgpu-pro:i386
fi
# Install amdamf-runtime-pro
if [[ "$AMF_MODIFY" == TRUE ]]; then
echo "25"
echo "# Installing amdamf-runtime-pro." ; sleep 2
sudo pkcon install -y amf-amdgpu-pro
fi
# Install amdvlk
if [[ "$VLKOPEN_MODIFY" == TRUE ]]; then
echo "30"
echo "# Installing amdvlk." ; sleep 2
sudo pkcon install -y amdvlk amdvlk:i386
fi
# Install opencl-legacy-amdgpu-pro-icd
if [[ "$OCL_MODIFY" == TRUE ]]; then
echo "90"
echo "# Installing opencl-legacy-amdgpu-pro-icd." ; sleep 2
sudo pkcon install -y ocl-icd-libopencl1-amdgpu-pro ocl-icd-libopencl1-amdgpu-pro:i386 opencl-legacy-amdgpu-pro-icd opencl-legacy-amdgpu-pro-icd:i386
fi
# Clean
echo "100"
echo "# Cleaning." ; sleep 2
sudo rm -r /tmp/zenity/pika-amdgpu-config
) | 
zenity --progress \
--title='Install Progress' \
--text='Installing amdgpu-pro components , this might take while please be patient !'  \
--percentage=0 \
--auto-close \
--auto-kill

(( $? != 0 )) && zenity --error --text="Failed to install amdgpu-pro , please try again!." ||   zenity --info --window-icon='pika amdgpu installer' --text="Installation Complete!"
       
