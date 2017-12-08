# omar-merge-to-master
A script to perform git operations on multiple repos that are in our release.  

We can use any directory name for the merge process but in this example we will use a directory called **release**

### Best Practices
Practice good communication with the entire team over Slack when executing these steps. Be precise and thorough explaining what major steps are about to be taken, noting anything that goes wrong. It's not always easy, but it's always worth it.

### Steps
1. Stay calm... At times this can get a little hairy and overwhelming, especially when things break. You are not responsible for doing every little thing. You are able to call on anyone at any time for help. You are in charge here, delegation is your friend. 
Note: The next three steps should be done in a forum when the entire group is present. (i.e. sprint planning or daily SCRUM)
2. Ask all team members if any new projects need to be added or old projects need to be removed from the `env.sh` file.  And for Pete's sake, try and keep them in alphabetical order!
3. Ask all team members to ensure that repo version numbers have been changed appropriately and feature branches have been deleted.
4. Ask all team members to ensure that repo docs have been updated.
5. Delete ALL artifacts in s3://o2-delivery/dev/ and s3://o2-delivery/master/. You don't have to delete the folders.
6. Generate the release notes for the previous sprint. Put them in `ossimlabs/omar-docs/docs/index.md`.
7. Announce on Slack that code commits to dev branches should be halted until further notice.
8. In a terminal window do a `mkdir release` somewhere where you can copy the repos.
9. `cd release`
10. `git clone https://github.com/radiantbluetechnologies/omar-merge-to-master`
11. Make sure any changes made to the \*-dev.yml files in the config repo is added to the \*-rel.yml versions.
12. Run `./omar-merge-to-master/merge.sh`. You will notice a flurry of activity in Jenkins as all the master branches are being built. This will take quite a while and many of the pipelines trigger other pipelines resulting in "duplicate/redundant" builds. If you are short on time, keep an eye on them and abort anything that already has another build scheduled in the queue. Wait until the activity subsides before proceeding.
13. Log into Openshift (https://openshift-master.ossim.io:8443/console) and make sure there are no red pods. You just want to make sure everything comes up cleanly after the merge. Make sure all the new services from dev are present in rel.
14. Poke around and kick the tires on the new release to identify any configuration issues or other bugs that need to be resolved. It's not your responsibility to make sure everything works, use your best judgement.
15. Run cucumber tests. (And make sure they pass too)
16. Announce on Slack that commits to dev branches can be resumed.
17. Run the o2-delivery-master pipeline on Jenkins: https://jenkins.ossim.io/job/o2-delivery-master/
18. Create a local directory to copy the delivery items to from our s3 bucket: `mkdir ~/temp/master`
19. Make sure you have the aws [cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed
20. `cd ~/temp`
21. Run the following from the terminal: `aws s3 sync  s3://o2-delivery/master master`. This will take a long time to complete.
22. Burn the contents of master to a Blu-ray disk and take to the high side. Note: You do not need to burn the jars... they take a long time to scan and are not used.
23. Log into artifactory (see https://intranet.radiantblue.com/tools/confluence/display/OC2S/Artifactory)
24. Go to https://artifactory.ossim.io/artifactory/webapp/#/builds/ and delete builds.
