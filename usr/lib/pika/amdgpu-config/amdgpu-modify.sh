#!/usr/bin/bash

rm -rf /tmp/zenity/pika-amdgpu-config/components || echo

# Detect if an amdgpu is present

amdgpu=$(lspci | grep -iE 'VGA|3D' | grep -i amd | cut -d ":" -f 3)

if [[ ! -z $amdgpu ]]; then
    echo "amdgpu detected" && export "AMDGPU_DETECTED"=TRUE	
else
    echo "No amdgpu detected on your system!"
    zenity --error --text="No amdgpu detected on your system!"
fi

# Start 

if [[ "$AMDGPU_DETECTED" == TRUE ]]; then
	zenity --warning --text="Some of this software is proprietary! ."
	
		
	
	# Clean and make tmp dir
	
	rm -r /tmp/zenity/pika-amdgpu-config
	mkdir -p /tmp/zenity/pika-amdgpu-config/
	
	# Get EULA
	
	wget https://raw.githubusercontent.com/PikaOS-Linux/pika-amdgpu-config/master/RADEON-LICENSE.md -O /tmp/zenity/pika-amdgpu-config/EULA

	if zenity --text-info --title="Radeon™ Software for Linux End User License Agreement" --filename=/tmp/zenity/pika-amdgpu-config/EULA  --checkbox="I read and accept the terms." 
	then
		# Check for current packages
	
	dpkg-query -l amf-amdgpu-pro && export "AMF_STATE"=TRUE || export "AMF_STATE"=FALSE
	dpkg-query -l vulkan-amdgpu-pro && export "VLKPRO_STATE"=TRUE || export "VLKPRO_STATE"=FALSE
	dpkg-query -l amdvlk && export "VLKOPEN_STATE"=TRUE || export "VLKOPEN_STATE"=FALSE
	dpkg-query -l opencl-legacy-amdgpu-pro-icd && export "OCL_STATE"=TRUE || export "OCL_STATE"=FALSE
	
	# Zenity list
	
	export COMP_SEC=$(zenity --list --column Selection --column Package --column Description \
	"$AMF_STATE" amf-amdgpu-pro 'AMD™ "Advanced Media Framework" can be used for H265/H264 encoding & decoding' \
	"$VLKPRO_STATE" vulkan-amdgpu-pro 'AMD™ Proprietary Vulkan implementation can be used for HW ray-tracing & and is needed for AMF (this can be invoked by "$ vk_pro" from the amdgpu-vulkan-switcher package) '  \
	"$VLKOPEN_STATE" amdvlk 'AMD™ 1st party Vulkan implementation (this can be invoked by "$ vk_amdvlk" from the amdgpu-vulkan-switcher package) ' \
	"$OCL_STATE" opencl-legacy-amdgpu-pro-icd  'AMD™ Proprietary OpenCL implementation (this can be invoked by "$ cl_pro" from the amdgpu-opencl-switcher package) (USE ROCM INSTEAD, UNLESS SPECIFICALLY NEEDED!) ' \
	--separator="'" --checklist --title='Component install selection' --width 920 --height 450)
	
	if [[ ! -z "$COMP_SEC" ]]
	then
		echo "'"$COMP_SEC"'" | tee -a /tmp/zenity/pika-amdgpu-config/components
	fi
	
		# Warn users about broken packages
		if [ -s /tmp/zenity/pika-amdgpu-config/components ]
		then
		zenity --warning --text="Do not interrupt this process ! , this might take while please be patient !"
	
		# Danger SUDO
	
		pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY /usr/lib/pika/amdgpu-config/amdgpu-build.sh
		else
		rm -r /tmp/zenity/pika-amdgpu-config
		echo "Stop installation!" && zenity --warning --text="No drivers selected!"
		rm -rf /tmp/zenity/pika-amdgpu-config/components || echo
		exit
		fi
	else
	rm -r /tmp/zenity/pika-amdgpu-config
	echo "Stop installation!" && zenity --warning --text="Not installing additional drivers!"
	rm -rf /tmp/zenity/pika-amdgpu-config/components || echo
	exit
	fi
	
	
	else 
	rm -r /tmp/zenity/pika-amdgpu-config
	zenity --warning --text="Not installing additional drivers!"
	rm -rf /tmp/zenity/pika-amdgpu-config/components || echo
	fi
else 
	echo "ending script!"
	rm -rf /tmp/zenity/pika-amdgpu-config/components || echo
fi

