timeout 60 bash -c 'while [[ "$(curl -X PUT -o /dev/null -w ''%{http_code}'' localhost:1080/mockserver/status)" != "200" ]]; do sleep 2; done' || false
