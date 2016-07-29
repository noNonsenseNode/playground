#Requires -RunAsAdministrator

$SERVICE="playground"
$DNS="playground.dev"
$COMPOSE_FILE="./docker-compose.yml"

Function setupMachine () {
    If (Get-Command docker-machine -errorAction SilentlyContinue) {
        If ((docker-machine ls | select-string -pattern "$SERVICE") -eq $null){
            docker-machine create -d virtualbox --virtualbox-cpu-count "2" --virtualbox-memory "3072"  --virtualbox-disk-size "20000" $SERVICE
        }
    } Else {
        echo "please install docker-machine from https://www.docker.com/toolbox"
        exit
    }
}

Function init () {
    $(docker-machine env --shell powershell $SERVICE) | Invoke-Expression
}

Function destroyMachine () {
    init
    docker-machine rm $SERVICE
}

Function setupDNS () {
    $ip=$(docker-machine ip $SERVICE);
    If($ip){
        $HostLocation = "$env:windir\System32\drivers\etc\hosts"
        $NewHostEntry = "`t$ip`t$dns"
        If((gc $HostLocation) -contains $NewHostEntry){
            echo "$ip $dns already in host file"
        } Else {
            echo "please add $ip $dns host file $HostLocation"
            Add-Content -Path $HostLocation -Value $NewHostEntry
        }
    }
}

Function removeDNS () {
    Get-Content $HostLocation | Where-Object {$_ -notmatch 'playground'} | Set-Content $HostLocation
}

Function compose () {
    docker-compose -f $COMPOSE_FILE build
    docker-compose -f $COMPOSE_FILE up -d
    docker-compose -f $COMPOSE_FILE ps
    docker-compose -f $COMPOSE_FILE rm -f
}

If($Args[0] -eq "setup") {
    setupMachine;
    setupDNS;
    init;
    compose;
    Start-Process "chrome.exe" "http://$DNS/"
    Start-Process "chrome.exe" "http://$DNS`:8080/debug?port=4001"
} ElseIf($Args[0] -eq "destroy") {
    removeDNS;
    init;
    docker-compose -f $COMPOSE_FILE kill -s SIGINT
    destroyMachine;
} ElseIf($Args[0] -eq "shell") {
    init;
    docker exec -it $(docker-compose -f $COMPOSE_FILE ps -q playground) /bin/bash -c "cd /srv;/bin/bash"
} ElseIf($Args[0] -eq "restart") {
    init;
    docker exec -it $(docker-compose -f $COMPOSE_FILE ps -q playground) /bin/bash -c "cd /srv;forever restartall;"
} Else {
    echo "invalid run command"
}
