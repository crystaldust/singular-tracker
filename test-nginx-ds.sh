#!/bin/bash
subnet_pattern=$1
IFS=$'\n'
podIPs=($(kubectl get pods -o wide | grep nginx | awk '{print $6}'))
unset IFS
echo "#!/bin/bash" > testservice.sh

for podIP in "${podIPs[@]}"
do
	echo "ping -c 5 ${podIP}" >> testservice.sh
done

nodePortIP=$(kubectl get svc | grep nginx | awk '{print $2}')
# Generate the parallel http request to nginx service

echo "g_httpcode=''" >> testservice.sh
echo "function test {" >> testservice.sh
echo "  g_httpcode=\$(curl $nodePortIP -w '%{http_code}' --output /dev/null -s)" >> testservice.sh
echo '  if [ "$g_httpcode" != "200" ]; then' >> testservice.sh
echo '    echo failed to curl nginx' >> testservice.sh
echo '    exit 1' >> testservice.sh
echo '  fi' >> testservice.sh
echo "}" >> testservice.sh



echo "for i in {1..1000}" >> testservice.sh
echo "do" >> testservice.sh
echo "  test &" >> testservice.sh
echo "done" >> testservice.sh
echo "wait" >> testservice.sh
echo "echo nginx service ready" >> testservice.sh


. ./color.sh

function testAndRun {
	host=$1
	red "test and running on $host"
	scp ./testservice.sh root@$host:/root/
	ssh root@$host 'chmod +x /root/testservice.sh'
	ssh root@$host '/root/testservice.sh'
}
testAndRun "192.168.${subnet_pattern}0"
testAndRun "192.168.${subnet_pattern}1"
testAndRun "192.168.${subnet_pattern}2"
