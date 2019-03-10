// Rename the init.groovy.d directory to init.groovy.d.old
// - When restarting the container or running a new container version,
//   the newest init scripts will only be copied over if init.groovy.d
//   does not already exist.

// Get Jenkins Home
JENKINS_HOME = System.env.JENKINS_HOME

// Shell command to run
def rm_command = "rm -rf ${JENKINS_HOME}/init.groovy.d.old"
def mv_command = "mv ${JENKINS_HOME}/init.groovy.d ${JENKINS_HOME}/init.groovy.d.old"

// Run the shell commands
def rm_proc = rm_command.execute()
rm_proc.waitFor()

def mv_proc = mv_command.execute()
mv_proc.waitFor()
