#!/bin/sh

COMMAND=$1
GUESTNAME="asterisk"


help() {
    echo "Syntax:"
    echo "$0 list"
    echo "$0 set"
    echo "$0 clear"
    exit 1
}

# find the guest
# try to lookup the container with Docker.
RETRIES=3
while [ "$RETRIES" -gt 0 ]; do
    DOCKERPID=$(docker inspect --format='{{ .State.Pid }}' "$GUESTNAME")
    [ "$DOCKERPID" != 0 ] && break
    sleep 1
    RETRIES=$((RETRIES - 1))
done

[ "$DOCKERPID" = 0 ] && {
    die 1 "Docker inspect returned invalid PID 0"
}

[ "$DOCKERPID" = "<no value>" ] && {
    die 1 "Container $GUESTNAME not found, and unknown to Docker."
}

NSPID=$DOCKERPID
LINKFILE="/var/run/netns/$NSPID"

# make the link
mkdir -p /var/run/netns
/bin/rm -f "$LINKFILE"
ln -s "/proc/$NSPID/ns/net" "$LINKFILE"

case "$COMMAND" in
    "list")
	ip netns exec $NSPID iptables -L -n -v
	;;
    "set")
	ip netns exec $NSPID iptables -A INPUT -i lo -j ACCEPT
	ip netns exec $NSPID iptables -A INPUT -m state --state RELATED -j ACCEPT
	ip netns exec $NSPID iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
	ip netns exec $NSPID iptables -A INPUT -m state --state NEW -s 62.216.220.1 -p udp -j ACCEPT
	ip netns exec $NSPID iptables -A INPUT -m state --state NEW -s 192.168.178.3 -p udp -j ACCEPT
	ip netns exec $NSPID iptables -A INPUT -j DROP
	;;
    "clear")
	ip netns exec $NSPID iptables -F INPUT
	;;
    *)
	help
	;;
esac

/bin/rm -f "$LINKFILE"
