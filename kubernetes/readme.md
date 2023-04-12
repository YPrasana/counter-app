#pull image from docker hub - docker pull prasannay/counter-app:latest

#to docker hub login - sudo docker login --username pwd:

#to build the docker image - sudo docker build -t yourreponame/imagename:version .

#to push build image to your repo - sudo docker push repo/imagename:version

#to run acontainer out of a docker image - sudo docker run -it -p 49160:8080 prasannay/counter-app sh

#to check the running containers - sudo docker ps

#to check all the containers - sudo docker ps -a

#to view container info - docker inspect <container_id>

#to remove an image locally.First stop the container running out of it and remove container and later remove image - sudo docker stop <container_id>

sudo docker rm <container_id>

sudo docker rmi <image_id>

#list all images - sudo docker images

#remove all containers that are exited at a time - sudo docker rm $(docker ps --filter status=exited -q)
===================================
kubectl create ns prasanna

kubectl apply -f secret.yaml -n prasanna
kubectl apply -f mysql-pvc.yaml -n prasanna
kubectl apply -f mysql_deployment.yaml -n prasanna
kubectl apply -f mysql_svc.yaml -n prasanna
kubectl apply -f counter_app-deployment.yaml -n prasanna
kubectl apply -f counter_app_svc.yaml -n prasanna


kubectl get deployment -n prasanna
kubectl get svc -n prasanna
kubectl get pods -n prasanna
kubectl get pvc -n prasanna
kubectl get pv -n prasanna
kubectl get secret -n prasanna
cd kubernetes
>kubectl exec --stdin --tty mysql-deployment-7d888899b7-hrqtt -n prasanna -- /bin/bash
root@mysql-deployment-7d888899b7-hrqtt:/# mysql -u admin@127.0.0.1
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| test               |
+--------------------+
2 rows in set (0.02 sec)

mysql> use test;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| test               |
+--------------------+
2 rows in set (0.02 sec)

mysql> use test;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> select * from counter;
+----------+
| COUNTING |
+----------+
|       10 |
+----------+
1 row in set (0.01 sec)
==========================================================
C:\workspace\counter-app\kubernetes>kubectl get pods -n prasanna
NAME                                                     READY   STATUS                       RESTARTS          AGE
alertmanager-stable-kube-prometheus-sta-alertmanager-0   2/2     Running                      3 (9d ago)        16d
mysql-deployment-7d888899b7-hrqtt                        1/1     Running                      0                 38h
prometheus-stable-kube-prometheus-sta-prometheus-0       2/2     Running                      2 (9d ago)        16d
stable-grafana-6db5467f49-5cvsg                          3/3     Running                      3 (9d ago)        16d
stable-kube-prometheus-sta-operator-75cc98c5cc-xqck2     1/1     Running                      1 (9d ago)        16d
stable-kube-state-metrics-7754477f45-7xzq9               1/1     Running                      1 (9d ago)        16d
stable-prometheus-node-exporter-jh48c                    1/1     Running                      2 (20h ago)       16d
=======================================================================================

C:\workspace\counter-app\kubernetes>kubectl get deployments -n prasanna
NAME                                  READY   UP-TO-DATE   AVAILABLE   AGE
mysql                                 1/1     1            1           9d
mysql-deployment                      1/2     2            1           40h
stable-grafana                        1/1     1            1           16d
stable-kube-prometheus-sta-operator   1/1     1            1           16d
stable-kube-state-metrics             1/1     1            1           16d
=======================================================================================
C:\workspace\counter-app\kubernetes>kubectl get svc -n prasanna
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   16d
mysql-service                             ClusterIP   10.102.173.52   <none>        3306/TCP                     38h
mysql-svc                                 NodePort    10.103.60.153   <none>        3306:32306/TCP               9d
prometheus-operated                       ClusterIP   None            <none>        9090/TCP                     16d
stable-grafana                            NodePort    10.98.139.163   <none>        80:32415/TCP                 16d
stable-kube-prometheus-sta-alertmanager   ClusterIP   10.108.48.76    <none>        9093/TCP                     16d
stable-kube-prometheus-sta-operator       ClusterIP   10.98.165.237   <none>        443/TCP                      16d
stable-kube-prometheus-sta-prometheus     NodePort    10.99.229.86    <none>        9090:31603/TCP               16d
stable-kube-state-metrics                 ClusterIP   10.98.153.196   <none>        8080/TCP                     16d
stable-prometheus-node-exporter           ClusterIP   10.101.113.83   <none>        9100/TCP                     16d
=========================================================================================

