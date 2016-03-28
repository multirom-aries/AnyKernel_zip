



# Bump Image #
  dd if=$bin/bump bs=1 count=32 >> /tmp/anykernel/boot-new.img;
  dd if=/dev/zero of=$block;
  dd if=/tmp/anykernel/boot-new.img of=$block;