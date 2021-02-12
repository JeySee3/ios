pipeline {
	agent {
        label "mac-slave-aire"
    }

	stages {
		stage("Checkout") {
			steps {
				git branch: "${BRANCH}",
    				credentialsId: "githubjey",
    				url: 'https://github.com/JeySee3/ios'
			}		
    		}
	
		stage("Build") {
			steps {
				sh 'chmod +x ./build.sh'
				sh '/bin/bash build.sh'
		
	}
}
