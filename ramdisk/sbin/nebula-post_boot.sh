#!/system/bin/sh
###########################################################################################
###          -=[ The Nebula Project: The NebulaKernel Post Boot Script ]=-              ###
### ----------------------------------------------------------------------------------- ###
### UpDated: 11/15/2015    Custom Kernel Settings                                       ###
###                                                                                     ###
###-------------------------------------------------------------------------------------###
### CPU Default 657 Since we now OC 700mhz                                              ###
### Tweak Background Writeout                                                           ###
### ZRAM Settings (Disabled for now)                                                    ###
### MSM_Hotplug Settings                                                                ###
### MSM Limiter                                                                         ###
### GPU CLK: Set default to 657                                                         ###
### MSM Thermal (Intelli-Thermal v2)                                                    ###
### Alucard Touch Boost Settings                                                        ###
### Power Effecient Workqueues (Enable for battery)                                     ###
### Scheduler and Read Ahead                                                            ###
### Governor Tunings                                                                    ###
### LMK Tweaks, MISC Tweaks, SuperUser Tweaks (TESTING)                                 ###
### Disable Debugging                                                                   ###
### disable sysctl.conf to prevent ROM interference with tunables                       ###
### disable the PowerHAL since there is now a kernel-side touch boost implemented       ###
### backup and replace Host AP Daemon for working Wi-Fi tether                          ###
###        on 3.4 kernel Wi-Fi drivers (Disabled For Now)                               ###
### fix permissions for any included governors (and older underlying ramdisks)          ###
### lmk tweaks for fewer empty background processes                                     ###
### lmk whitelist for common launchers and increase launcher priority                   ###
### wait for systemui and increase its priority                                         ###
### remount sysfs+sdcard with noatime,nodiratime since that's all they accept           ###
###########################################################################################
BB=/sbin/bb/busybox

echo "-----------------------------------------------------------" | tee /dev/kmsg
echo "[NebulaKernel] Boot Script Started" | tee /dev/kmsg
stop mpdecision

# disable sysctl.conf to prevent ROM interference with tunables
$BB mount -o rw,remount /system;
$BB [ -e /system/etc/sysctl.conf ] && $BB mv -f /system/etc/sysctl.conf /system/etc/sysctl.conf.dvbak;

# disable the PowerHAL since there is now a kernel-side touch boost implemented
$BB [ -e /system/lib/hw/power.so.dvbak ] || $BB cp /system/lib/hw/power.so /system/lib/hw/power.so.dvbak;
$BB [ -e /system/lib/hw/power.so ] && $BB rm -f /system/lib/hw/power.so;

# backup and replace Host AP Daemon for working Wi-Fi tether on 3.4 kernel Wi-Fi drivers
#$BB [ -e /system/bin/hostapd.dvbak ] || $BB cp /system/bin/hostapd /system/bin/hostapd.dvbak;
#$BB cp -f /sbin/hostapd /system/bin/;
#$BB chown root.shell /system/bin/hostapd;
#$BB chmod 755 /system/bin/hostapd;


############################
# Tweak Background Writeout
#
echo 200 > /proc/sys/vm/dirty_expire_centisecs
echo 40 > /proc/sys/vm/dirty_ratio
echo 5 > /proc/sys/vm/dirty_background_ratio
echo 0 > /proc/sys/vm/swappiness

############################
# ZRAM Settings
#
#echo "lzo [lz4]" > /sys/block/zram0/comp_algorithm
#echo 3 > /sys/block/zram0/max_comp_stream
#echo 300 > /sys/devices/virtual/block/zram0/disksize

############################
# MSM_Hotplug Settings
#
echo 4 > /sys/module/msm_hotplug/min_cpus_online
echo 4 > /sys/module/msm_hotplug/cpus_boosted
echo 500 > /sys/module/msm_hotplug/down_lock_duration
echo 2500 > /sys/module/msm_hotplug/boost_lock_duration
echo 200 5:100 50:50 350:200 > /sys/module/msm_hotplug/update_rates
echo 100 > /sys/module/msm_hotplug/fast_lane_load
echo 1 > /sys/module/msm_hotplug/max_cpus_online_susp

############################
# MSM Limiter
#
echo 729000 > /sys/kernel/msm_limiter/suspend_min_freq_0
echo 729000 > /sys/kernel/msm_limiter/suspend_min_freq_1
echo 729000 > /sys/kernel/msm_limiter/suspend_min_freq_2
echo 729000 > /sys/kernel/msm_limiter/suspend_min_freq_3
echo 2880000 > /sys/kernel/msm_limiter/resume_max_freq_0
echo 2880000 > /sys/kernel/msm_limiter/resume_max_freq_1
echo 2880000 > /sys/kernel/msm_limiter/resume_max_freq_2
echo 2880000 > /sys/kernel/msm_limiter/resume_max_freq_3
echo 2880000 > /sys/kernel/msm_limiter/suspend_max_freq

###################################################################
### GPU CLK: Set default to 657 ###
echo 657500000 > /sys/class/kgsl/kgsl-3d0/max_gpuclk﻿
echo 657500000 > /sys/devices/fdb00000.qcom,kgsl-3d0/devfreq/fdb00000.qcom,kgsl-3d0/max_freq

############################
# MSM Thermal (Intelli-Thermal v2)
#
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo 0 > /sys/module/msm_thermal/parameters/enabled

############################
# Alucard Touch Boost Settings
#
#echo 1497600 > /sys/module/alu_t_boost/parameters/input_boost_freq

############################
# Power Effecient Workqueues (Enable for battery)
#
echo 0 > /sys/module/workqueue/parameters/power_efficient

