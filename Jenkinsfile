pipeline {
	agent {
        label "master"
    }

	stages {
		stage("Checkout") {
			steps {
				git branch: "${BRANCH}",
    				credentialsId: "githubjey",
    				url: 'https://github.com/JeySee3/ios'
			}		
    	}
	}
}
