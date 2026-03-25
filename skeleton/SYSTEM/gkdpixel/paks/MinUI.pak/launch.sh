#!/bin/sh
# MiniUI.pak

#######################################

export PLATFORM="gkdpixel"
export SDCARD_PATH="/media/roms"
export BIOS_PATH="$SDCARD_PATH/Bios"
export SAVES_PATH="$SDCARD_PATH/Saves"
export CHEATS_PATH="$SDCARD_PATH/Cheats"
export SYSTEM_PATH="$SDCARD_PATH/.system/$PLATFORM"
export CORES_PATH="$SYSTEM_PATH/cores"
export USERDATA_PATH="$SDCARD_PATH/.userdata/$PLATFORM"
export SHARED_USERDATA_PATH="$SDCARD_PATH/.userdata/shared"
export LOGS_PATH="$USERDATA_PATH/logs"
export DATETIME_PATH="$SHARED_USERDATA_PATH/datetime.txt"

mkdir -p "$USERDATA_PATH"
mkdir -p "$LOGS_PATH"
mkdir -p "$SHARED_USERDATA_PATH/.minui"
mkdir -p "$CHEATS_PATH"

#######################################

killall -9 power_daemon
killall -9 key_daemon

#######################################

export LD_LIBRARY_PATH=$SYSTEM_PATH/lib:$LD_LIBRARY_PATH
export PATH=$SYSTEM_PATH/bin:$PATH

keymon.elf &

#######################################

# Try to read from hardware RTC first, fall back to file if not available
if [ -e /dev/rtc0 ]; then
    
	# Save current time before setting from RTC
    PRE_RTC_TIME=$(date +%s)

    # Use hwclock to set the system time from RTC
    hwclock -s

    # After setting, get the new time
    POST_RTC_TIME=$(date +%s)

    # If the RTC time is more than 1 hour behind (3600s), apply +2h correction
    DIFF=$(($PRE_RTC_TIME - $POST_RTC_TIME))
    if [ $DIFF -gt 3600 ]; then
        echo "Applying +2h correction to RTC time" >> "$LOGS_PATH/rtc.log"
        # Add 2 hours (7200s) and set the corrected time
        CORRECTED=$(($POST_RTC_TIME + 7200))
        date -u -s "@$CORRECTED"
        hwclock --utc -w
    fi

else
    # Fall back to the file-based approach
    if [ -f "$DATETIME_PATH" ]; then
        DATETIME=`cat "$DATETIME_PATH"`
        date +'%F %T' -s "$DATETIME"
        DATETIME=`date +'%s'`
        date -u -s "@$DATETIME"
    fi
fi

#######################################

AUTO_PATH=$USERDATA_PATH/auto.sh
if [ -f "$AUTO_PATH" ]; then
	"$AUTO_PATH"
fi

cd $(dirname "$0")

#######################################

EXEC_PATH="/tmp/minui_exec"
NEXT_PATH="/tmp/next"
touch "$EXEC_PATH"  && sync
while [ -f $EXEC_PATH ]; do
	minui.elf &> $LOGS_PATH/minui.txt
	echo `date +'%F %T'` > "$DATETIME_PATH"
	sync
	
	if [ -f $NEXT_PATH ]; then
		CMD=`cat $NEXT_PATH`
		eval $CMD
		rm -f $NEXT_PATH
		echo `date +'%F %T'` > "$DATETIME_PATH"
		sync
	fi
	
	if [ -f "/tmp/poweroff" ]; then
		break
	fi
done

poweroff # TODO: not sure this does anything
