#!/bin/bash
# Reset Production Project (initial active services: Blue)
# This sets all services to the Blue service so that any pipeline run will deploy Green
if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "  $0 GUID"
    exit 1
fi

GUID=$1
echo "Resetting Parks Production Environment in project ${GUID}-parks-prod to Green Services"

# Code to reset the parks production environment to make
# all the green services/routes active.
# This script will be called in the grading pipeline
# if the pipeline is executed without setting
# up the whole infrastructure to guarantee a Blue
# rollout followed by a Green rollout.

# To be Implemented by Student
printf "\n"
destApp="mlbparks-blue"

activeApp="$(oc get route mlbparks -n ${GUID}-parks-prod -o jsonpath='{ .spec.to.name }')"
echo ${activeApp}

if [ $activeApp == 'mlbparks-green' ]; then
    echo "Reseting mlbparks to Blue"
    oc delete svc ${activeApp} -n ${GUID}-parks-prod
    oc expose dc/${destApp} -l type=parksmap-backend --port 8080 -n ${GUID}-parks-prod
    oc patch route mlbparks -n ${GUID}-parks-prod -p '{"spec":{"to":{"name":"'$destApp'"}}}'
else
    echo "mlbparks is pointing Blue already"
fi

printf "\n"
destApp="nationalparks-blue"

activeApp="$(oc get route nationalparks -n ${GUID}-parks-prod -o jsonpath='{ .spec.to.name }')"
echo ${activeApp}

if [ $activeApp == 'nationalparks-green' ]; then
    echo "Reseting nationalparks to Blue"
    oc delete svc ${activeApp} -n ${GUID}-parks-prod
    oc expose dc/${destApp} -l type=parksmap-backend --port 8080 -n ${GUID}-parks-prod
    oc patch route nationalparks -n ${GUID}-parks-prod -p '{"spec":{"to":{"name":"'$destApp'"}}}'
else
    echo "nationalparks is pointing Blue already"
fi

printf "\n"
destApp="parksmap-blue"

activeApp="$(oc get route parksmap -n ${GUID}-parks-prod -o jsonpath='{ .spec.to.name }')"
echo ${activeApp}

if [ $activeApp == 'parksmap-green' ]; then
    echo "Reseting parksmap to Blue"
    oc delete svc ${activeApp} -n ${GUID}-parks-prod
    oc expose dc/${destApp} --port 8080 -n ${GUID}-parks-prod
    oc patch route parksmap -n ${GUID}-parks-prod -p '{"spec":{"to":{"name":"'$destApp'"}}}'
else
    echo "parksmap is pointing Blue already"
fi
