#!/bin/bash
# export des variables proxy dans le shell courant
# à lancer avec un source, sinon les variables ne seront pas exportées

function urlencode()
{
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            ' ') printf "%%20" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

function proxy_init ()
{
  read -p "login du compte : " login
  read -sp "Mot de passe de $login : " password
  echo
  proxy_pass=$(urlencode "$password")
  http_proxy="http://$login:$proxy_pass@proxy.univ-tln.fr:3128"
  https_proxy="$http_proxy"
  HTTP_PROXY="$http_proxy"
  HTTPS_PROXY="$http_proxy"
  no_proxy="127.0.0.1,localhost,*.univ-tln.fr"
  NO_PROXY="$no_proxy"
  export http_proxy https_proxy HTTP_PROXY HTTPS_PROXY no_proxy NO_PROXY
}

function proxy_test ()
{
  wget -q --spider https://fr.wikipedia.org/static/images/mobile/copyright/wikipedia.png
  local retour=$?
  if [ $retour -ne 0 ]; then
    echo "mot de passe non valide ou problème réseau"
    proxy_init
  else
    echo "OK, variables exportées dans le shell courant"
  fi
}

proxy_init
proxy_test
