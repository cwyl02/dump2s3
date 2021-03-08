### This hasn't been test on a K8s cluster yet and probably needs further fixes to work

The majority of the time is spent:
1. understanding the problem and related concepts
2. making k8s cluster local pv works in Docker Desktop(wsl2 integration)
    - which didn't end up with meaningful results
3. testing on mydumper
4. googling..

### The challenges

1. mydumper dumps to local files only
2. we have a small pv that can't rely on to hold all mydumper output files
3. limited experience with PV, PVC and Helm


### The goal of this program

1. Make the pv somehow irrelavant in the whole backup progress, as it eventually uploads to remote object store 

### Approach

1. generate an output dir name
2. execute mydumper with args(including the output dir name)
3. compress the whole output directory into a package with tar
4. take the output above and pipe into `mc pipe` to upload to remote object storage

### Build

```
docker build . -t YOUR_REPO/dump2obj:0.0.1
```


### Questions remain unresolved

1. what exactly will happen when a mydumper execution produces output larger than the size of the pv it's assigned?
    - haven't found an answer from google
    - not yet able to test it to see it in action. haven't make local storage based peresistent volumes work on my test k8s cluster..  :(



<!-- ### Approach 2

This is the high level idea when this program runs

1. generate an output dir name 
2. watch filesystem event dir.
    - Upon new file, pipe file to object storage provider via minio client(mc)
    - delete file 
3. execute mydumper with args(including the output dir name)
4.   -->

<!-- ###
mydumper will write files in parallel to folder X.

Thus, we need our program to 

1. watch this folder
2. upon a new file pops up, stream the file to memory
3. using mc pipe to S3 -->

### TODOs:
1. Use tools like helm to template the yaml manifests..
2. see whether this actually works..
3. more robust config file managements


### References

https://github.com/pingcap/tidb-operator
https://github.com/pingcap/tidb-cloud-backup
https://github.com/pingcap/dumpling
https://github.com/pingcap/br
https://github.com/docker/for-win/issues/5325#issuecomment-567594291

mkdir /mnt/wsl/hostmount
<!-- echo hello > somedir hello                   -->
sudo mount --bind /home/ubuntu/k8s-pvs /mnt/wsl/hostmount