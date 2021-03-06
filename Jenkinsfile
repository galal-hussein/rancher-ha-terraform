#!groovy


// Get the AWS prefix if it exists
def tf_name() {
  try { if ('' != TF_NAME) { return TF_NAME } }
  catch (MissingPropertyException e) { return false }
}

// SLACK_CHANNEL resolution is first via Jenkins Build Parameter SLACK_CHANNEL fed in from console,
// then from $DOCKER_TRIGGER_TAG which is sourced from the Docker Hub Jenkins plugin webhook.
def slack_channel() {
  try { if ('' != SLACK_CHANNEL) { return SLACK_CHANNEL } }
  catch (MissingPropertyException e) { return '#ci_cd' }
}


// simplify the generation of Slack notifications for start and finish of Job
def jenkinsSlack(type) {
  channel = slack_channel()
  tf_name = tf_name()
  def jobInfo = "\n » ${tf_name} :: ${JOB_NAME} #${env.BUILD_NUMBER} (<${env.BUILD_URL}|job>) (<${env.BUILD_URL}/console|console>)"

  if (type == 'start'){
    slackSend channel: channel, color: 'blue', message: "build started${jobInfo}"
  }
  if (type == 'finish'){
    def buildColor = currentBuild.result == null? "good": "warning"
    def buildStatus = currentBuild.result == null? "SUCCESS": currentBuild.result
    def msg = "build finished - ${buildStatus}${jobInfo}"
    slackSend channel: channel, color: buildColor, message: "${msg}"
  }
}


def lastBuildResult() {
 def previous_build = currentBuild.getPreviousBuild()
  if ( null != previous_build ) { return previous_build.result } else { return 'UKNOWN' }
}

try {

  node {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 2, 'defaultBg':1]) {

      jenkinsSlack('start')
      checkout scm

      stage('build') {
        sh "./scripts/build.sh"
      }
      stage ('terraform run') {
        sh "docker run --rm  " +
          "--env-file .env " +
          "rancherlabs/terraform_ha:latest /bin/bash -c \'cd \"\$(pwd)\" && ./scripts/bootstrap.sh\'"
      }
      if ( "true" == "${TERRAFORM_APPLY}" ) {
        stage ('Wait until the setup is ready') {
          sh '''
              until $(curl --output /dev/null --silent --head --fail https://${TF_FQDN}); do
              printf '.'
              sleep 30
              done
              echo "Rancher HA URL: https://${TF_FQDN}"
          '''
        }
      }
    } // wrap
  } // node
} catch(err) { currentBuild.result = 'FAILURE' }


jenkinsSlack('finish')
