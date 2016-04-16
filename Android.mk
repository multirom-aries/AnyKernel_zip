# Android.mk for AnyKernel.zip
LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

ak_install_zip_path := $(LOCAL_PATH)/prebuilt_AnyKernel

ANYKERNEL_ZIP_TARGET := $(PRODUCT_OUT)/anykernel

ak_kernel_binary := $(PRODUCT_OUT)/kernel
ak_2nd_kernel_bianry := $(PRODUCT_OUT)/zImage
dtbimg	      := $(PRODUCT_OUT)/dt.img
system_module := $(TARGET_OUT)/lib/modules
ANYKERNEL_INS_DIR := $(PRODUCT_OUT)/anykernel_installer
system_module_ins_path := $(ANYKERNEL_INS_DIR)/system/lib/modules


ifeq ($(AK_BOOT_BLOCK),)
    $(warning ****************************************************************************)
    $(warning * AK_BOOT_BLOCK is not valid: '$(AK_BOOT_BLOCK)')
    $(warning * Please set up AK_BOOT_BLOCK In you BootConfig.mk .)
    $(warning * AK_BOOT_BLOCK is like :)
    $(warning * AK_BOOT_BLOCK := \/dev\/block\/platform\/msm_sdcc.1\/by-name\/boot )
    $(warning * You can find it in fstab.* from device .)
    $(warning ****************************************************************************)
    $(error stopping)
else

boot_block := $(AK_BOOT_BLOCK)

endif

$(ANYKERNEL_ZIP_TARGET): signapk bootimage
	@echo
	@echo
	@echo "    * Build AnyKernel.zip for" $(TARGET_DEVICE)
	@echo "    * Create anykernel.zip by sndnvaps"
	@echo "Thank you. See DONORS.md in  folder for more informations."
	@echo
	@echo

	@echo ----- Making AnyKernel ZIP installer ------
	rm -rf $(ANYKERNEL_INS_DIR)
	mkdir -p $(ANYKERNEL_INS_DIR)

	cp -a $(ak_install_zip_path)/* $(ANYKERNEL_INS_DIR)/
	if [ -f $(ANYKERNEL_INS_DIR)/anykernel.cfg ]; then \
	sed -i 's/kernel.string=/kernel.string=Anykernel\tfor\t$(TARGET_DEVICE)\tBy\tsndnvaps/' $(ANYKERNEL_INS_DIR)/anykernel.cfg; \
	sed -i 's/device.name1=/device.name1=$(TARGET_DEVICE)/' $(ANYKERNEL_INS_DIR)/anykernel.cfg; \
	sed -i 's/device.name2=/device.name2=$(PRODUCT_BRAND)/' $(ANYKERNEL_INS_DIR)/anykernel.cfg; \
	sed -i 's/device.name3=/device.name3=$(TARGET_PRODUCT)/' $(ANYKERNEL_INS_DIR)/anykernel.cfg; \
	sed -i 's/device.name4=/device.name4=$(PRODUCT_MODEL)/' $(ANYKERNEL_INS_DIR)/anykernel.cfg; \
	fi;
	if [ -f $(ANYKERNEL_INS_DIR)/anykernel.sh ]; then \
	sed -i 's/block=/block=$(AK_BOOT_BLOCK);/' $(ANYKERNEL_INS_DIR)/anykernel.sh; \
	fi;
	if [ -f $(ak_kernel_binary) ]; then cp -a $(ak_kernel_binary) $(ANYKERNEL_INS_DIR)/kernel; fi;
	if [ -f $(ak_2nd_kernel_bianry) ]; then cp -a $(ak_2nk_kernel_binary) $(ANYKERNEL_INS_DIR)/zImage; fi;
	if [ -f $(dtbimg) ]; then  cp -a $(dtbimg) $(ANYKERNEL_INS_DIR)/dt.img; fi;
	if [ -d $(system_module) ]; then  cp -rpa $(system_module) $(system_module_ins_path)/../; fi;
	rm -f $(ANYKERNEL_ZIP_TARGET).zip $(ANYKERNEL_ZIP_TARGET)-unsigned.zip
	cd $(ANYKERNEL_INS_DIR) && zip -qr ../$(notdir $@)-unsigned.zip *
	java -jar $(HOST_OUT_JAVA_LIBRARIES)/signapk.jar $(DEFAULT_SYSTEM_DEV_CERTIFICATE).x509.pem $(DEFAULT_SYSTEM_DEV_CERTIFICATE).pk8 $(ANYKERNEL_ZIP_TARGET)-unsigned.zip $(ANYKERNEL_ZIP_TARGET).zip
	$(ak_install_zip_path)/../rename_zip.sh $(ANYKERNEL_ZIP_TARGET) $(TARGET_DEVICE) $(PWD)/$(ak_install_zip_path)/../version.h
	@echo ----- Made AnyKernel ZIP installer -------- $@.zip

.PHONY: anykernel_zip
anykernel_zip: $(ANYKERNEL_ZIP_TARGET)
