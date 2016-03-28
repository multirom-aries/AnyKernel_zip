#!/system/bin/sh

BB=/sbin/bb/busybox

############################
# Custom Kernel Settings for NebulaKernel
#
echo "[Nebula Kernel] Performance Boot Service Started" | tee /dev/kmsg
stop mpdecision

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

############################
# MSM Thermal (Intelli-Thermal v2)
#
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo 0 > /sys/module/msm_thermal/parameters/enabled

############################
# CPU-Boost Settings
#
# Needs updating to Alucard

############################
# Tweak Background Writeout
#
echo 200 > /proc/sys/vm/dirty_expire_centisecs
echo 40 > /proc/sys/vm/dirty_ratio
echo 5 > /proc/sys/vm/dirty_background_ratio
echo 10 > /proc/sys/vm/swappiness

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
echo interactive > /sys/kernel/msm_limiter/scaling_governor_0
echo interactive > /sys/kernel/msm_limiter/scaling_governor_1
echo interactive > /sys/kernel/msm_limiter/scaling_governor_2
echo interactive > /sys/kernel/msm_limiter/scaling_governor_3


############################
# LMK Tweaks
#
echo 2560,4096,8192,16384,24576,32768 > /sys/module/lowmemorykiller/parameters/minfree
echo 32 > /sys/module/lowmemorykiller/parameters/cost

echo "[Nebula Kernel] Performance Boot Service Completed!" | tee /dev/kmsg
