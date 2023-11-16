# lab1415

 


IBM Storage Fusion Data Protection
Session 1415
Lab Exercise Guide

JC Lopez
IBM, Storage Advanced Technology Specialist
Americas Storage SWAT Fusion Lead
jclopez@ibm.com

Joshua Blumert
IBM, Principal WW Storage Technical Specialist - Cloud Storage
blumert@us.ibm.com


Notices and disclaimers

© 2023 International Business Machines Corporation. No part of this document may be reproduced or transmitted in any form without written permission from IBM.

U.S. Government Users Restricted Rights — use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM.

This document is current as of the initial date of publication and may be changed by IBM at any time. Not all offerings are available in every country in which IBM operates.
Information in these presentations (including information relating to products that have not yet been announced by IBM) has been reviewed for accuracy as of the date of initial publication and could include unintentional technical or typographical errors. IBM shall have no responsibility to update this information. 

This document is distributed “as is” without any warranty, either express or implied. In no event, shall IBM be liable for any damage arising from the use of this information, including but not limited to, loss of data, business interruption, loss of profit or loss of opportunity. IBM products and services are warranted per the terms and conditions of the agreements under which they are provided. The performance data and client examples cited are presented for illustrative purposes only. Actual performance results may vary depending on specific configurations and operating conditions.

IBM products are manufactured from new parts or new and used parts. 
In some cases, a product may not be new and may have been previously installed. Regardless, our warranty terms apply.”

Any statements regarding IBM's future direction, intent or product plans are subject to change or withdrawal without notice.

Performance data contained herein was generally obtained in a controlled, isolated environments. Customer examples are presented as illustrations of how those customers have used IBM products and the results they may have achieved. Actual performance, cost, savings or other results in other operating environments may vary. 

References in this document to IBM products, programs, or services does not imply that IBM intends to make such products, programs or services available in all countries in which IBM operates or does business. 

Workshops, sessions and associated materials may have been prepared by independent session speakers, and do not necessarily reflect the views of IBM. All materials and discussions are provided for informational purposes only, and are neither intended to, nor shall constitute legal or other guidance or advice to any individual participant or their specific situation.

It is the customer’s responsibility to ensure its own compliance with legal requirements and to obtain advice of competent legal counsel as to the identification and interpretation of any relevant laws and regulatory requirements that may affect the customer’s business and any actions the customer may need to take to comply with such laws. IBM does not provide legal advice or represent or warrant that its services or products will ensure that the customer follows any law.



Notices and disclaimers (Continued)

Questions on the capabilities of non-IBM products should be addressed to the suppliers of those products. IBM does not warrant the quality of any third-party products, or the ability of any such third-party products to interoperate with IBM’s products. IBM expressly disclaims all warranties, expressed or implied, including but not limited to, the implied warranties of merchantability and fitness for a purpose.
The provision of the information contained herein is not intended to, and does not, grant any right or license under any IBM patents, copyrights, trademarks or other intellectual property right.

IBM, the IBM logo, and ibm.com are trademarks of International Business Machines Corporation, registered in many jurisdictions worldwide. Other product and service names might be trademarks of IBM or other companies. A current list of IBM trademarks is available on the Web at “Copyright and trademark information” at: www.ibm.com/legal/copytrade.shtml.



Table of Contents
1 IBM STORAGE FUSION INTRODUCTION	5
1.1 HOW TO START WORKSHOP	5
1.2 CONFIGURE ODF.	10
1.2.1 LOG INTO FUSION.	10
1.3 CONFIGURE BACKUP HUB	14
1.3.1 INSTALL BACKUP SERVER (HUB)	16
1.4 CONFIGURE BACKUP AND RESTORE SERVICE	19
1.4.1 SETUP BACKUP LOCATION	19
1.5 BACKUP POLICY	26
1.6 BACKUP AN APPLICATION	28
2 RUN A BACKUP	31
2.1 CREATE A TEST APPLICATION	31
2.2 BACKUP THE APPLICATON	36
2.3 BACKUP SPOKE	46
2.3.1 INSTALL BACKUP AGENT	46
3 BACKUP RECIPES	64
3.1 CREATE A RECIPE	64

1 IBM Storage Fusion Introduction


Organizations must quickly adjust to the changing business and outside influences that are causing rapid change, resulting in a need for business agility and faster business insights. Clients need applications and data to adjust and shift in response to dynamic market demands. They also need diverse and simplified tools and data services to build anywhere, at any pace, and for applications and data to scale dynamically, achieve peak performance, and adhere to security requirements.
Companies need a consistent way to deploy applications across on-premises infrastructure and public clouds, and not all of them are deploying containers to create that portability and consistency between cloud and on-premises environments.
IBM Storage Fusion is a container-native hybrid cloud data platform that offers simplified deployment and data management for Kubernetes applications on Red Hat® OpenShift® Container Platform. IBM Storage Fusion is designed to meet the storage requirements of modern, stateful Kubernetes applications and to make it easy to deploy and manage container-native applications and their data on Red Hat OpenShift Container Platform.
One of the primary functions of IBM Storage Fusion is data protection.
In this hands-on lab you will understand how to install and configure the basic components of IBM Storage Fusion Data Protection on Red Hat OpenShift Container Platform. 

