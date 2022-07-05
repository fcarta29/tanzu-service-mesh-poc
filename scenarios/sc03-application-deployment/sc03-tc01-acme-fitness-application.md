# SC03-TC01: Application Deployment to Kubernetes Cluster with Tanzu Service Mesh (TSM) - Deploying ACME Fitness Sample Application

This scenario captures how to deploy an application to a Kubernetes Cluster with Tanzu Service Mesh

---

## Test Case Summary

This scenario test case captures how to deploy the ACME Fitness sample application to a Kubernetes Cluster with Tanzu Service Mesh (TSM)

---

## Prerequisites

* Completion of TSM Console access [SC01-TC01](../sc01-environment-setup/sc01-tc01-validate-tsm-console.md)
* Completion of TSM Onboarding Kubernetes Cluster [SC02-TC01](../sc02-cluster-onboarding/sc02-tc01-onboard-tsm-ui.md) or [SC02-TC02](../sc02-cluster-onboarding/sc02-tc02-onboard-tmc.md) or [SC02-TC03](../sc02-cluster-onboarding/sc02-tc03-onboard-tsm-api.md)
* Valid `kubeconfig` and token for targeted Kubernetes Cluster

---

## Test Procedure

1. Confirm you are connected the right Kubernetes cluster, if working from the supplied Management container you can run the following:

    ```execute
    kubectx
    ```

    Expected:<pre>
    fcarta-tkc-aws-2-admin@fcarta-tkc-aws-2
    fcarta-tkc-aws-3-admin@fcarta-tkc-aws-3
    <b><font color="yellow">fcarta-tkc-aws-admin@fcarta-tkc-aws</font></b></pre>

    Otherwise, if not using the supplied Management Container, run the following:

    ```execute
    kubectl config current-context
    ```

    Expected:

    ```sh
    fcarta-tkc-aws-admin@fcarta-tkc-aws
    ```

2. Confirm your preferred namespace is set to `default`, if working from the supplied Management container you can run the following:

    ```execute
    kubens
    ```

    Expected:

    ```sh
    Context "fcarta-tkc-aws-admin@fcarta-tkc-aws" modified.
    Active namespace is "default".
    ```

    > **_NOTE:_**  If needed to change to the `default` namespace running the following.

    ```sh
    kubens default
    ```

    Otherwise, if not using the supplied Management Container, run the following:

    ```execute
    kubectl config view --minify --output 'jsonpath={..namespace}'; echo
    ```

    Expected:

    ```sh
    default
    ```

    > **_NOTE:_**  If needed to change to the `default` namespace running the following.

    ```sh
    kubectl config set-context --current --namespace=default
    ```

3. Deploy the supplied Kubernetes manifests for the ACME Fitness Application.

    ```execute
    kubectl apply -f scenarios/files/acme-fitness-app/app/acme-fitness.yaml
    kubectl apply -f scenarios/files/acme-fitness-app/app/acme-gateway.yaml
    kubectl apply -f scenarios/files/acme-fitness-app/app/acme-secrets.yaml
    ```

    Expected:

    ```sh
    deployment.apps/cart-redis created
    service/cart created
    deployment.apps/cart created
    service/shopping created
    deployment.apps/shopping created
    service/order-mongo created
    deployment.apps/order-mongo created
    service/order created
    deployment.apps/order created
    service/payment created
    deployment.apps/payment created
    configmap/users-initdb-config created
    service/users-mongo created
    deployment.apps/users-mongo created
    service/users created
    deployment.apps/users created
    ...
    gateway.networking.istio.io/acme-gateway created
    virtualservice.networking.istio.io/acme created
    ...
    secret/redis-pass created
    secret/catalog-mongo-pass created
    secret/order-mongo-pass created
    secret/users-mongo-pass created
    ```

4. Validate all pods for the ACME Fitness application are running

    ```execute
    kubectl get pods
    ```

    Expected:

    ```sh
    NAME                            READY   STATUS    RESTARTS   AGE
    cart-844fcb9497-qkc4x           2/2     Running   0          5d21h
    cart-redis-df554fbb7-vs5m6      2/2     Running   0          5d21h
    loadgenerator-fbfdf7d99-jkb9g   2/2     Running   0          5d21h
    order-55b6987599-l42xj          2/2     Running   0          5d21h
    order-mongo-7ccdbd8869-mj8qc    2/2     Running   0          5d21h
    payment-6977b8df86-rmfph        2/2     Running   0          5d21h
    shopping-6ff46695f5-rr9m2       2/2     Running   0          5d18h
    users-5cf6b58489-p4l5z          2/2     Running   0          5d21h
    users-mongo-74c459f9f7-xpqbf    2/2     Running   0          5d21h
    ```

5. View ACME Fitness Services Running

    ```execute
    kubectl get services
    ```

    Expected:

    ```sh
    NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)     AGE
    cart          ClusterIP   100.67.53.201    <none>        5000/TCP    5d22h
    cart-redis    ClusterIP   100.69.70.179    <none>        6379/TCP    5d22h
    kubernetes    ClusterIP   100.64.0.1       <none>        443/TCP     32d
    loadgen       ClusterIP   100.71.244.67    <none>        80/TCP      5d22h
    order         ClusterIP   100.71.170.200   <none>        6000/TCP    5d22h
    order-mongo   ClusterIP   100.70.195.57    <none>        27017/TCP   5d22h
    payment       ClusterIP   100.64.139.183   <none>        9000/TCP    5d22h
    shopping      ClusterIP   100.68.234.11    <none>        3000/TCP    5d22h
    users         ClusterIP   100.65.54.70     <none>        8081/TCP    5d22h
    users-mongo   ClusterIP   100.69.189.191   <none>        27017/TCP   5d22h
    ```

6. Get the ACME Fitness Applicaiton endpoint from the `EXTERNAL-IP` of the TSM LoadBalancer object and paste into browser.

    ```execute
    kubectl get svc -A | grep LoadBalancer
    ```

    Expected:

    ```sh
    istio-system              istio-ingressgateway            LoadBalancer   100.68.30.11     <REDACTED>.us-west-2.elb.amazonaws.com   15021:31714/TCP,80:31268/TCP,443:32006/TCP   11d
    ```

    > **_NOTE:_**  It is recommended that you have a POC test domain name that you can configure DNS for the ACME Ftiness Application and map to this `EXTERNAL-IP`.

---

## Status Pass/Fail

* [  ] Pass
* [  ] Fail

Return to [Test Cases Inventory](../../README.md#test-cases-inventory)
