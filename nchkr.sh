#!/bin/bash
#Script que verifica se um determinado processo esta rodando
#by Nickolas Frederik
#19/04/2013

sec="null"
quiet="false"
run_scrip="false"

fn_ajuda(){
	echo "Opcoes validas:"
	echo "-s servico"
	echo "-r scriptToRun"
	echo "-t tempo para nova verificacao em segundos"
	echo "-q quiet"
}

while getopts ":s:r:q:t:" opt; do
  case $opt in
    s)
      n_service=$OPTARG
      ;;
    r)
      run_scrip=$OPTARG
	;;
    t)
	  sec=$OPTARG
	;;
    q)
	  quiet=$OPTARG
	;;
    \?)
      fn_ajuda
      exit 0
      ;;
    :)
      fn_ajuda
      exit 0
      ;;
  esac
done
if [ "$n_service" = "" ]
then
	fn_ajuda
	exit 0
fi
fn_check(){
	if [ "$quiet" = "false" ]
	then
		echo "$ts : Verificando $n_service"
	fi
	n_process=$(ps -ef | grep "$n_service" | grep -v "grep" | grep -v "sh" | awk '{ print $8}' | wc -l)
	s_process=$(ps -ef | grep "$n_service" | grep -v "grep" | grep -v "sh")
	if [ $n_process = 0 ]
	then
		if [ "$quiet" = "false" ]
		then
			echo "Processo Inexistente"
		fi
		if [ ! "$run_scrip" = "false" ]
		then
			eval "$run_scrip"
		fi
		exit 0
	fi
	if [ $n_process = 1 ]
	then
		if [ "$quiet" = "false" ]
		then
			echo "Processo rodando"
		fi
	fi
	if [ $n_process -gt 1 ]
	then
		if [ "$quiet" = "false" ]
		then
			echo -e "\e[00;31mProcessos rodando: $n_process \e[00m"
		fi
	fi
	ts=`date +%T`
	if [ "$quiet" = "false" ]
	then
		echo "$ts : Fim da verificacao"
		echo "Proxima verificacao em $sec segundos"
		echo -e "\n"
	fi
}
while [ 1 ]; do 
  ts=`date +%T`
  fn_check
	if [ $sec = "null" ]
	then
		exit 0;
	else
 	 sleep $sec
	fi
done
