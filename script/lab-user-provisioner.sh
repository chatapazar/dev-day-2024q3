#!/bin/bash

####################################################
# Functions
####################################################
repeat() {
    echo
    for i in {1..120}; do
        echo -n "$1"
    done
    echo
}

create_projects() {
    echo

    for i in $( seq 1 $totalUsers )
    do
        echo ""
        echo "Logging in as user$i user to create projects..."
        echo

        oc login -u user$i -p $USER_PASSWORD --insecure-skip-tls-verify
        oc new-project user$i-devspaces
        oc new-project user$i-super-heroes
        oc new-project user$i-monitoring
        repeat '-'
    done
}

add_monitoring_edit_role_to_user()
{
    echo ""
    echo "Logging in as cluster administrator to add monitoring edit role to users..."
    echo

    oc login -u admin -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for i in $( seq 1 $totalUsers )
    do
        oc adm policy add-role-to-user monitoring-edit user$i -n user$i-super-heroes
    done
}

add_monitoring_view_role_to_grafana_serviceaccount() {

    echo ""
    echo "Logging in as cluster administrator to add monitoring view role to users..."
    echo

    oc login -u admin -p $ADMIN_PASSWORD --insecure-skip-tls-verify

    for i in $( seq 1 $totalUsers )
    do
        oc adm policy add-cluster-role-to-user cluster-monitoring-view -z grafana-sa -n user$i-monitoring
    done
}

####################################################
# Main (Entry point)
####################################################
totalUsers=$1

create_projects
repeat '-'
add_monitoring_edit_role_to_user
repeat '-'
add_monitoring_view_role_to_grafana_serviceaccount
repeat '-'
