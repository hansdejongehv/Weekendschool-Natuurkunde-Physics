#!/bin/bash


#############
# 
# This is the script to create a release tar file with the material for
# users who want to install scratchClient-Tutorials
#
# It will:
# It will take the entire local copy of the Github project and
# - Copy the whole local copy and from that copy:
# - Delete the .git folder (which contains old commits and the Github administration)
# - Delete the docs folder (which contians Github pages)
# - Delete the _NOT_PART_OF_RELEASE folder
# - Delete specific files that are not required for users of the project 
# 	(e.g. if delete the .pptx files of the presentations, because the user uses the .pdf files)
#
# Author: Hans de Jong
# Date: 2 April 2018
#
##############

#set -x
# change these variables when material is moved to another location
ParentSourceDir=~/NAS/GitHub
ParentReleaseDir=$ParentSourceDir/Releases

# set the derived locations
RepositoryName=Weekendschool-Natuurkunde-Physics
ReleaseGeneralName=Weekendschool-Natuurkunde-Physics-Rel
SourceDir=$ParentSourceDir/$RepositoryName
RepositoryReleaseDir=$ParentReleaseDir/$RepositoryName
TargetDir=$RepositoryReleaseDir/$ReleaseGeneralName
TargetTarFile=$RepositoryReleaseDir/$ReleaseGeneralName.tar.gz

echo "-----> Create the release for the current version of repository: $RepositoryName"
echo "-----> Generic name of the installer that will be created:       $ReleaseGeneralName"

# make the path to the target folder if not yet present
# The purpose is not to create $TargetDir (it will be deleted next), 
# but to create the parent path
mkdir -p $TargetDir


# Remove previous release, if present
echo "--> Remove any previous release, if present"
rm -rf $TargetDir
rm -rf $TargetTarFile

echo "--> Copy the entire directory to be able to start weeding"
cp -r $SourceDir $TargetDir

cd $TargetDir

rm -rf .git

echo "--> Remove those parts that should not be part of the released installer"

# Remove everything that is not Proeven or LICENSE. Rename the latter to LICENSE.txt
for f in $TargetDir/*
do
	# echo "$f"
	case "$f" in
		$TargetDir/Proeven)	
		;;
		$TargetDir/LICENSE)
		mv $TargetDir/LICENSE $TargetDir/LICENSE.txt
		;;
		*)
		rm -r "$f"
		;;
	esac
done

# Remove all files other than .pdf or .xps
for f in $TargetDir/Proeven/*/*
do
	# echo "$f"
	case "$f" in
		$TargetDir/*.pdf)	
		;;
		$TargetDir/*.xps)
		;;
		*)
		rm "$f"
		;;
	esac

done

zip -r "Alle Proeven.zip" Proeven LICENSE.txt
for f in Proeven/Proef*
do
	zip -r "$f.zip" "$f" LICENSE.txt
done

mv $TargetDir/Proeven/*.zip $TargetDir

rm -r $TargetDir/Proeven
rm -r LICENSE.txt

read -p "Hit Enter to close"
