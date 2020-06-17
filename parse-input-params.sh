#!/bin/bash
#
# This is a rather minimal example Argbash potential
# Example taken from http://argbash.readthedocs.io/en/stable/example.html
#
# ARG_OPTIONAL_SINGLE([controller-host],[c],[controller host (without trailing bakslash)])
# ARG_OPTIONAL_SINGLE([controller-port],[P],[controller port])

# ARG_OPTIONAL_SINGLE([username],[u],[AppDynamics user username])
# ARG_OPTIONAL_SINGLE([password],[p],[AppDynamics user password])

# ARG_OPTIONAL_BOOLEAN([use-proxy],[],[use proxy optional argument])
# ARG_OPTIONAL_SINGLE([proxy-url],[],[proxy url])
# ARG_OPTIONAL_SINGLE([proxy-port],[],[proxy port, mandatory if use-proxy set to true])

# ARG_OPTIONAL_SINGLE([application-name],[a],[application name])

# ARG_OPTIONAL_BOOLEAN([include-database],[],[database name])
# ARG_OPTIONAL_SINGLE([database-name],[d],[mandatory if include-database set to true])

# ARG_OPTIONAL_BOOLEAN([include-sim],[s],[include server visibility])
# ARG_OPTIONAL_BOOLEAN([configure-bt],[b],[configure busness transactions])
# ARG_HELP([The general script's help msg])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.8.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate


die()
{
	local _ret=$2
	test -n "$_ret" || _ret=1
	test "$_PRINT_HELP" = yes && print_help >&2
	echo "$1" >&2
	exit ${_ret}
}


begins_with_short_option()
{
	local first_option all_short_options='cPupadsbh'
	first_option="${1:0:1}"
	test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_controller_host=
_arg_controller_port=8090
_arg_username=
_arg_password=
_arg_use_proxy="off"
_arg_proxy_url=
_arg_proxy_port=
_arg_application_name=
_arg_include_database="off"
_arg_database_name=
_arg_include_sim="off"
_arg_configure_bt="off"

_arg_use_proxy_explicitly_set=false
_arg_include_database_explicitly_set=false
_arg_include_sim_explicitly_set=false
_arg_configure_bt_explicitly_set=false

print_help()
{
	printf '%s\n' ""
	printf 'Usage: %s [-c|--controller-host <arg>] [-P|--controller-port <arg>] [-u|--username <arg>] [-p|--password <arg>] [--(no-)use-proxy] [--proxy-url <arg>] [--proxy-port <arg>] [-a|--application-name <arg>] [--(no-)include-database] [-d|--database-name <arg>] [-s|--(no-)include-sim] [-b|--(no-)configure-bt] [-h|--help]\n' "$0"
	printf '\t%s\n' "-c, --controller-host: controller host (without trailing bakslash) (no default)"
	printf '\t%s\n' "-P, --controller-port: controller port (${_arg_controller_port} by default)"
	printf '\t%s\n' "-u, --username: AppDynamics user username (no default)"
	printf '\t%s\n' "-p, --password: AppDynamics user password (no default)"
	printf '\t%s\n' "--use-proxy, --no-use-proxy: use proxy optional argument (off by default)"
	printf '\t%s\n' "--proxy-url: proxy url (no default)"
	printf '\t%s\n' "--proxy-port: proxy port, mandatory if use-proxy set to true (no default)"
	printf '\t%s\n' "-a, --application-name: application name (no default)"
	printf '\t%s\n' "--include-database, --no-include-database: database name (off by default)"
	printf '\t%s\n' "-d, --database-name: mandatory if include-database set to true (no default)"
	printf '\t%s\n' "-s, --include-sim, --no-include-sim: include server visibility (off by default)"
	printf '\t%s\n' "-b, --configure-bt, --no-configure-bt: configure busness transactions (off by default)"
	printf '\t%s\n' "-h, --help: Prints help"
	printf '%s\n' ""
}

parse_commandline()
{
	while test $# -gt 0
	do
		_key="$1"
		case "$_key" in
			-c|--controller-host)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_controller_host="$2"
				shift
				;;
			--controller-host=*)
				_arg_controller_host="${_key##--controller-host=}"
				;;
			-c*)
				_arg_controller_host="${_key##-c}"
				;;
			-P|--controller-port)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_controller_port="$2"
				shift
				;;
			--controller-port=*)
				_arg_controller_port="${_key##--controller-port=}"
				;;
			-P*)
				_arg_controller_port="${_key##-P}"
				;;
			-u|--username)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_username="$2"
				shift
				;;
			--username=*)
				_arg_username="${_key##--username=}"
				;;
			-u*)
				_arg_username="${_key##-u}"
				;;
			-p|--password)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_password="$2"
				shift
				;;
			--password=*)
				_arg_password="${_key##--password=}"
				;;
			-p*)
				_arg_password="${_key##-p}"
				;;
			--no-use-proxy|--use-proxy)
				_arg_use_proxy="on"
				_arg_use_proxy_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_use_proxy="off"
				;;
			--proxy-url)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_proxy_url="$2"
				shift
				;;
			--proxy-url=*)
				_arg_proxy_url="${_key##--proxy-url=}"
				;;
			--proxy-port)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_proxy_port="$2"
				shift
				;;
			--proxy-port=*)
				_arg_proxy_port="${_key##--proxy-port=}"
				;;
			-a|--application-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_application_name="$2"
				shift
				;;
			--application-name=*)
				_arg_application_name="${_key##--application-name=}"
				;;
			-a*)
				_arg_application_name="${_key##-a}"
				;;
			--no-include-database|--include-database)
				_arg_include_database="on"
				_arg_include_database_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_include_database="off"
				;;
			-d|--database-name)
				test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
				_arg_database_name="$2"
				shift
				;;
			--database-name=*)
				_arg_database_name="${_key##--database-name=}"
				;;
			-d*)
				_arg_database_name="${_key##-d}"
				;;
			-s|--no-include-sim|--include-sim)
				_arg_include_sim="on"
				_arg_include_sim_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_include_sim="off"
				;;
			-s*)
				_arg_include_sim="on"
				_next="${_key##-s}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-s" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-b|--no-configure-bt|--configure-bt)
				_arg_configure_bt="on"
				_arg_configure_bt_explicitly_set=true
				test "${1:0:5}" = "--no-" && _arg_configure_bt="off"
				;;
			-b*)
				_arg_configure_bt="on"
				_next="${_key##-b}"
				if test -n "$_next" -a "$_next" != "$_key"
				then
					{ begins_with_short_option "$_next" && shift && set -- "-b" "-${_next}" "$@"; } || die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
				fi
				;;
			-h|--help)
				print_help
				exit 0
				;;
			-h*)
				print_help
				exit 0
				;;
			*)
				_PRINT_HELP=yes die "FATAL ERROR: Got an unexpected argument '$1'" 1
				;;
		esac
		shift
	done
}