1.1 How to start workshop

After you have launched this Lab and Lab Guide, start lab by choosing the Bastion (bastion.ocp.ibm.edu). Click in the black area near Red Hat icon.

 
Names of machines and order may be different. Make sure to select machine with bastion.ocp.ibm.edu in the name.

Click anywhere in the screen and hit the Enter key. Login with username=sysadmin and password=ibmrhocp.

 

Then open Firefox.

 

This lab has two (2) Red Hat OpenShift Clusters. There is a bookmark for each cluster in Firefox, open both “Cluster 1” and “Cluster 2”

 


Login with username=ocadmin and password=ibmrhocp.
 
Log into both clusters

  

1.2 Configure ODF.
1.2.1  Log into Fusion.

This lab requires storage for the backup service. We will configure ODF (OpenShift Data Foundation) as a data layer for each cluster:

Open The IBM Fusion GUI for each Cluster:
 


Select Data Foundation:

 

If you see Data Foundation with nodes and capacity, then this cluster is ready,

If you see “Configure Storage”:

 

Then select “Configure storage” and setup ODF:

 

For Encryption, select “None”.
 

Wait for the storage cluster to be configured:

 


1.3 Configure Backup Hub

IBM Storage Fusion supports a “hub and spoke” model for backup and restore. This means one cluster is setup as the backup server and the rest of the clusters only run a backup agent. 

On Cluster 1 we will setup the IBM Fusion Backup software as the “HUB”

First we will set the default storage class:

Let’s set the default storage class for the cluster to “ocs-storagecluster-cephfs”

Navigate to the storage classes page:
 

Select “ocs-storagecluster-cephfs” and edit “annotations”
 

 

Select “add more”

and add the annotation key: “storageclass.kubernetes.io/is-default-class” 
Value: “true” 
And “save”
 
You will now see the class noted as “default”

 


To set the default storage class via the CLI:

#  oc patch storageclass ocs-storagecluster-cephfs -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'

1.3.1 Install backup server (hub)

Select “Services” on the Fusion GUI and Select the first tile: “Backup & Restore”:

 

Backup & Restore Install

 

Then Select Storage for the backup Server (ocs-storagecluster-cephfs)

 



Then wait for the storage backup service to be installed:

 



 

 


1.4 configure backup and restore service

Once the Backup & Restore service is installed, we can configure it for use. 

1.4.1 setup backup location

Configure a backup location

Navigate to the Back&Restore in the Fusion GUI and select “Locations”

 

We will need an Object Bucket. Switch to the OpenShift GUI and select Storage  Object Bucket Claims (in the Project “IBM-backup-restore”)

“create Object Bucket Claim”


 

Create a bucket: “s3backup”
StorageClass: “openshift-storage.noobaa.io”
bucketClass: “noobaa-default-bucket-class”

Scroll down and “reveal values”

NOTE: DO NOT USE the EndPoint listed here. That is the internal endpoint.
Use the endpoint from “networking  Routes  S3” in the “Openshift-storage” project. 

 
Then we will fill this into the target for backups:

On the Fusion GUI, Backup&Restore, Locations, “Add Location”

“s3backup”

“s3 Compliant”

 


 

Fill in:
Endpoint (use http, not https)
Bucket
Access key, Secret Key

For the EndPoint , Navigate to the OpenShift GUI, Networking, Routes, S3

And copy the S3 Route, use HTTP, not HTTPS

http://s3-openshift-storage.apps.ocp.ibm.edu
 
  


You will see

 

1.5 backup policy

Create a backup policy

Navigate to Fusion GUI, Backup & Restore, Policies

 

Add Policy

 


 

Set name, Schedule, location (choose the bucket you added) 

 


1.6 Backup an application

Create an application.

Open a terminal on the Bastion Host:

Open a terminal for a command line, Click “Activities” and type “term”:
  

Then type:
# git clone https://github.com/jblumert/lab1415
 



# oc login -u ocadmin -p ibmrhocp --server=https://api.ocp.ibm.edu:6443

(note the --server option is 2 dashes)

# oc get nodes

 


























2 Run a Backup
2.1 Create a Test Application


On the terminal, on “bastion” node:

# ls 

check for the directory lab1415, if it is not there run:
git clone https://github.com/jblumert/lab1415

