#!/bin/sh


## Build script 
## By default the script will build ad hoc build for Test 1..5 servers.
## To build for other purpose, set the corresponding values (to 1).
##### set the value to 1, as necessary. ####


# When building from Jenkins, Jenkins inject some env variable. Checking two of them to determine if its a local build.
if [ $JENKINS_HOME ] && [ $JOB_NAME ]; then
	BUILD_LOCALLY=0
else
	BUILD_LOCALLY=1
fi


BUILD_FOR_APP_STORE=0
BUILD_FOR_ENTERPRISE_DISTRIBUTION=0


TARGET_SMART_CARD="App_SmartCard"
#targets=("App_AdHoc" "$TARGET_SMART_CARD")
targets=("Coffee Timer")
#environments=("TEST1")
environments=("TEST1" "TEST2" "TEST3" "TEST4" "TEST5" "PROD")


function failed()
{
	    echo "Failed: $@" >&2
	        exit 1
	}



if [ $BUILD_LOCALLY -eq 1 ]
then
	 export WORKSPACE=${PWD}
	  PROJDIR=${WORKSPACE}
	   # Get svn revision number. In build server it will be set by Jenkins
	    SVN_REVISION=`/usr/bin/svnversion -nc | /usr/bin/sed -e 's/^[^:]*://;s/[A-Za-z]//'`
    else 
	     PROJDIR=${WORKSPACE}
fi



# init build variables and paths
echo Workspace: $WORKSPACE
#VERSION_FILE="${PROJDIR}/Resources/version.txt"
DEBUG_BUILDDIR="${PROJDIR}/build/Debug-iphoneos"
ADHOC_BUILDDIR="${PROJDIR}/build/Release-iphoneos"
APPSTORE_BUILDDIR="${PROJDIR}/build/AppStore-iphoneos"
#APP_NAME="App"
OS_VERSION="iphoneos14.4"
DEVELOPPER_NAME="developer-name"
PROVISONNING_PROFILE="${PROJDIR}/Resources/AD_HOC.mobileprovision"
LOGIN_KEYCHAIN_LOCATION="/Users/${USER}/Library/Keychains/login.keychain"
SYSTEM_KEYCHAIN="/Library/Keychains/System.keychain"


# get password as command line parameter from bash for local build
if [ $1 ]; then
	 KEYCHAIN_PASSWORD="$1"
fi


if [ $BUILD_FOR_ENTERPRISE_DISTRIBUTION -eq 1 ]
then
	 PROVISONNING_PROFILE="${PROJDIR}/Resources/Enterprise_Distribution.mobileprovision"
	  targets=("App_Enterprise")
fi



# Write revision number to version file, read in app and show in version info
echo ${SVN_REVISION}>${VERSION_FILE}


# -= Unlock Keychain =-
#security default-keychain -s $KEYCHAIN_LOCATION
security unlock-keychain -p $KEYCHAIN_PASSWORD $LOGIN_KEYCHAIN_LOCATION
security unlock-keychain -p $KEYCHAIN_PASSWORD $SYSTEM_KEYCHAIN


# -= Print directories =-
echo ProjectDir: $PROJDIR
echo DebugBuildDir: $DEBUG_BUILDDIR
echo AdHoc BuildDir: $ADHOC_BUILDDIR
echo AppStore BuildDir: $APPSTORE_BUILDDIR


OUTPUT_DIR=${WORKSPACE}/Output
#rm -rf $OUTPUT_DIR
#mkdir -p $OUTPUT_DIR


# For each target build the app for each test environment
for t in "${targets[@]}"
do
	 for e in "${environments[@]}"
		  do
			    echo "------ Building $t for $e --------"


			      INFO_PLIST_PATH="$PROJDIR/${t}-Info.plist"
			        BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "${BUILD_ROOT}/${INFO_PLIST_PATH}")
				  /usr/libexec/PlistBuddy -c "Set :SVNRevision $SVN_REVISION" "${BUILD_ROOT}/${INFO_PLIST_PATH}"
				    FULL_VERSION=${BUNDLE_VERSION}.${SVN_REVISION}
				      echo "Full version: $FULL_VERSION"


				        cd "${PROJDIR}"
					  xcodebuild -target "${t}" -configuration "Release" -sdk $OS_VERSION clean;


					    if [ "$t" == "$TARGET_SMART_CARD" ]; then
						       xcodebuild -target "${t}" -configuration "Release" -sdk $OS_VERSION GCC_PREPROCESSOR_DEFINITIONS="${e} SMART_CARD" || failed build;
						         else
								    xcodebuild -target "${t}" -configuration "Release" -sdk $OS_VERSION GCC_PREPROCESSOR_DEFINITIONS="${e}" || failed build;
								      fi


								        cd "${ADHOC_BUILDDIR}"
									  OUTPUT_DIR="${OUTPUT_DIR}/$FULL_VERSION"
									    mkdir -p $OUTPUT_DIR
									      IPA_NAME="${OUTPUT_DIR}/${t}_${e}.ipa"
									        /usr/bin/xcrun -sdk iphoneos PackageApplication -v "${t}.app" -o "${IPA_NAME}" --sign "${DEVELOPPER_NAME}" --embed "${PROVISONNING_PROFILE}"
										  zip -r -T -y "${OUTPUT_DIR}/${t}_${e}.app.dSYM.zip" "${t}.app.dSYM" || failed zip
										   done
									   done



									   # commented away ...
									   #: <<'END'
									   # ------------------------ AppStore Release ------------------------------------
									   if [ $BUILD_FOR_APP_STORE -eq 1 ]
									   then
										    targets=("App AppStore")
										    for t in "${targets[@]}"
										    do
											     cd "${PROJDIR}"
											      echo "-= Building AppStore Release =-"
											       xcodebuild -target "${t}" -configuration "Release" -sdk $OS_VERSION clean;
											        xcodebuild -target "${t}" -configuration "Release" -sdk $OS_VERSION GCC_PREPROCESSOR_DEFINITIONS='$(value) APP-STORE' || failed build;
												 cd "${APPSTORE_BUILDDIR}"
												  zip -r -T -y "${OUTPUT}/${t}.zip" "${t}.app" || failed zip
												   zip -r -T -y "${OUTPUT}/${t}.dSYM.zip" "${t}.app.dSYM" || failed zip
											   done
									   fi


									   #END

