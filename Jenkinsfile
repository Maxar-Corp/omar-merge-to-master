node {
   env.WORKSPACE=pwd()
   try{
       stage("Checkout"){
           dir("ossim-ci") {
               git branch: "master", url: "https://github.com/radiantbluetechnologies/merge-to-master.git"
           }
       }
       stage("Merge")
       {
         sh """
            merge-to-master/merge.sh
         """
       }
    }
    catch(e){
        echo e.toString()
        currentBuild.result = "FAILED"
        notifyObj?.notifyFailed()
    }
     stage("Clean Workspace"){
        step([$class: 'WsCleanup'])
     }
}