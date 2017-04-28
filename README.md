# merge-to-master
A script to perform git operations on multiple repos that are in our release.  

We can use any directory name for the merge process but in this example we will use a directory called **release**

### Steps
1. Send e-mail to devs asking them not make any more code merges into dev until the merge is complete 
2. `mkdir release` somewhere where you can copy the repos
3. `cd release`
4. `git clone https://github.com/radiantbluetechnologies/merge-to-master`
5. Run `./merge-to-master/merge.sh`
6. Run the o2-delivery-master pipeline on Jenkins: http://jenkins.radiantbluecloud.com:8080/job/o2-delivery-master/
7. Create a local directory to copy the delivery items to from our s3 bucket: `mkdir ~/temp/master`
8. Make sure you have the aws [cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed
9. `cd to ~/temp/master`
10. Run the following from the terminal: `aws s3 sync  s3://o2-delivery/master master`
