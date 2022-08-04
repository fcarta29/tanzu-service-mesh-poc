# SC06-TC02: Application Performance with Tanzu Service Mesh (TSM) - Creating Service Level Objectives (SLO) Using TSM REST API

This scenario captures how to create Service Level Objectives (SLO) for the monitoring application performance.

---

## Test Case Summary

This scenario test case creates a SLO via the TSM Rest API for the ACME Fitness Application to monitor and capture violations of the SLO during load.

---

## Useful documentation

* VMware Cloud Portal Auth/Token Flow for API calls [VMware Cloud Portal Auth/Token Flow for API calls](https://docs.vmware.com/en/vRealize-Operations/Cloud/com.vmware.vcom.api.doc/GUID-57E59E35-6C08-4424-A77F-468FACD35C41.html)
* Generating an API Token to Interact with VMware Cloud Service APIs [Generating an API Token to Interact with VMware Cloud Service APIs](https://docs.vmware.com/en/VMware-Cloud-services/services/Using-VMware-Cloud-Services/GUID-E2A3B1C1-E9AD-4B00-A6B6-88D31FCDDF7C.html)
* Tanzu Service Mesh API [Tanzu Service Mesh API](https://docs.vmware.com/en/VMware-Tanzu-Service-Mesh/services/api-programming-guide/GUID-FED8E849-B3C3-49ED-9FDB-1317CFFF3141.html)
* Tanzu Service Mesh Service Level Objective (SLO) Overview [Tanzu Service Mesh SLO Overview](https://docs.vmware.com/en/VMware-Tanzu-Service-Mesh/services/slos-with-tsm/GUID-39CAB7F1-2425-43D4-953E-556A934976CE.html)

---

## Prerequisites

* Completion of TSM Console access [SC01-TC01](../sc01-environment-setup/sc01-tc01-validate-tsm-console.md)
* For Two(2) Kubernetes Clusters `${KUBERNETES_CLUSTER1}` and `${KUBERNETES_CLUSTER2}` completion of TSM Onboarding  [SC02-TC01](../sc02-cluster-onboarding/sc02-tc01-onboard-tsm-ui.md) or [SC02-TC02](../sc02-cluster-onboarding/sc02-tc02-onboard-tmc.md) or [SC02-TC03](../sc02-cluster-onboarding/sc02-tc03-onboard-tsm-api.md)
* Completion of ACME Fitness Application Deployment [SC03-TC01](../sc03-application-deployment/sc03-tc01-acme-fitness-application.md)

---

## Test Procedure

This test procedure assumes that the full ACME Fitness Application was deployed to the Kubernetes Cluster `${KUBERNETES_CLUSTER1}`.

1. If not already obtained, from the VMware Cloud Services Portal get or generate an API token. Copy the API token and save it to a secure note/place.(NOTE: Typically this would be created for an automation service account)

    ![VMware CSP Create Organization](../images/vmware-csp-my-account-api-token.png)

2. With this API token in place for `${CSP_API_TOKEN}` use the example below to obtain an authentication token from the VMware Cloud Service API. On successful authorization a response including an `access_token` will be returned which should be copied and retained for further API requests.

    ```execute
    curl -k -X POST "https://console.cloud.vmware.com/csp/gateway/am/api/auth/api-tokens/authorize" -H "Accept: application/json" -H "Content-Type: application/x-www-form-urlencoded" -d "refresh_token=${CSP_API_TOKEN}"
    ```

    Expected:

    ```json
    {
        "id_token": "REDACTED",
        "token_type": "bearer",
        "expires_in": 1799,
        "scope": "ALL_PERMISSIONS customer_number openid group_ids group_names",
        "access_token": "REDACTED",
        "refresh_token": "REDACTED"
    }
    ```

    > **_NOTE:_**  You can directly assign and obtain the `auth_token` with the following:

    ```execute
    export CSP_AUTH_TOKEN=$(curl -k -X POST "https://console.cloud.vmware.com/csp/gateway/am/api/auth/api-tokens/authorize" -H "accept: application/json" -H "Content-Type: application/x-www-form-urlencoded" -d "refresh_token=${CSP_API_TOKEN}" | jq -r '.access_token')
    ```

3. Ensure no previous SLOs exist for the `catalog` service first.

    ```bash
    curl -k -X GET "https://${TSM_SERVER_NAME}/tsm/v1alpha1/global-namespaces/${TSM_GLOBALNAMESPACE_NAME}/service-level-objectives" -H "csp-auth-token:${CSP_AUTH_TOKEN}" | jq .
    ```

    Expected (If no previous SLO exists):

    ```json
    []
    ```

4. Optional: If desired, here is how you can delete a SLO.

    ```bash
    curl -k -X DELETE "https://${TSM_SERVER_NAME}/tsm/v1alpha1/global-namespaces/${TSM_GLOBALNAMESPACE_NAME}/service-level-objectives/${TSM_CATALOG_SLO_NAME}" -H "csp-auth-token:${CSP_AUTH_TOKEN}" | jq .
    ```

    Response:

    ```json
    {
        "status": "${TSM_CATALOG_SLO_NAME} with gnsId ${TSM_GLOBALNAMESPACE_NAME} deleted"
    }
    ```

5. Create a monitored SLO for the `catalog` service.

    ```bash
    curl -k -X POST "https://${TSM_SERVER_NAME}/tsm/v1alpha1/global-namespaces/${TSM_GLOBALNAMESPACE_NAME}/service-level-objectives" -H "csp-auth-token:${CSP_AUTH_TOKEN}" -H "Content-Type: application/json" -d '
    {
        "type": "MONITORED",
        "description": "SLO for catalog service of the ACME Fitness App",
        "labels": [],
        "basic_options": [{
            "metricName": "p99LATENCY",
            "value": 80
        }],
        "slo_target_value": 99.999,
        "slo_period": {
            "slo_period_frequency": "MONTHLY"
        },
        "services": [{
            "name": "catalog"
        }]
    }' | jq .
    ```

    Expected:

    ```json
    {
        "type": "MONITORED",
        "description": "SLO for catalog service of the ACME Fitness App",
        "labels": [],
        "basic_options": [
            {
            "metricName": "p99LATENCY",
            "value": 80
            }
        ],
        "slo_target_value": 99.9990005493164,
        "slo_period": {
            "slo_period_frequency": "MONTHLY"
        },
        "slo_actions": [],
        "services": [
            {
            "name": "catalog"
            }
        ],
        "id": "c9a73960-1425-11ed-9e16-aeaab76a2e58",
        "creationTime": "2022-08-04T18:46:44.806Z"
    }
    ```

    > **_NOTE:_**  Currently via the TSM REST API you cannot set the name like you can via the TSM UI. The display name in the TSM UI will be the `id` field.

6. Validate in TSM UI SLO is created

    TBD[fcarta] insert snapshot here

7. Navigate to SLO data page and show metrics

    TBD[fcarta] insert snapshots here

8. Fire up locust and send load - 1000 users 100 per second

9. View SLO violations in UI - watch error budget get spent

