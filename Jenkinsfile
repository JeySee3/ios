pipeline {
	agent any


	stages {

			stage('Checkout') {
				git branch: ${BRANCH},
    				credentialsId: 'githubjey',
    				url: 'https://github.com/JeySee3/ios'
    		  
		}
	}
}
