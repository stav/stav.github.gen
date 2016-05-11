+++
date = "2016-05-10T20:30:42-06:00"
title = "Ubuntu on the Lenovo Yoga Ultrabook"
draft = "True"

+++

My Lenovo Yoga 2 Pro 13 is a wonderful machine.

Features:

* slim
* sexy matte black
* backlite keyboard

Hardware:

* 7.7 GiB RAM
* super fast 256 Gb SSD
* Intel Core i7-4500U CPU @ 1.80GHz × 4
* Intel Haswell Mobile graphics @ 3200x1800

Pros:

* small & fast
* Ubuntu runs on it out of the box

Cons:

* no ethernet port, and...
* the wifi card has issues

**Here's a few things I did to set it up**

## Ignore Access Time

Tell the root partition devie to not have to write access time journal entries

In `/etc/fstab`:

    UUID=d65e4ad3-6315-4838-97a1-ec574cb8575f / ext4 noatime,discard,errors=remount-ro  0  1

* http://ubuntuforums.org/showthread.php?t=1928155&p=11702911#post11702911

## SSD Performance

In `/etc/fstab`:

    /dev/sda   /   ext4   noatime,nodiratime,discard,errors=remount-ro 0 1
    tmpfs   /tmp       tmpfs   defaults,noatime,mode=1777   0  0

In `/etc/rc.local`:

    echo deadline > /sys/block/sda/queue/scheduler
    echo 0 > /proc/sys/vm/swappiness

In `/etc/default/grub`:

    GRUB_CMDLINE_LINUX_DEFAULT=”quiet splash elevator=deadline”

From command line:

    sudo update-grub2

Moving the cache in Chrome is a little harder. The directory is hardcoded but
you can use symbolic links to point it to a directory on another drive or to
`/tmp`. You'll find the cache under `~/.cache/chromium`. You could also redirect
the entire .cache directory as many programs use this for caching data.

In Linux simply run `fdisk -cu (device)` on the drive you want to partition
press `n` for new partition `p` for primary and enter a start sector of at
least 2048. The general rule is that the starting sector must be divisible by
512 but to cater for all variations of SSD page size and filesystem block size
2048 is a good idea.

* http://apcmag.com/how-to-maximise-ssd-performance-with-linux.htm



## Next

https://sites.google.com/site/easylinuxtipsproject/ssd

    Reserve 10% SSD unallocated for overprovisioning

    Noatime in /etc/fstab
        UUID=633603b4-665b-408b-beea-868e3d8c2428   /  ext4  noatime,errors=remount-ro 0  1

    TRIM
        Preferred method: by rc.local
        /etc/rc.local
            fstrim -v /

        Not advised: by discard
        /etc/fstab
            UUID=f0ae2c59-83d2-42e7-81c4-2e870b6b255d   /   ext4 discard,errors=remount-ro   0   1

        Disable the superfluous weekly cron job for TRIM
        sudo mv -v /etc/cron.weekly/fstrim /fstrim

    Swap
    cat /proc/sys/vm/swappiness
    /etc/sysctl.conf
        # Sharply reduce swap inclination
        vm.swappiness=1
        # Improve cache management
        vm.vfs_cache_pressure=50


    Reboot

    Limit the write actions of Chrome and Chromium

    Check which scheduler is being used
    cat /sys/block/sda/queue/scheduler

    Do NOT enable hibernation

    Dual boot? Don't let Windows kill your SSD
    Defragmentation will kill your SSD in a very short time, because of the multitude of write actions that it causes.

    /etc/fstab
        tmpfs      /tmp          tmpfs      defaults,noatime,mode=1777    0    0

http://askubuntu.com/questions/450066/rotate-touchscreen-and-disable-the-touchpad-on-yoga-2-pro-in-rotated-mode

    synclient TouchpadOff=1

    (and re-enable with 0)

    I tried xev to get the keycode for Fn+F6 but pressing this combo generates no output.

    stav@platu:~/Workspace/timelion-carbon$ synclient |grep Touch
    TouchpadOff = 2

https://stuffivelearned.org/doku.php?id=os:linux:general:synapticstouchtricks

    $ sudo apt-get install gsynaptics

https://help.ubuntu.com/community/SynapticsTouchpad

    Turning Synaptics Touchpads On/Off with a Shortcut Key
