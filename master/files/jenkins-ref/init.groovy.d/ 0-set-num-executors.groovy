import jenkins.model.*

EXECUTORS = System.env.EXECUTORS.toInteger()
Jenkins.instance.setNumExecutors(EXECUTORS)

