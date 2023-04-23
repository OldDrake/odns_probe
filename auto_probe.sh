#!/bin/bash

ping www.baidu.com -c 1

work_dir="/odns_probe/"
zmap_dir="zmap-3.0.0-RC1"
zmap_result_dir="${work_dir}zmap_result/"
current_date=$(date +%Y%m%d)
zmap_result_filename="global-odns-${current_date}"
zmap_result_filepath=$zmap_result_dir$zmap_result_filename
bandwidth="2M"
whitelist="-w conf/ipv4-china.conf "
cd $zmap_dir
while getopts 'B:a' OPT; do
    case $OPT in
        B) bandwidth=$OPTARG;;
        a) whitelist="";;
        ?) echo "argument not exist";;
    esac
done
zmap -M udp -p 53 --probe-args=file:examples/udp-probes/dns_53_example_com.pkt --output-filter="repeat=0" --output-field=saddr,data -O csv4rdns -o $zmap_result_filepath -B $bandwidth ${whitelist}2>&1

cd $work_dir
prober_result_dir="output/${current_date}/"
mkdir $prober_result_dir
prober_output="${prober_result_dir}global-fwd-rdns-${current_date}.json"
./rdns_prober -input $zmap_result_filepath -output $prober_output -id $current_date

