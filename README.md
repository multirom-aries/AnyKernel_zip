AnyKernel2 - Flashable Zip Template for Kernel Releases with Ramdisk Modifications
by osm0sis @ xda-developers

Generate anykernel.zip by sndnvaps `<sndnvaps@gmail.com>`

"AnyKernel is a template for an update.zip that can apply any kernel to any ROM, regardless of ramdisk." - Koush


AnyKernel2 pushes the format even further by allowing kernel developers to modify the underlying ramdisk for kernel feature support easily using a number of included command methods along with properties and variables.

A working script based on DirtyV Kernel for Galaxy Nexus (tuna) is included for reference.

// Properties / Variables

```
kernel.string=KernelName by YourName @ xda-developers
do.devicecheck=1
do.initd=1
do.modules=1
do.cleanup=1
``` 
#device.name[1-3] now pick up from BoardConfig.mk 
```
device.name1=
device.name2=
device.name3=
```
# boot_block now define in BoardConfig.mk 

block=
```
do.devicecheck=1 specified requires at least device.name1 to be present. This should match ro.product.device or ro.build.product for your device. There is support for up to 5 device.name# properties.

do.initd=1 will create the init.d directory in /system/etc/init.d/ and apply 755 permissions.

do.modules=1 will push the contents of the module directory to /system/lib/modules/ and apply 644 permissions.

do.cleanup=0 will keep the zip from removing it's working directory in /tmp/anykernel - this can be useful if trying to debug in adb shell whether the patches worked correctly. 
```
// Command Methods
```
dump_boot
backup_file <file>
replace_string <file> <if search string> <original string> <replacement string>
replace_section <file> <begin search string> <end search string> <replacement string>
remove_section <file> <begin search string> <end search string>
insert_line <file> <if search string> <before|after> <line match string> <inserted line>
replace_line <file> <line replace string> <replacement line>
remove_line <file> <line match string>
prepend_file <file> <if search string> <patch file>
insert_file <file> <if search string> <before|after> <line match string> <patch file>
append_file <file> <if search string> <patch file>
replace_file <file> <permissions> <patch file>
patch_fstab <fstab file> <mount match name> <fs match type> <block|mount|fstype|options|flags> <original string> <replacement string>
write_boot
```
"if search string" is the string it looks for to decide whether it needs to add the tweak or not, so generally something to indicate the tweak already exists.

Similarly, "line match string" and "line replace string" are the search strings that locate where the modification needs to be made for those commands, "begin search string" and "end search string" are both required to select the first and last lines of the script block to be replaced for replace_section, and "mount match name" and "fs match type" are both required to narrow the patch_fstab command down to the correct entry.

"before|after" requires you simply specify "before" or "after" for the placement of the inserted line, in relation to "line match string".

"block|mount|fstype|options|flags" requires you specify which part (listed in order) of the fstab entry you want to check and alter.

You may also use ui_print "<text>" to write messages back to the recovery during the modification process, and contains "<string>" "<substring>" to simplify string testing logic you might want in your script.

Note: the "begin search string" and "end search string" arguments of replace_section and remove_section require any forward slashes (/) to be escaped.

// Instructions

1- Place zImage in the root (dtb should also go here for devices that require a custom one, both will fallback to the original if not included)
2- Place any required ramdisk files in /ramdisk
3- Place any required patch files (generally partial files which go with commands) in /patch
4- Modify the anykernel.sh to add your kernel's name, boot partition location, permissions for included ramdisk files, and use methods for any required ramdisk modifications
5- zip -r9 UPDATE-AnyKernel2.zip * -x README UPDATE-AnyKernel2.zip

If supporting a recovery that forces zip signature verification (like Cyanogen Recovery) then you will need to also sign your zip using the method I describe here:
http://forum.xda-developers.com/android/software-hacking/dev-complete-shell-script-flashable-zip-t2934449

Not required, but any tweaks you can't hardcode into the source should be added with a bootscript.sh like is done in the example provided.

Have fun!

# How to build anykernel.zip
```
	$cd $(TOP_ANDROID_SRC)
	$git clone https://github.com/nx511j-multirom/AnyKernel_zip.git -b master external/anykernel
	$set up AK_BOOT_BLOCK in BoardConfig.mk 
	$source build/envsetup.sh
	$lunch cm_DEVICENAME-eng #(replace DEVICENAME with you own specise,such as `aries,hammerhead`)
	$make anykernel_zip 
	$just have a coffce , anykernel.zip is build finish
	$copy $(TARGET_OUT)/anykernel.zip to you sdcard or use `adb sideload` to install it
```	

