#!/bin/bash

usage()
{
    echo "./build.sh <device> <recovery type> -t <bootimage / recoveryimage>"
    echo "Supported recoveries : "
    echo " TWRP | PBRP | SHRP | OFox "
    echo "For -t, default is recoveryimage, which is more common."
    echo "If your device sticks with recoveryimage, you don't need to define this variable."
}

#Vars
TYPE=recoveryimage
WORKDIR=work
OUTDIR=$WORKDIR/out/target/product/$1
DEVICE=$1
DT=$(cat CONFIG | grep device)
KT=$(cat CONFIG | grep kernel)

if [[ $(cat CONFIG | grep device) ]]; then
    echo "" >> /dev/null
else 
    echo "No Config found. Check config.sh for more. Exiting."
    exit
fi

if [[ ! -n $1 ]]; then
    echo "Please define device name !"
    exit
fi

if [[ ! -n $2 ]]; then
    echo "Please tell me what you wanna build !"
    exit
fi

if [[ $2 == "TWRP" ]]; then
    MANIFEST=git://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
elif [[ $2 == "SHRP" ]]; then
    MANIFEST=git://github.com/SKYHAWK-Recovery-Project/platform_manifest_twrp_omni.git -b android-9.0
elif [[ $2 == "PBRP" ]]; then
    MANIFEST=git://github.com/PitchBlackRecoveryProject/manifest_pb.git -b android-9.0
elif [[ $2 == "OFox" ]]; then
    MANIFEST=git://gitlab.com/OrangeFox/Manifest.git -b fox_9.0
else
    echo "================================================"
    echo "= Unknown recovery type. Supported types are : ="
    echo "=          TWRP | SHRP | PBRP | OFox           ="
    echo "================================================"  
    exit
fi

# Lit shit
mkdir $WORKDIR
cd $WORKDIR
echo "Recovery : Sync Sources"
repo init -u $MANIFEST --depth=1 --groups=all,-notdefault,-device,-darwin,-x86,-mips >> /dev/null
repo sync --force-sync -j4
$DT >> /dev/null
$KT >> /dev/null
echo "Sync done."
echo "Lunching.."
. build/envsetup.sh >> /dev/null
lunch omni_$DEVICE-eng
clear
mka $TARGET -j4

if [[ $2 == "TWRP" ]]; then
    FINAL=$(ls $OUTDIR | grep recovery)
else
    FINAL=$(ls $OUTDIR | grep zip)
fi

clear

if [[ $FINAL == "*.img" ]]; then
    echo "" >> /dev/null
elif [[ $FINAL == "*.zip" ]]; then
    echo "" >> /dev/null
else 
    echo "Build failed "
    exit
fi

echo "=========================="
echo "=     $2 Build done !    ="
echo "=  Final image : $FINAL  ="
echo "=========================="
