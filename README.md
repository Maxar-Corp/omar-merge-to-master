# omar-merge-to-master

THIS DOCUMENT IS SUPERCEDED BY [THIS CONFLUENCE PAGE](https://radiantsolutions.atlassian.net/wiki/spaces/OC2S/pages/70647849/OMAR+Merge-to-Master+and+Release+Process).

A collection of scripts and documentation (this) to perform an end-of-sprint merge of the git dev branches to master. Here is also described the process for deploying the results of the merge to openshift 

:collision: _Modifications here in support of the new quad deployment model (dev, stage, blue, green) are in italics. Obsolete instructions are ~~struck~~._

### Best Practices
Practice good communication with the entire team over Slack when executing these steps. Be precise and thorough explaining what major steps are about to be taken, noting anything that goes wrong. It's not always easy, but it's always worth it.

### Steps
1. Stay calm... At times this can get a little hairy and overwhelming, especially when things break. You are not responsible for doing every little thing. You are able to call on anyone at any time for help. You are in charge here, delegation is your friend.

2. Clone a fresh copy of the `omar-merge-to-master` repo.
```
    mkdir release
    cd release
    git clone https://github.com/radiantbluetechnologies/omar-merge-to-master
```

3. Ask all team members if any new projects need to be added or old projects need to be removed from the `omar-merge-to-master/env.sh` file.  And for Pete's sake, try and keep them in alphabetical order! _Note: This step should be done in a forum when the entire group is present. (i.e. sprint planning or daily SCRUM)_

:collision: _Propose consolidating this repository into ossim-ci since some files in that repo will also need the repo list available in env.sh. (This means also moving ossim-ci to our private RBT github, which it probably should be anyway). Also propose a more descriptive name for the file containing the important list of repos._

4. Ask all team members to ensure that repo docs have been updated. _Note: This step should be done in a forum when the entire group is present. (i.e. sprint planning or daily SCRUM)_

5. Announce on Slack...
```
    @channel DEV is FROZEN until further notice! Until such time, commits to dev branches need to be approved by the "Merge Master" or have two-person integrity.
```

6. Make sure all the Jenkins dev builds and tests are green. If they are not, work with the team to make whatever changes are necessary. Do not proceed until all builds and tests are green.

7. Delete ALL artifacts in s3://o2-delivery/dev and s3://o2-delivery/master.
```
    ./deleteS3Artifacts.sh dev
    ./deleteS3Artifacts.sh master
```

8. Generate the release notes for the previous sprint. Put them in `ossimlabs/omar-docs/docs/index.md` and push them to dev.
   * Copy the previous sprint's release notes page in confluence to the current sprint.
   * Edit the page and modify the table logic to look at the current sprint's tickets.

9. ~~Make sure any changes made to the `\*-dev.yml` files in the `config repo` are added to the `\*-rel.yml` versions. In addition, update the `omar-ui.yml` and `tlv.yml` in config-repo for the new umbrella version (i.e. Fort Myers 2.2.0).~~

:collision: _The config-repo would share the same branching and tagging scheme as the other repos. Only application.yml needs to be modified with version name and number. **This should already be reflected in the config-repo dev branch from the previous merge** Just make sure that the dev branch of [config-repo/application.yml](https://github.com/radiantbluetechnologies/config-repo/application.yml) does indeed reflect the correct version info before the merge._

10. ~~Log-in to [Openshift > omar-dev > Resources > Config Maps > web-proxy-conf](https://openshift-master.ossim.io:8443/console/project/omar-dev/browse/config-maps/web-proxy-conf) and copy the configs into the same place in the omar-rel project.~~

:collision: _The web-proxy-conf and other configmaps are stored as files at the [o2-paas git repo](https://github.com/radiantbluetechnologies/o2-paas/openshift/deployment). They are read by the deployment script in that repo (launched by the `deploy-openshift-target` Jenkins pipeline. The existing openshift configmaps are deleted before a new deployment is done. So no copying of configmaps is performed._ 

11. Merge dev into master.
```
    ./merge.sh
```

_Note: You will notice a flurry of activity in Jenkins as all the master branches are being built. This will take quite a while and many of the pipelines trigger other pipelines resulting in "duplicate/redundant" builds. If you are short on time, keep an eye on them and abort anything that already has another build scheduled in the queue. Wait until the activity subsides before proceeding._

12. Log-in to [Openshift > omar-stage](https://openshift-master.ossim.io:8443/console/project/omar-stage/overview) and make sure there are no red pods. You just want to make sure everything comes up cleanly after the merge.

13. Make sure the appropriate services are present in omar-stage, adding and/or deleting them as necessary.

14. Poke around and kick the tires on https://omar-stage.ossim.io to identify any configuration issues or other bugs that need to be resolved. It's not your responsibility to make sure everything works, just use your best judgement.

:collision: _NOTE: Need to verify that all tests are running on omar-stage, not omar-rel. The omar-rel project should go away.

15. Run the [omar-ingest-tests-release](https://jenkins.ossim.io/job/omar-ingest-tests-release/) pipeline. Make any necessary changes to ensure it passes successfully.

16. Run the [omar-backend-tests-release](https://jenkins.ossim.io/job/omar-backend-tests-release/) pipeline. Make any necessary changes to ensure it passes successfully.

17. Run the [omar-frontend-tests-release](https://jenkins.ossim.io/job/omar-frontend-tests-release/) pipeline. Make any necessary changes to ensure it passes successfully.

18. Run the [jmeter-imagespace-test-release](https://jenkins.ossim.io/job/jmeter-imagespace-test-release/) pipeline. Make any necessary changes to ensure it passes successfully.

19. Run the [jmeter-mapproxy-test-release](https://jenkins.ossim.io/job/jmeter-mapproxy-test-release/) pipeline. Make any necessary changes to ensure it passes successfully.

20. Run the [jmeter-wfs-test-release](https://jenkins.ossim.io/job/jmeter-wfs-test-release/) pipeline. Make any necessary changes to ensure it passes successfully.

21. Run the [jmeter-wms-test-release](https://jenkins.ossim.io/job/jmeter-wms-test-release/) pipeline. Make any necessary changes to ensure it passes successfully.

22. Run the [o2-delivery-master](https://jenkins.ossim.io/job/o2-delivery-master/) pipeline.

23. Update `omar-merge-to-master/env.sh` file.
   * Update the TAG_RELEASE_NAME with new release and version.
   * Update the TAG_DESCRIPTION with new release and version.

24. ~~Tag the release~~
```
    ./tagRelease.sh
``` 

:collision: _NOTE: A Jenkins pipeline exists (`tag-release-version`) that provides parameters for TAG info and launches the tagging scripts in [o2-paas/openshift/deployment](https://github.com/radiantbluetechnologies/o2-paas/openshift/deployment)
64

:collision: _Checkout the config-repo "dev" branch and edit [config-repo/application.yml](https://github.com/radiantbluetechnologies/config-repo/application.yml) so that the version number (and possibly release name) reflect the **next** version. That is, subsequent commits to dev are for that next version._

:collision: _I plan on adding this to the jenkins pipeline so that application.yml is never edited directly, but set by the pipeline._

25. Log-in to artifactory. Ref: https://intranet.radiantblue.com/tools/confluence/display/OC2S/Artifactory

26. Go to https://artifactory.ossim.io/artifactory/webapp/#/builds/ and delete builds.

27. Announce on Slack...
```
    @channel DEV has thawed! Commit until your heart's content.
```

28. Download delivery artifacts...
```
    mkdir ~/temp
    cd ~/temp
    aws s3 sync s3://o2-delivery/master master
```

_Note: Make sure you have the aws [cli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed and the credential pair keys set up to access S3 buckets. Contact admin for the accessKey ID and Secret Key and do "aws s3 configure" to configure the keys (the region should be "us-east-1"). Test connection with "aws s3 ls" where you should be able to see the list of S3 buckets._

29. Burn the contents of master to a Blu-ray disk and have them transferred to CWAN.

:collision: _The high-side omar-stage should reflect the low-side omar-stage. Consider canary testing of high-side omar-stage before commiting to tag-release on the low-side. If there are no changes, 

30. Push any merge-to-master changes to dev. 
