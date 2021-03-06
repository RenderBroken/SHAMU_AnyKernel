#!/system/bin/sh

############################
# Custom Kernel Settings for Render Kernel!!
#
echo "[Render-Kernel] Boot Script Started" | tee /dev/kmsg
stop mpdecision

############################
# State_Helper Settings
#
echo 20 > /sys/kernel/state_helper/batt_level_eco
echo 10 > /sys/kernel/state_helper/batt_level_cri

############################
# CPU-Boost Settings
#
# echo 20 > /sys/module/cpu_boost/parameters/boost_ms
echo 2000 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 0:883200 1:883200 2:883200 3:883200 > /sys/module/cpu_boost/parameters/input_boost_freq
# echo 1497600 > /sys/module/cpu_boost/parameters/sync_threshold
echo 30 > /sys/module/cpu_boost/parameters/migration_load_threshold
echo 0 > /sys/module/cpu_boost/parameters/hotplug_boost
echo 0 > /sys/module/cpu_boost/parameters/wakeup_boost

############################
# MSM Limiter
#
echo 0:268800 1:268800 2:268800 3:268800 > /sys/kernel/msm_limiter/suspend_min_freq
echo 0:2649600 1:2649600 2:2649600 3:2649600 > sys/kernel/msm_limiter/resume_max_freq
echo 0:1267200 1:1267200 2:1267200 3:1267200 > /sys/kernel/msm_limiter/suspend_max_freq
echo 1 > /sys/kernel/msm_limiter/freq_control 

############################
# Governor Tunings
#
echo ondemand > /sys/kernel/msm_limiter/scaling_governor
echo 95 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold
echo 50000 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_rate
echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/io_is_busy
echo 4 > /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor
echo 10 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential
echo 75 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_multi_core
echo 3 > /sys/devices/system/cpu/cpufreq/ondemand/down_differential_multi_core
echo 883200 > /sys/devices/system/cpu/cpufreq/ondemand/optimal_freq
echo 1190400 > /sys/devices/system/cpu/cpufreq/ondemand/sync_freq
echo 85 > /sys/devices/system/cpu/cpufreq/ondemand/up_threshold_any_cpu_load

echo smartmax > /sys/kernel/msm_limiter/scaling_governor
echo 729600 > /sys/devices/system/cpu/cpufreq/smartmax/suspend_ideal_freq
echo 1190400 > /sys/devices/system/cpu/cpufreq/smartmax/awake_ideal_freq
echo 1 > /sys/devices/system/cpu/cpufreq/smartmax/io_is_busy
echo 70 > /sys/devices/system/cpu/cpufreq/smartmax/max_cpu_load
echo 30 > /sys/devices/system/cpu/cpufreq/smartmax/min_cpu_load

echo elementalx > /sys/kernel/msm_limiter/scaling_governor
echo 883200 > /sys/devices/system/cpu/cpufreq/elementalx/active_floor_req
echo 1497600 > /sys/devices/system/cpu/cpufreq/elementalx/gboost_min_freq
echo 50000 > /sys/devices/system/cpu/cpufreq/elementalx/sampling_rate

echo interactive > /sys/kernel/msm_limiter/scaling_governor
echo 20000 1400000:40000 1700000:20000 > /sys/devices/system/cpu/cpufreq/interactive/above_hispeed_delay
echo 80 > /sys/devices/system/cpu/cpufreq/interactive/go_hispeed_load
echo 1190400 > /sys/devices/system/cpu/cpufreq/interactive/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpufreq/interactive/io_is_busy
echo 75 1500000:80 1800000:60 > /sys/devices/system/cpu/cpufreq/interactive/target_loads
echo 40000 > /sys/devices/system/cpu/cpufreq/interactive/min_sample_time
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_rate
echo 100000 > /sys/devices/system/cpu/cpufreq/interactive/max_freq_hysteresis
echo 30000 > /sys/devices/system/cpu/cpufreq/interactive/timer_slack

############################
# Scheduler and Read Ahead
#
echo zen > /sys/block/mmcblk0/queue/scheduler
echo 512 > /sys/block/mmcblk0/bdi/read_ahead_kb

############################
# LMK
#
echo 32 > /sys/module/lowmemorykiller/parameters/cost

############################
# Tweak Background Writeout
#
echo 1 > /sys/module/process_reclaim/parameters/enable_process_reclaim
echo 100 > /sys/module/process_reclaim/parameters/pressure_max
echo 20 > /proc/sys/vm/dirty_background_ratio
echo 200 > /proc/sys/vm/dirty_expire_centisecs
echo 40 > /proc/sys/vm/dirty_ratio
echo 0 > /proc/sys/vm/swappiness
echo 80 > /proc/sys/vm/vfs_cache_pressure

############################
# MISC Tweaks
#
echo 0 > /dev/cpuctl/apps/cpu.notify_on_migrate
echo 1 > /sys/module/state_notifier/parameters/enabled
echo 1 > /sys/module/workqueue/parameters/power_efficient
echo 0 > /sys/module/simple_gpu_algorithm/parameters/simple_gpu_activate
echo 0 > /sys/kernel/sched/gentle_fair_sleepers
echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled
echo "enabled" > /sys/devices/qcom,bcl.39/mode

############################
# Thermal - Adjust Defaults
#
echo 0 > /sys/module/msm_thermal/core_control/enabled
echo 1 > /sys/module/msm_thermal/parameters/enabled

############################
# Wake Geatures
#
echo 1 > /sys/android_touch/wake_gestures
echo 1 > /sys/android_touch/doubletap2wake

############################
# Disable Debugging
#
echo "0" > /sys/module/kernel/parameters/initcall_debug;
echo "0" > /sys/module/alarm_dev/parameters/debug_mask;
echo "0" > /sys/module/binder/parameters/debug_mask;
echo "0" > /sys/module/xt_qtaguid/parameters/debug_mask;
echo "[Render-Kernel] disable debug mask" | tee /dev/kmsg

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
	"allow debuggerd app_data_file dir search" \
[l;	"allow sensors diag_device chr_file { read write open ioctl }" \
	"allow sensors sensors capability net_raw" \
	"allow init kernel security setenforce" \
	"allow netmgrd netmgrd netlink_xfrm_socket nlmsg_write" \
	"allow netmgrd netmgrd socket { read write open ioctl }"
fi;

############################
# Google Services battery drain fixer by Alcolawl@xda
#
pm enable com.google.android.gms/.update.SystemUpdateActivity
pm enable com.google.android.gms/.update.SystemUpdateService
pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver
pm enable com.google.android.gms/.update.SystemUpdateService$Receiver
pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver
pm enable com.google.android.gsf/.update.SystemUpdateActivity
pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity
pm enable com.google.android.gsf/.update.SystemUpdateService
pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver
pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver

############################
# Init.d Support
#
/sbin/busybox run-parts /system/etc/init.d

############################
# Boot Script is complete, now enable SELinux
#
#setenforce 1
echo "[Render-Kernel] Boot Script Completed!" | tee /dev/kmsg
