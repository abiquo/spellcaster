install
text

network --device eth0 --bootproto dhcp --hostname demo01

url --url http://mirror.bcn.abiquo.com/centos/5/os/x86_64
key --skip

lang en_US.UTF-8
langsupport --default=en_US.UTF-8 en_US.UTF-8
keyboard us
mouse none

zerombr yes
clearpart --all --drives=sda

part /boot --fstype ext2 --size=100
part pv.6 --size=22000 --grow --ondisk=sda
volgroup systemvg pv.6
logvol / --fstype=ext3 --name=rootlv --vgname=systemvg --size=8000
logvol /tmp --fstype=ext3 --name=tmplv --vgname=systemvg --size=1000
logvol swap --fstype=swap --name=swaplv --vgname=systemvg --size=1024

bootloader --location=mbr --driveorder=sda --append="rhgb quiet"
timezone Europe/Madrid
rootpw --iscrypted $1$TtUM5t1o$hGotzsHr9hsWM8NtNdGAP.
authconfig --enableshadow --enablemd5
selinux --disabled
reboot
firewall --disabled
skipx


%packages --resolvedeps --nobase

@core

#
# Useless stuff
#
#%post
