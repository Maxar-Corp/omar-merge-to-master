node {
   env.WORKSPACE=pwd()
   try{
       stage("Checkout"){
           dir("merge-to-master") {
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