handle_passed_args_dependency()
{
	if [ $_arg_include_database = "on" ]; then
		test -z "${_arg_database_name// }" && _PRINT_HELP=yes die "FATAL ERROR: When value of --inlude-database is "${_arg_include_database}" - we require database name to be set (namely: --database-name)" 1
	fi

	if [ $_arg_use_proxy = "on" ]; then
		test -z "${_arg_proxy_url// }" -o -z "${_arg_proxy_port// }" && _PRINT_HELP=yes die "FATAL ERROR: When value of --use-proxy is "${_arg_use_proxy}" - we require proxy details to be set (namely: --proxy-url and --proxy-port)" 1
	fi
}

handle_mandatory_args()
{
	test -z "${_arg_controller_host// }" && _PRINT_HELP=no die "FATAL ERROR: Controller host must be set" 1
	test -z "${_arg_controller_port// }" && _PRINT_HELP=no die "FATAL ERROR: Controller port must be set" 1
	test -z "${_arg_username// }" && _PRINT_HELP=no die "FATAL ERROR: Username must be set" 1
	test -z "${_arg_password// }" && _PRINT_HELP=no die "FATAL ERROR: Password must be set" 1
	test -z "${_arg_application_name// }" && _PRINT_HELP=no die "FATAL ERROR: Application name must be set" 1
}

