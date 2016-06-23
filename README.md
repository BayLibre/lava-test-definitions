# BayLibre Job Templates #

## Health Tests ##

LAVA Jobs to run automatically for checking the DUT health

you may launch them manually with the script manual-test.sh for testing.


manual-test.sh usage:
```
$ ./manual-test.sh -h
usage:
1/ manual-test.sh [-h] --list : print list of possible test files
2/ manual-test.sh [-h] <test file> : excute test define in filename

where:
   -h | --help : print this usage
   --list :      list test files
```

print list of available test files:
```
$ ./manual-test.sh --list
health/juno-health.json
health/apq8016-sbc-health.json
health/meson-gxbb-p200-health.json
health/meson8b-odroidc1-health.json
health/bcm2835-rpi-b-plus-health.json
health/kvm-health.json
health/am335x-boneblack-health.json
health/apq8016-android.json
health/omap4-panda-es-health.json
test-shell/basic-tests.yaml
test-shell/mainline-v4.6-rc3-arm-multi_v7_defconfig-am335x-boneblack.dtb-beaglebone-black-ltp-mm3.json
```

execute test:
```
$ ./manual-test.sh health/am335x-boneblack-health.json

Execute test health/am335x-boneblack-health.json
submitted as job id: 952
```


