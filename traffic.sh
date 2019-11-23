#!/bin/bash

source ./config.sh
echo "[+] Current setup"
echo "  [+] Services:"
for i in ${SERVICES[@]}; do
	echo "     $i"
done
echo "  [+] Dumps directory: $DUMPS_DIR"
echo "  [+] Round time: $ROUND_TIME"
echo "  [+] Rotate rounds: $ROUNDS"
echo "  [+] Listen interface: $INTERFACE"
echo ""


# Script logic
echo "[*] Script started"

if ! crontab -l >cronlist 2>/dev/null; then
	cronlist=""
fi
echo "[+] Get current cron jobs: $cronlist"

# Clean up
rm -rf $DUMPS_DIR

for i in ${SERVICES[@]}; do
	echo ""
	IFS=':'
	read -ra service <<< "$i"
	mkdir -p $DUMPS_DIR/"${service[0]}"
	cd $DUMPS_DIR
	echo "[*] Changed dir to $PWD"
		if [[ `id -u` == '1000' ]]; then
        	tcpdump -G $(( $ROUND_TIME * 3 )) -i $INTERFACE -w "${service[0]}"-%H-%M-%S.pcap -z "$SCRIPT_DIR/mv.sh" tcp port "${service[1]}" &
		else
			sudo tcpdump -G $(( $ROUND_TIME * 3 )) -i $INTERFACE -w "${service[0]}"-%H-%M-%S.pcap -z "$SCRIPT_DIR/mv.sh" tcp port "${service[1]}" &
		fi
	echo "01 * * * * $SCRIPT_DIR/archive.sh ${service[0]} $DUMPS_DIR" >> cronlist
done

echo "[+] Cron jobs: "
cat cronlist
crontab cronlist
rm -rf cronlist
