# Scraper
This is a simple scraper for scraping staked coins off and moving to a new wallet such as your cryptsy deposit adress :)

Dependancies:

apt-get install bc

Update the following variables at the beggining of the script.

fee=$() # this is the fee that will be paid on your scraping transactions.
email=$() # this is the email where the notification emails will be sent. (postifix or sendmail must be configured)
datadir=$() # the directory where the blockchain data is stored
homedir=$() # homedir the home directory of the user that launched the daemon
daemon=$() # the daemon name. The daemon must be in your path. Moving to /usr/bin will suffice
principal=$() # this is the principal amount. This will be left behind to stake again each round

Run this as a cron however often you like and pipe the output to a logile

Example for once per minute:

* * * * * bash /home/user/scraper.sh >> /home/user/scraper.log
