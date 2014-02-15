#!/usr/local/bin/bash
#GNU bash, version 4 at least for associative arrays

package="php switcher. Require GNU bash version 4"

# example local php path array=(LoadModulPHP, ConfigPHP, ConfigPEAR)
# before use set correct PATH array and LoadModulPHP, ConfigPHP, ConfigPEAR
declare -A PATH55=(
	[LoadModulPHP]="/private/etc/apache2/extra/php55.conf" 
	[ConfigPHP]="/usr/local/etc/php/5.5/php.ini" 
	[ConfigPEAR]="/usr/local/etc/php/5.5/pear.conf"
)
declare -A PATH53=(
	[LoadModulPHP]="/private/etc/apache2/extra/php53.conf" 
	[ConfigPHP]="/usr/local/php5-5.3.27-20130930-102956/lib/php.ini" 
	[ConfigPEAR]="/Users/raf/.pearrc_53"
)

LoadModulPHP="/private/etc/apache2/extra/php.conf"
ConfigPHP="/etc/php.ini"
ConfigPEAR="/Users/raf/.pearrc"


# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
#

CLEAR_LINKS() {
	unlink ${LoadModulPHP}
	unlink ${ConfigPHP}
	unlink ${ConfigPEAR}
}

# $1 - LoadModulPHP
# $2 - ConfigPHP
# $3 - ConfigPEAR
CREATE_LINKS() {
	ln -s $1 ${LoadModulPHP}
        ln -s $2 ${ConfigPHP}
        ln -s $3 ${ConfigPEAR}	
}

FINISH() {
	echo "Restarting server."
	apachectl stop
	apachectl start
	echo "Done."
}

case "$1" in
	-h|--help)
                echo "$package [options]"
                echo " "
                echo "options:"
                echo "-h, --help  show help"
                echo "-php55      swithch local version php to 5.59"
                echo "-php53      swithch local version php to 5.3"
                exit 0
		;;
	-php55) 
		echo "switching to PHP5.5"
		CLEAR_LINKS
		CREATE_LINKS ${PATH55[LoadModulPHP]} ${PATH55[ConfigPHP]} ${PATH55[ConfigPEAR]}
		FINISH
		;;
	-php53)
		echo "switching to PHP5.3"
		CLEAR_LINKS
		CREATE_LINKS ${PATH53[LoadModulPHP]} ${PATH53[ConfigPHP]} ${PATH53[ConfigPEAR]}
		FINISH
		;;
	*)
		echo "use -h option for help"
		;;
esac