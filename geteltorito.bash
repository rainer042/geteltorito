# Arseniy Chebotarjov, 2006, Kiev, Ukraine, ac@getLinux.com.ua
#!/bin/bash 
input="k3b_0.iso"
dd if="$input" of=eth.blk bs=2048 count=1 skip=17 2>/dev/null
if [ "$(dd if=eth.blk bs=71 count=1 2>/dev/null | md5sum | awk '{print $1}')"\
        = "2a32463b26e8d3705d0cdd15289a45bc" ]
then
        newblock=$(hexdump -s71 -n4 -e '"%d"' eth.blk)
        dd if="$input" of=eth.blk bs=2048 count=1 skip="$newblock" 2>/dev/null
        start=$(hexdump -s40 -n4 -e '"%d"' eth.blk)
        c2=$(hexdump -s38 -n1 -e '"%d"' eth.blk)
        c1=$(hexdump -s39 -n1 -e '"%d"' eth.blk)
        dd if="$input" of=eth.blk bs=2048 count=`echo "$c2"*256+"$c1" | bc` \
                skip="$start" 2>/dev/null
        echo Bingo, boot image @ eth.blk

else
        echo No Way
fi