############################
# Scheduler and Read Ahead
#
echo row > /sys/block/mmcblk0/queue/scheduler
echo 1024 > /sys/block/mmcblk0/bdi/read_ahead_kb

############################
# Governor Tunings
#

### Default Governor on Boot ###
echo interactive > /sys/kernel/msm_limiter/scaling_governor_0
echo interactive > /sys/kernel/msm_limiter/scaling_governor_1
echo interactive > /sys/kernel/msm_limiter/scaling_governor_2
echo interactive > /sys/kernel/msm_limiter/scaling_governor_3
echo 20000 1400000:40000 1700000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 90 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
echo 2880000 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
echo 85 1500000:90 1800000:70 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo 100000 > /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack

############################
# LMK Tweaks
#
echo 2560,4096,8192,16384,24576,32768 > /sys/module/lowmemorykiller/parameters/minfree
echo 32 > /sys/module/lowmemorykiller/parameters/cost

############################
# MISC Tweaks
#
echo 0 > /sys/kernel/sched/gentle_fair_sleepers

############################
# Disable Debugging
#
echo "0" > /sys/module/kernel/parameters/initcall_debug;
echo "0" > /sys/module/alarm_dev/parameters/debug_mask;
echo "0" > /sys/module/binder/parameters/debug_mask;
echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask;
echo "[NebulaKernel] disable debug mask" | tee /dev/kmsg

############################
# SuperUser Tweaks (TESTING)
# Allow untrusted apps to read from debugfs
if [ -e /system/lib/libsupol.so ]; then
/system/xbin/supolicy --live \
	"allow untrusted_app debugfs file { open read getattr }" \
	"allow untrusted_app sysfs_lowmemorykiller file { open read getattr }" \
	"allow untrusted_app persist_file dir { open read getattr }" \
	"allow debuggerd gpu_device chr_file { open read getattr }" \
	"allow netd netd capability fsetid" \
	"allow netd { hostapd dnsmasq } process fork" \
	"allow { system_app shell } dalvikcache_data_file file write" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file dir { search r_file_perms r_dir_perms }" \
	"allow { zygote mediaserver bootanim appdomain }  theme_data_file file { r_file_perms r_dir_perms }" \
	"allow system_server { rootfs resourcecache_data_file } dir { open read write getattr add_name setattr create remove_name rmdir unlink link }" \
	"allow system_server resourcecache_data_file file { open read write getattr add_name setattr create remove_name unlink link }" \
	"allow system_server dex2oat_exec file rx_file_perms" \
	"allow mediaserver mediaserver_tmpfs file execute" \
	"allow drmserver theme_data_file file r_file_perms" \
	"allow zygote system_file file write" \
	"allow atfwd property_socket sock_file write" \
	"allow debuggerd app_data_file dir search"
fi;

# remount sysfs+sdcard with noatime,nodiratime since that's all they accept
$BB mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /;
$BB mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /proc;
$BB mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /sys;
$BB mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /sys/kernel/debug;
$BB mount -o remount,nosuid,nodev,noatime,nodiratime -t auto /mnt/shell/emulated;
for i in /storage/emulated/*; do
  $BB mount -o remount,nosuid,nodev,noatime,nodiratime -t auto $i;
  $BB mount -o remount,nosuid,nodev,noatime,nodiratime -t auto $i/Android/obb;
done;

# fix permissions for any included governors (and older underlying ramdisks)
governor=reset;
while sleep 1; do
  current=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`;
  if [ $governor != $current ]; then
    governor=$current;
    for i in /sys/devices/system/cpu/cpufreq/*; do
      $BB chown system:system $i/*;
      $BB chmod 664 $i/*;
    done;
  fi;
done&

# lmk tweaks for fewer empty background processes
minfree=6144,8192,12288,16384,24576,40960;
lmk=/sys/module/lowmemorykiller/parameters/minfree;
minboot=`cat $lmk`;
while sleep 1; do
  if [ `cat $lmk` != $minboot ]; then
    [ `cat $lmk` != $minfree ] && echo $minfree > $lmk || exit;
  fi;
done&

# lmk whitelist for common launchers and increase launcher priority
list="com.android.launcher com.google.android.googlequicksearchbox org.adw.launcher org.adwfreak.launcher net.alamoapps.launcher com.anddoes.launcher com.android.lmt com.chrislacy.actionlauncher.pro com.cyanogenmod.trebuchet com.gau.go.launcherex com.gtp.nextlauncher com.miui.mihome2 com.mobint.hololauncher com.mobint.hololauncher.hd com.qihoo360.launcher com.teslacoilsw.launcher com.tsf.shell org.zeam";
while sleep 60; do
  for class in $list; do
    if [ `$BB pgrep $class | head -n 1` ]; then
      launcher=`$BB pgrep $class`;
      $BB echo -17 > /proc/$launcher/oom_adj;
      $BB chmod 100 /proc/$launcher/oom_adj;
      $BB renice -18 $launcher;
    fi;
  done;
  exit;
done&

# wait for systemui and increase its priority
while sleep 1; do
  if [ `$BB pidof com.android.systemui` ]; then
    systemui=`$BB pidof com.android.systemui`;
    $BB renice -18 $systemui;
    $BB echo -17 > /proc/$systemui/oom_adj;
    $BB chmod 100 /proc/$systemui/oom_adj;
    exit;
  fi;
done&

echo "[NebulaKernel] Boot Script Completed!" | tee /dev/kmsg
echo "-----------------------------------------------------------" | tee /dev/kmsg
