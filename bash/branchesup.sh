#!/usr/local/bin/bash

#GNU bash, version 4 at least for associative arrays

package="update local git branches."

case "$1" in
        -h|--help)
                echo "$package [options]"
                echo " "
                echo "options:"
                echo "-h, --help  show help"
                echo "first parameter is path to project"
                echo "all next parameters are list of branches to update"
                exit 0
                ;;
        *)
                echo "use -h option for help"
                echo "Starting updating"
		cd $(pwd)
		git pull --all
		git fetch origin
		for var in "$@" 
		do
    			echo "updating $var"
			git checkout $var
			git pull origin $var
		done
                ;;
esac
