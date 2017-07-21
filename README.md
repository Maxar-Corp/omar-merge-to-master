# omar-merge-to-master
A script to perform git operations on multiple repos that are in our release.  

We can use any directory name for the merge process but in this example we will use a directory called **release**

### Best Practices
Practice good communication with the entire team over Slack when executing these steps. Be precise and thorough explaining what major steps are about to be taken, noting anything that goes wrong. It's not always easy, but it's always worth it.

### Steps
Note: The first three steps should be done in a forum when the entire group is present. (i.e. sprint planning or daily SCRUM)
1. Ask all team members if any new projects need to be added or old projects need to be remove from the `env.sh` file.  And for Pete's sake, try and keep them in alphabetical order!
2. Ask all team members to ensure that repo version numbers have been changed appropriately.
3. Ask all team members to ensure that repo docs have been updated taking into consideration any changes to the Dockerfile and configuration.
4. Go through the previous sprint's tickets and transcribe any high level features and/or bugs to the release notes in `ossimlabs/omar-docs/docs/index.md`.
5. Announce on Slack that code commits to dev branches should be halted until further notice.
6. In a terminal window do a `mkdir release` somewhere where you can copy the repos.
7. `cd release`
8. `git clone https://github.com/radiantbluetechnologies/omar-merge-to-master`
9. Run `./omar-merge-to-master/merge.sh`. You will notice a flurry of activity in Jenkins as all the master branches are being built. This will take quite a while and many of the pipelines trigger other pipelines resulting in "duplicate/redundant" builds. If you are short on time, keep an eye on them and abort anything that already has another build scheduled in the queue. Wait until the activity subsides before proceeding.
10. Poke around and kick the tires on the new release to identify any configuration issues or other bugs that need to be resolved. It's not your responsibility to make sure everything works, use your best judgement.
11. Announce on Slack that commits to dev branches can be resumed.
12. Run the o2-delivery-master pipeline on Jenkins: https://jenkins.ossim.io/job/o2-delivery-master/
13. Create a local directory to copy the delivery items to from our s3 bucket: `mkdir ~/temp/master`
14. Make sure you have the aws [cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed
15. `cd ~/temp`
16. Run the following from the terminal: `aws s3 sync  s3://o2-delivery/master master`. This will take a long time to complete.
17. Burn the contents of master to a Blu-ray disk and take to the high side.
18. Delete build artifacts from artifactory.
