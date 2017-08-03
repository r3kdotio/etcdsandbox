
# Startup container with hostname etcdsandbox1
docker run --name etcdsandbox1 -h etcdsandbox1  -it r3kdotio/etcdsandbox  bash

## Start etcd in running container
> etcd
2017-08-03 18:58:11.115303 I | etcdmain: etcd Version: 3.1.0
2017-08-03 18:58:11.115490 I | etcdmain: Git SHA: Not provided (use ./build instead of go build)
2017-08-03 18:58:11.115533 I | etcdmain: Go Version: go1.7.4
2017-08-03 18:58:11.115553 I | etcdmain: Go OS/Arch: linux/amd64
2017-08-03 18:58:11.115582 I | etcdmain: setting maximum number of CPUs to 4, total number of available CPUs is 4
2017-08-03 18:58:11.115628 W | etcdmain: no data-dir provided, using default data-dir ./default.etcd
2017-08-03 18:58:11.115797 I | etcdmain: advertising using detected default host "172.17.0.2"
2017-08-03 18:58:11.116713 I | embed: listening for peers on http://localhost:2380
2017-08-03 18:58:11.117019 I | embed: listening for client requests on localhost:2379
2017-08-03 18:58:11.171924 I | etcdserver: name = default
2017-08-03 18:58:11.171972 I | etcdserver: data dir = default.etcd
2017-08-03 18:58:11.171992 I | etcdserver: member dir = default.etcd/member
2017-08-03 18:58:11.172012 I | etcdserver: heartbeat = 100ms
2017-08-03 18:58:11.172028 I | etcdserver: election = 1000ms
2017-08-03 18:58:11.172051 I | etcdserver: snapshot count = 10000
2017-08-03 18:58:11.172077 I | etcdserver: advertise client URLs = http://localhost:2379
2017-08-03 18:58:11.172094 I | etcdserver: initial advertise peer URLs = http://172.17.0.2:2380
2017-08-03 18:58:11.172128 I | etcdserver: initial cluster = default=http://172.17.0.2:2380
2017-08-03 18:58:11.361635 I | etcdserver: starting member 69015be41c714f32 in cluster 10e5e39849dab251
2017-08-03 18:58:11.361738 I | raft: 69015be41c714f32 became follower at term 0
2017-08-03 18:58:11.361794 I | raft: newRaft 69015be41c714f32 [peers: [], term: 0, commit: 0, applied: 0, lastindex: 0, lastterm: 0]
2017-08-03 18:58:11.361824 I | raft: 69015be41c714f32 became follower at term 1
2017-08-03 18:58:11.532231 I | etcdserver: starting server... [version: 3.1.0, cluster version: to_be_decided]
2017-08-03 18:58:11.533830 I | etcdserver/membership: added member 69015be41c714f32 [http://172.17.0.2:2380] to cluster 10e5e39849dab251
2017-08-03 18:58:12.262639 I | raft: 69015be41c714f32 is starting a new election at term 1
2017-08-03 18:58:12.262736 I | raft: 69015be41c714f32 became candidate at term 2
2017-08-03 18:58:12.262822 I | raft: 69015be41c714f32 received MsgVoteResp from 69015be41c714f32 at term 2
2017-08-03 18:58:12.262888 I | raft: 69015be41c714f32 became leader at term 2
2017-08-03 18:58:12.262939 I | raft: raft.node: 69015be41c714f32 elected leader 69015be41c714f32 at term 2
2017-08-03 18:58:12.263542 I | etcdserver: setting up the initial cluster version to 3.1
2017-08-03 18:58:12.282826 N | etcdserver/membership: set the initial cluster version to 3.1
2017-08-03 18:58:12.282967 I | etcdserver: published {Name:default ClientURLs:[http://localhost:2379]} to cluster 10e5e39849dab251
2017-08-03 18:58:12.283079 I | etcdserver/api: enabled capabilities for version 3.1
2017-08-03 18:58:12.283146 I | embed: ready to serve client requests
2017-08-03 18:58:12.284042 N | embed: serving insecure client requests on 127.0.0.1:2379, this is strongly discouraged!



# Check etcdsandbox1 in another term

> docker ps
CONTAINER ID        IMAGE                     COMMAND                  CREATED             STATUS              PORTS                                                 NAMES
etcdsandbox1        etcdsandbox               "bash"                   3 minutes ago       Up 3 minutes                                                              etcdsandbox

# Attach to running container in another term

> docker exec -ti etcdsandbox1 bash

## Check what etcd contains

> root@etcdsandbox1:/# etcdctl ls
<nothing>

## look for a key that does not exist

root@etcdsandbox1:/# etcdctl get /doesnotexist
Error:  100: Key not found (/doesnotexist) [12]

## set a key 

root@etcdsandbox1:/# etcdctl set /mykey1 MyValue1
MyValue1

## set a key 

root@etcdsandbox1:/# etcdctl get /mykey1
MyValue1

## find the keys

root@etcdsandbox1:/# etcdctl ls
/message

## make a directory

root@etcdsandbox1:/# etcdctl mkdir /mydir
<nothing>

## find the keys

root@etcdsandbox1:/# etcdctl ls
/mydir
/mykey1

## set a key in a directory

root@etcdsandbox1:/# etcdctl set /mydir/mykey2 MyValue2
MyValue2

## find the keys

root@etcdsandbox1:/# etcdctl ls
/mydir
/mykey1

## find the keys recursive

root@etcdsandbox1:/# etcdctl ls -r
/mydir
/mydir/mykey2
/mykey1

# get the key in a directory

root@etcdsandbox1:/# etcdctl get /mydir/mykey2
MyValue2

## set a key in a directory with a time to live of 30 seconds

root@etcdsandbox1:/# etcdctl set /mydir/mykey3 MyValue3  --ttl 30
MyValue3

## find the keys recursive
root@etcdsandbox1:/# etcdctl ls -r
/mydir
/mydir/mykey2
/mydir/mykey3
/mykey1

## watch for changes before the 30 seconds is up

root@etcdsandbox1:/# etcdctl watch / -r
[expire] /mydir/mykey3

## delete a key 

root@etcdsandbox1:/# etcdctl rm /mykey1
PrevNode.Value: MyValue1

## delete a directory

root@etcdsandbox1:/# etcdctl rm -r /mydir

## find all keys

root@etcdsandbox1:/# etcdctl ls
root@etcdsandbox1:/# 

## debug what a set does over http (curl)

root@etcdsandbox1:/# etcdctl --debug set /mydir/mykey3 MyValue3  --ttl 30
start to sync cluster using endpoints(http://127.0.0.1:4001,http://127.0.0.1:2379)
cURL Command: curl -X GET http://127.0.0.1:4001/v2/members
cURL Command: curl -X GET http://127.0.0.1:2379/v2/members
got endpoints(http://localhost:2379) after sync
Cluster-Endpoints: http://localhost:2379
cURL Command: curl -X PUT http://localhost:2379/v2/keys/mydir/mykey3 -d "ttl=30&value=MyValue3"
MyValue3

## debug what a set does over http (curl)

root@etcdsandbox1:/# etcdctl --debug get /mydir/mykey3 MyValue3
start to sync cluster using endpoints(http://127.0.0.1:4001,http://127.0.0.1:2379)
cURL Command: curl -X GET http://127.0.0.1:4001/v2/members
cURL Command: curl -X GET http://127.0.0.1:2379/v2/members
got endpoints(http://localhost:2379) after sync
Cluster-Endpoints: http://localhost:2379
cURL Command: curl -X GET http://localhost:2379/v2/keys/mydir/mykey3?quorum=false&recursive=false&sorted=false
Error:  100: Key not found (/mydir/mykey3) [21]

# Setting up key authentication
https://coreos.com/os/docs/latest/generate-self-signed-certificates.html