# cd lab1415
# oc new-project lab1
# oc apply -f app.yaml

# oc get pods

# oc get pvcs

You will see a running pod and a new pvc (cephfs)



 

Get the application route:

# oc get routes 

(cut and paste into browser)

Or get the route from the “developer” Topology GUI for the project “lab1”
 

Login to the new application
User: admin
Password: admin

And create folders and files.
 





 


 


 

 






2.2 backup the applicaton

Now run a backup on the application

Navigate to the Fusion GUI –– applications

 

Select “lab1”

 

Assign backup policy

Leave “run backup now” checked. 
 

 

Select “lab1”

Select backups

 

 

 




 

Now the backup is complete. 

Restore the application to a new Project:

Select “restore”

 


Restore to current cluster, new project
 

 

 
Navigate back to applications:

 

 


 

Test the restored application:

 


 


2.3 Backup Spoke

2.3.1 install backup agent

Note set default storage class if not set. 

(Follow same instructions for setting default storage class in first cluster)

On cluster 2, go to the fusion gui:

Services

Backup and Restore Agent

 


 

Get the HUB “snipet”



On Hub Cluster, Fusion GUI, Topology

 

Connect Cluster

 

Copy snippet

 

 


Now Paste in spoke cluster setup

And select storage class “cephfs”


 

Agent will install

 


 

 


Navigate back to the hub cluster, fusion GUI

View the new Topology

 


Select “backed up applications”

 

Select “restore”

Choose different cluster

 

Select a Backup

 

Restore

 

Confirm
 

Go back to the Spoke Cluster – Fusion GUI , Applications

 


Backup spoke cluster

Log in to spoke cluster at command line

Get log in string from GUI:

 


 

oc login --token=sha256~VV2WDsFUqMrVTz9inQ2XGhexP9akiHed9vyNU4yJcjM --server=https://api.ocp-50t6fjkgae-luib.cloud.techzone.ibm.com:6443


# oc new-project spoke1

# oc get pods

# cd lab1415

# oc apply -f app.yaml

# oc get pods

Backup application on Spoke

Go to fusion GUI on HUB

Select “Topology”

 

Select the spoke  View backed up apps. 

 

Select “protect apps” 
 

Select the spoke cluster
And select the new application you just created

 


 


Watch backup

 

After the application is restored, open the route to the application and verify the app. 


 
3 Backup Recipes

3.1 Create a recipe

Log into to cluster 1 at the command line 



  
 



 
# git clone drlab

# cd drlab

Connect to the project “lab1”
# oc project lab1

Validate the application is running
# oc get pods

Validate the application has a policy assigned
# oc get policyassignment -n ibm-spectrum-fusion-ns | grep lab1

# oc apply -f recipe.yaml

# oc get recipe -n ibm-spectrum-fusion-ns

Apply the recipe to the policy assignment

Note this is the full command but there is a run script in the directory called “applyhook.sh”

Here is the full command:
# oc -n ibm-spectrum-fusion-ns patch policyassignment lab1-monthly-apps --type merge -p '{spec:{recipe:{name:hook-recipe00, namespace:ibm-spectrum-fusion-ns, apiVersion:spp-data-protection.isf.ibm.com/v1alpha1}}}'

Or here is the script which is run as:
./applyhook.sh <policyassignment>

Which will be:

./applyhook.sh lab1-monthly-apps









Next run a backup:

 


 


 




Now select “details”


 

 

 

Wait for the backup to complete:
 

Now you can see the hooks from the recipe:

hooks:
  - name: backup-hook
    namespace: lab1
    type: exec
    labelSelector: app=filebrowser
    singlePodOnly: true
    ops:
    - name: start
      command: >
        ["/bin/mkdir", "-p", "/srv/backup"]
    - name: pre
      command: >
        ["/bin/sh", "-c", "echo recipe backup pre.hook $(TZ=PST8 date) >> /srv/backup.txt"]
    - name: post-backup
      command: >
        ["/bin/sh", "-c", "echo recipe backup post.hook $(TZ=PST8 date) >> /srv/backup.txt"]
    - name: post-restore
      command: >
        ["/bin/sh", "-c", "echo recipe restore post.hook $(TZ=PST8 date) >> /srv/backup.txt"]
    - name: post-restore-additional
      command: >
        ["/bin/sh", "-c", "echo recipe restore **ADDITIONAL**  post.hook $(TZ=PST8 date) >> /srv/backup.txt"]



Log into the pod

# oc get pods

# oc rsh <pod> cat /srv/backup.txt

 

Here we can see the backup ran the recipe hooks. The hooks wrote to a file on the pod. 

![image](https://github.com/jblumert/lab1415/assets/66739278/6f378e89-e6d5-40de-9fce-e509a5849d26)
