#! /bin/bash
#ACB

print_version_all(){
  
  services=("tv" "fops" "hops" "tripops" "pg" "fb" "frs" "hinv" "ne" "nei" "tap")
  servicesProduction=("tv10" "fops01" "hops-app-01" "tripops-app-02" "payment01" "fb04" "frs14" "hinv01" "ne04" "nei04" "tap01")
  
  if [ "$2" == "production" ]; then
    i=0
    while [ $i -lt ${#services[*]} ]; do
      command=`ssh ${servicesProduction[$i]} cat /var/traveloka/running/${services[$i]}/WEB-INF/classes/build.properties`
      if [ $? -ne 0 ]; then
        echo "could not execute $command"
      else
        echo "${services[$i]^^}:$command"
        echo
      fi
      i=$(( $i+1));
    done
    exit
  fi
  
  for service in "${services[@]}"; do
    command=`ssh $2 cat /var/traveloka/running/$service/WEB-INF/classes/build.properties`
    if [ $? -ne 0 ]; then
      echo "could not execute $command"
    else
      echo "${service^^}:$command"
      echo 
    fi
  done
}

print_version(){
  if [ "$1" == "all" ]; then
    print_version_all $1 $2
    exit
  elif [ "$1" == "fetcher" ]; then
    command=`ssh $2 cat /var/traveloka/fetcher/build.properties`
  else
    command=`ssh $2 cat /var/traveloka/running/$1/WEB-INF/classes/build.properties`
  fi

  if [ $? -ne 0 ]; then
    echo "could not find such directory ($1 does not exist)"
    exit
  else
    echo "${1^^}: $command"
  fi
}

if [ $# -ne 2 ];	
then
  echo "usage: print_version (service/all) (stagingXX/productionMachine)"
else
  print_version $1 $2
fi
