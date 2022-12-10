#!/usr/bin/bash

run_func() {
	# Clean and make tmp dir

	rm -r /tmp/zenity/pika-amdgpu-config/components
	mkdir -p /tmp/zenity/pika-amdgpu-config/
	
	export CMD1_RETURN=1
	
	# Check for current packages

	dpkg-query -l  amf-amdgpu-pro && export "AMF_STATE"=TRUE || export "AMF_STATE"=FALSE
	dpkg-query -l  vulkan-amdgpu-pro && export "VLKPRO_STATE"=TRUE || export "VLKPRO_STATE"=FALSE
	dpkg-query -l  amdvlk && export "VLKOPEN_STATE"=TRUE || export "VLKOPEN_STATE"=FALSE
	dpkg-query -l  opencl-legacy-amdgpu-pro-icd && export "OCL_STATE"=TRUE || export "OCL_STATE"=FALSE
	
		if [[ "$AMF_STATE" == TRUE ]]; then
		export ENT1_0=$AMF_STATE
		export ENT1_1=amf-amdgpu-pro
		fi
		#
		if [[ "$VLKPRO_STATE" == TRUE ]]; then
		export ENT2_0=$VLKPRO_STATE
		export ENT2_1=vulkan-amdgpu-pro
		fi
		#
		if [[ "$VLKOPEN_STATE" == TRUE ]]; then
		export  ENT4_0=$VLKOPEN_STATE
		export  ENT4_1=amdvlk
		fi
		#
		if [[ "$OCL_STATE" == TRUE ]]; then
		export  ENT6_0=$OCL_STATE
		export  ENT6_1=opencl-legacy-amdgpu-pro-icd
		fi
	
	CMD1() { 
		zenity $( (( "$AMF_STATE" == TRUE )) && echo " "$ENT1_0" "$ENT1_1" " ) \
		$( (( "$VLKPRO_STATE" == TRUE )) && echo " "$ENT2_0" "$ENT2_1" " ) \
		$( (( "$VLKOPEN_STATE" == TRUE )) && echo " "$ENT4_0" "$ENT4_1"  " ) \
		$( (( "$OCL_STATE" == TRUE )) && echo " "$ENT6_0" "$ENT6_1"  " ) \
		--list --column Selection --column Package \
		--separator=" " --checklist --title='Component removal selection' --width 600 --height 450  | tee -a /tmp/zenity/pika-amdgpu-config/components
	}
	
	CMD1
	
	if [ -s /tmp/zenity/pika-amdgpu-config/components ] 
	then
		export CMD1_RETURN=0
	fi
	
	if [[ "$CMD1_RETURN" == 0 ]]
	then
		pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY bash -c "pkcon remove -y $(cat  /tmp/zenity/pika-amdgpu-config/components)" && rm -r /tmp/zenity/pika-amdgpu-config || echo && zenity --info --window-icon='pika amdgpu uninstaller' --text="Removal Complete!"
	else
		zenity --error --text="Failed to remove amdgpu-pro , please try again!."
	fi
}
run_func
