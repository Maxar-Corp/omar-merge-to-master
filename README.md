# omar-merge-to-master
A script to perform git operations on multiple repos that are in our release.  

We can use any directory name for the merge process but in this example we will use a directory called **release**

### Steps
1. In a terminal window do a `mkdir release` somewhere where you can copy the repos
2. `cd release`
3. `git clone https://github.com/radiantbluetechnologies/omar-merge-to-master`
4. Run `./omar-merge-to-master/merge.sh`
5. Run the o2-delivery-master pipeline on Jenkins: http://jenkins.radiantbluecloud.com:8080/job/o2-delivery-master/
6. Create a local directory to copy the delivery items to from our s3 bucket: `mkdir ~/temp/master`
7. Make sure you have the aws [cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed
8. `cd to ~/temp/master`
9. Run the following from the terminal: `aws s3 sync  s3://o2-delivery/master master`
10. Burn the contents of master to a Blu-ray disk and take to the high side
11. Delete build artifacts from artifactory
