#!/bin/bash

set -ev

if [ "${XCODE_PROJECT-UNDEF}" != "UNDEF" ]; then
    xcodebuild -project ${XCODE_PROJECT} -scheme ${XCODE_SCHEME} -destination ${XCODE_DESTINATION} -sdk ${XCODE_SDK} test
else
    xcodebuild -workspace ${XCODE_WORKSPACE} -scheme ${XCODE_SCHEME} -destination ${XCODE_DESTINATION} -sdk ${XCODE_SDK} test
fi
