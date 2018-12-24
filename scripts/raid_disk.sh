#!/bin/bash
# set -vx

DISK=$1
ITEM=$2

function getItem(){
	RESULT=$(sudo /usr/local/bin/MegaCli -pdInfo -PhysDrv \[$1\] -aALL | grep "$2" | awk -F : '{print $2}')
	echo $RESULT
}

case $ITEM in
	errors-media)
		RESPONSE=`getItem "${DISK}" "^Media Error Count"`;
		echo $RESPONSE;
		;;
	errors-other)
		RESPONSE=`getItem "${DISK}" "^Other Error Count"`;
		echo ${RESPONSE};
		;;
	predictive-failures)
		RESPONSE=`getItem "${DISK}" "^Predictive Failure Count"`;
		echo ${RESPONSE};
		;;
	inquiry-data)
		RESPONSE=`getItem "${DISK}" "^Inquiry Data"`;
		echo ${RESPONSE};
		;;
	drive-temp)
		RESPONSE=`getItem "${DISK}" "^Drive Temperature"`;
		echo ${RESPONSE} | awk -F C '{print $1}';
		;;
	smart-error-flag)
		RESPONSE=`getItem "${DISK}" "^Drive has flagged a S.M.A.R.T alert"`;
		if [ "${RESPONSE}"x == "No"x ]; then
			echo "1";  # 正常
		else
			echo "0";  # 不正常
		fi
		;;
	*)
		echo "ERROR: invalid val requested";
		exit 1;
esac
