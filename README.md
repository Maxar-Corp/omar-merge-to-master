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
5. Delete ALL artifacts in s3://o2-delivery/dev/jars and s3://o2-delivery/master/jars. You don't have to delete the folders.
 - run in omar-merge-to-master: `./deleteS3Artifacts.sh master`
6. Generate the release notes for the previous sprint by copying the generated change log from the sprint's Change log Confluence page and putting them in `ossimlabs/omar-docs/docs/index.md`. Run the format_release.s script (to format index.md) and push them to dev.
7. Make sure all the dev builds and tests are green
8. Announce on Slack that code commits to dev branches should be halted until further notice.
9. In a terminal window do a `mkdir release` somewhere where you can copy the repos.
10. `cd release`
11. `git clone https://github.com/radiantbluetechnologies/omar-merge-to-master`
12. Make sure any changes made to the `\*-dev.yml` files in the config repo is added to the `\*-rel.yml` versions. In addition, update the omar-ui yaml in config-repo for the new umbrella version (i.e. Fort Myers 2.2.0). Push any changes to dev.
13. Run `./omar-merge-to-master/merge.sh`. You will notice a flurry of activity in Jenkins as all the master branches are being built. This will take quite a while and many of the pipelines trigger other pipelines resulting in "duplicate/redundant" builds. If you are short on time, keep an eye on them and abort anything that already has another build scheduled in the queue. Wait until the activity subsides before proceeding. Check the proxy configs defined in the config-maps on the omar-dev project are ported to the omar-rel project.  We need to modify the reverse-proxy in omar-web-proxy to make sure its ported in git.
14. Log into Openshift (https://openshift-master.ossim.io:8443/console) and make sure there are no red pods. You just want to make sure everything comes up cleanly after the merge. Make sure all the new services from dev are present in rel.
15. Poke around and kick the tires on the new release to identify any configuration issues or other bugs that need to be resolved. It's not your responsibility to make sure everything works, use your best judgement.
16. Run cucumber tests (ingest, backend, and frontend). (And make sure they pass too)
17. Run the JMeter tests. (And make sure those also pass, see a pattern?)
18. Announce on Slack that commits to dev branches can be resumed.
19. Run the o2-delivery-master pipeline on Jenkins: https://jenkins.ossim.io/job/o2-delivery-master/
20. Update env.sh with new release name and version. Update the TAG_DESCRIPTION with new release and version. Run tagRelease.sh
21. Create a local directory to copy the delivery items to from our s3 bucket: `mkdir ~/temp/master`
22. Make sure you have the aws [cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed and the credential pair keys set up to access S3 buckets. Contact admin for the accessKey ID and Secret Key and do "aws s3 configure" to configure the keys (the region should be "us-east-1"). Test connection with "aws s3 ls" where you should be able to see the list of S3 buckets.
23. `cd ~/temp`
24. Run the following from the terminal: `aws s3 sync s3://o2-delivery/master master`. This will take a long time to complete.
25. Burn the contents of master to a Blu-ray disk and take to the high side. Note: You do not need to burn the jars... they take a long time to scan and are not used.
26. Log into artifactory (see https://intranet.radiantblue.com/tools/confluence/display/OC2S/Artifactory)
27. Go to https://artifactory.ossim.io/artifactory/webapp/#/builds/ and delete builds.
28. Push any merge-to-master changes to dev.