handle_expected_values_for_args()
{
	if ([ ! $_arg_include_database = "off" ] && [ ! $_arg_include_database = "on" ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --include-database value \"${_arg_include_database}\" not recognized" 1
	fi

	if ([ ! $_arg_use_proxy = "off" ] && [ ! $_arg_use_proxy = "on" ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --useproxy value \"${_arg_use_proxy}\" not recognized" 1
	fi

	if ([ ! $_arg_include_sim = "off" ] && [ ! $_arg_include_sim = "on" ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --include-sim value \"${_arg_include_sim}\" not recognized" 1
	fi

	if ([ ! $_arg_configure_bt = "off" ] && [ ! $_arg_configure_bt = "on" ] ); then 
		_PRINT_HELP=no die "FATAL ERROR: --configure-ts value \"${_arg_configure_bt}\" not recognized" 1
	fi
}

parse_commandline "$@"

# 2. If value not set with arguments replace with Environment Variable (if exists)
# env | grep CMA_

if ([ -z "${_arg_controller_host// }" ] && [ ! -z "${CMA_CONTROLLER_HOST// }" ]); then
	_arg_controller_host=${CMA_CONTROLLER_HOST}
fi
if ([ -z "${_arg_controller_port// }" ] && [ ! -z "${CMA_CONTROLLER_PORT// }" ]); then
	_arg_controller_port=${CMA_CONTROLLER_PORT}
fi

if ([ -z "${_arg_username// }" ] && [ ! -z "${CMA_USERNAME// }" ]); then
	_arg_username=${CMA_USERNAME}
fi
if ([ -z "${_arg_password// }" ] && [ ! -z "${CMA_PASSWORD// }" ]); then
	_arg_password=${CMA_PASSWORD}
fi


if ([ -z "${_arg_application_name// }" ] && [ ! -z "${CMA_APPLICATION_NAME// }" ]); then
	_arg_application_name=${CMA_APPLICATION_NAME}
fi

# TODO - Q: args with default values are necer going to be empty - how to override with env var? -> adding explicitly_set
if ([ $_arg_include_database_explicitly_set = false ] && [ ! -z "${CMA_INCLUDE_DATABASE// }" ]); then
	_arg_include_database=${CMA_INCLUDE_DATABASE}
fi
if ([ -z "${_arg_database_name// }" ] && [ ! -z "${CMA_DATABASE_NAME// }" ]); then
	_arg_database_name=${CMA_DATABASE_NAME}
fi

if ([ $_arg_include_sim_explicitly_set = false ] && [ ! -z "${CMA_INCLUDE_SIM// }" ]); then
	_arg_include_sim=${CMA_INCLUDE_SIM}
fi

if ([ $_arg_configure_bt_explicitly_set = false ] && [ ! -z "${CMA_CONFIGURE_BT// }" ]); then
	_arg_configure_bt=${CMA_CONFIGURE_BT}
fi

# 3. If value not set replace with configuration file values
conf_file="config.json"

if [[ -z "${_arg_controller_host// }" ]]; then
	_arg_controller_host=$(jq -r ' .controller_details[].host' <${conf_file})
fi

if [[ -z "${_arg_controller_port// }" ]]; then
	_arg_controller_port=$(jq -r ' .controller_details[].port' <${conf_file})
fi

if [[ -z "${_arg_username// }" ]]; then
	_arg_username=$(jq -r ' .controller_details[].username' <${conf_file})
fi

if [[ -z "${_arg_password// }" ]]; then
	_arg_password=$(jq -r ' .controller_details[].password' <${conf_file})
fi


if [[ -z "${_arg_proxy_url// }" ]]; then
	_arg_proxy_url=$(jq -r ' .controller_details[].proxy_url' <${conf_file})
fi

if [[ -z "${_arg_proxy_port// }" ]]; then
	_arg_proxy_port=$(jq -r ' .controller_details[].proxy_port' <${conf_file})
fi


# Hande dependency between arguments and mandatory values
handle_expected_values_for_args
handle_passed_args_dependency
handle_mandatory_args


# OTHER STUFF GENERATED BY Argbash

### END OF CODE GENERATED BY Argbash (sortof) ### ])
# [ <-- needed because of Argbash

 #  <-- needed because of Argbash

echo "Value of --controller-host: $_arg_controller_host"
echo "Value of --controller-port: $_arg_controller_port"
echo "Value of --username: $_arg_username" 
echo "Value of --password: $_arg_password" 

echo "Value of --proxy-url: $_arg_proxy_url"
echo "Value of --proxy-port: $_arg_proxy_port" 

echo "Value of --include-database: $_arg_include_database" 
echo "Value of --database-name: $_arg_database_name" 

# call config my app and pass arguments
# ./configMyApp.sh $_arg_controller_host $_arg_controller_port $_arg_username $_arg_password $_arg_proxy_url $_arg_proxy_port

 #  <-- needed because of Argbash
# ] <-- needed because of Argbash