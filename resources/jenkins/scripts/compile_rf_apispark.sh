#! /bin/bash

# Restlet Framework source dir: first argument of the script, given by Jenkins, matches to jenkins workspace
RF_SOURCE_DIR=$1

# Release type (snapshot, milestone, rc)
RELEASE_TYPE=$2

# Version (eg: 2.3)
VERSION=$3

# Build tag: will be used to create bundles artifact
BUILD_TAG=$5

cd build

# Clean build directories
rm -rf editions
rm -rf builds

mkdir builds

# Run test suite
ant -Deditions=jse -Dverify=true
mv editions/jse builds/

# Build RF OSGI version for APISpark
ant -Deditions=osgi -Dverify=false -Djavadoc=false -Dmaven=false -Dnsis=false -Dpackage=false -Declipse-pde=true -Declipse-pde-optional-dependencies=true -Dp2=true
mv editions/osgi builds/

# Build  RF JSE version for agent and create maven artefacts
ant -Deditions=jse -Dverify=false -Djavadoc=false -Dmaven=true -Dnsis=false -Dpackage=false -Declipse-pde=true -Declipse-pde-optional-dependencies=true -Dp2=true
# Copy maven edition to local maven repository
mkdir -p ~/.m2/repository/
cp -r editions/jse/dist/maven2/restlet-*/org ~/.m2/repository/
mv editions/jse builds/jse-maven