C:\workspace\counter-app\kubernetes>kubectl get all -n prasanna
NAME                                                         READY   STATUS                       RESTARTS         AGE
pod/alertmanager-stable-kube-prometheus-sta-alertmanager-0   2/2     Running                      3 (9d ago)       16d
pod/mysql-6cf97d9cc5-ktf2z                                   0/1     CreateContainerConfigError   0                9d
pod/mysql-7565c64b68-4rr86                                   1/1     Running                      0                9d
pod/mysql-deployment-7d888899b7-hrqtt                        1/1     Running                      0                38h
pod/mysql-deployment-7d888899b7-jmtt6                        0/1     CrashLoopBackOff             207 (4m3s ago)   38h
pod/prometheus-stable-kube-prometheus-sta-prometheus-0       2/2     Running                      2 (9d ago)       16d
pod/stable-grafana-6db5467f49-5cvsg                          3/3     Running                      3 (9d ago)       16d
pod/stable-kube-prometheus-sta-operator-75cc98c5cc-xqck2     1/1     Running                      1 (9d ago)       16d
pod/stable-kube-state-metrics-7754477f45-7xzq9               1/1     Running                      1 (9d ago)       16d
pod/stable-prometheus-node-exporter-jh48c                    1/1     Running                      2 (20h ago)      16d

NAME                                              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
service/alertmanager-operated                     ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   16d
service/mysql-service                             ClusterIP   10.102.173.52   <none>        3306/TCP                     38h
service/mysql-svc                                 NodePort    10.103.60.153   <none>        3306:32306/TCP               9d
service/prometheus-operated                       ClusterIP   None            <none>        9090/TCP                     16d
service/stable-grafana                            NodePort    10.98.139.163   <none>        80:32415/TCP                 16d
service/stable-kube-prometheus-sta-alertmanager   ClusterIP   10.108.48.76    <none>        9093/TCP                     16d
service/stable-kube-prometheus-sta-operator       ClusterIP   10.98.165.237   <none>        443/TCP                      16d
service/stable-kube-prometheus-sta-prometheus     NodePort    10.99.229.86    <none>        9090:31603/TCP               16d
service/stable-kube-state-metrics                 ClusterIP   10.98.153.196   <none>        8080/TCP                     16d
service/stable-prometheus-node-exporter           ClusterIP   10.101.113.83   <none>        9100/TCP                     16d

NAME                                             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
daemonset.apps/stable-prometheus-node-exporter   1         1         1       1            1           <none>          16d

NAME                                                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/mysql                                 1/1     1            1           9d
deployment.apps/mysql-deployment                      1/2     2            1           40h
deployment.apps/stable-grafana                        1/1     1            1           16d
deployment.apps/stable-kube-prometheus-sta-operator   1/1     1            1           16d
deployment.apps/stable-kube-state-metrics             1/1     1            1           16d

NAME                                                             DESIRED   CURRENT   READY   AGE
replicaset.apps/mysql-6cf97d9cc5                                 1         1         0       9d
replicaset.apps/mysql-6d68b8ccb5                                 0         0         0       9d
replicaset.apps/mysql-7565c64b68                                 1         1         1       9d
replicaset.apps/mysql-7d99db49d8                                 0         0         0       9d
replicaset.apps/mysql-deployment-687cc66cc7                      0         0         0       40h
replicaset.apps/mysql-deployment-7d888899b7                      2         2         1       38h
replicaset.apps/stable-grafana-6db5467f49                        1         1         1       16d
replicaset.apps/stable-kube-prometheus-sta-operator-75cc98c5cc   1         1         1       16d
replicaset.apps/stable-kube-state-metrics-7754477f45             1         1         1       16d

NAME                                                                    READY   AGE
statefulset.apps/alertmanager-stable-kube-prometheus-sta-alertmanager   1/1     16d
statefulset.apps/prometheus-stable-kube-prometheus-sta-prometheus       1/1     16d
===============================================================================================================


