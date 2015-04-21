fee=$()
email=$()
datadir=$()
homedir=$()
daemon=$()
principal=$()
balance=$( ${daemon} getinfo | grep balance | sed -e 's/"balance" : //ig' -e 's/,//ig')
integer=$(echo $balance | awk -F. '{print $1}')
lastbalance=$(cat ${homedir}/lastbalance.txt)
lasttx=$( ${daemon} listtransactions "" 1 | grep category | sed -e 's/"category" : "//ig' -e 's/",//ig')
# Send an email when a new block is found
if [[ "${integer}" < "${lastbalance}" ]] && [[ "${lasttx}" == "        immature" ]]
 then
        echo "Stake Block Found" | mail -s "Stake Block Found" "${email}"
        echo "Block found email sent"
fi
#Send a email is an unexpected reduction in the balance happens
if [[ "${integer}" < "${lastbalance}" ]] && [[ "${lastbalance}" < "125001" ]]  && [[ "${lasttx}" == "        send" ]]
then
        echo "WALLET RED ALERT" | mail -s "Unexpected reduction in balance from ${lastbalance} to ${balance} Check IMMEDIATELY" "${email}"
        echo "Red Alert Email Sent"
fi
#Just for logging
echo "Integer balance: ${integer}"
echo ${integer} > ${homedir}/lastbalance.txt
echo "Floating point balance: ${balance}"
# If the balance is over the principal scrape it off
if [[ "${integer}" -gt "${principal}" ]]
then
        echo "Scraping balance:"
        #The principal amount to keep in the wallet
        send=$(echo "$balance - $principal - $fee" | bc)
        echo "  Send amount: ${send}"
        ${daemon} settxfee ${fee}
        echo "  TXID:"
        ${daemon} sendtoaddress ${depositaddress} $send
        echo "Scraped ${send} ${daemon} to ${depositaddress}" | mail -s "Stake Scraped" "${email}"
        echo "Scrape Email Sent"
fi
#just for logging
stakeweight=$( ${daemon} getmininginfo | grep -A4 'netstakeweight')
echo ${stakeweight}
