# merge-to-master
A script to perform git operations on multiple repos that are in our release.  

We can use any directory name for the merge process but in this example we will use a directory called **release**


```
mkdir release
cd release
git clone https://github.com/radiantbluetechnologies/merge-to-master
./merge-to-master/merge.sh