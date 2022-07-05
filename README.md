# Tanzu Service Mesh Proof of Concept (PoC) Test Plan

This PoC test plan and evaluation process focuses on demonstrating functional operation, capabilities, and features of the Tanzu Service Mesh product.

**IMPORTANT** - This pre-sales offering does not consider all best practices and recommendations for production or extended pilot use.  VMware strongly encourages Customers to thoroughly review all publicly available product documentation and engage with the Tanzu Labs, Professional Services Organization, and/or Partners before going forward with any production design decisions. The PoC evaluation system is not the appropriate platform for intensive and lengthy performance testing and evaluation.

## Intended Audience

This guide is for cloud architects, engineers, administrators, and developers whose organization has an interest integrating Tanzu Service Mesh components and platform into their multi-cloud strategy and environments.

## Test Environment

>NOTE: BEFORE PROCEEDING TO THE TEST CASES, READ THIS SECTION IN ITS ENTIRETY AS IT INCLUDES PREPARATIONS AND PREREQUISITES REQUIRED TO SUCCESSFULLY RUN THE TEST CASES.

The test cases within this document assume the testing environment and Kubernetes clusters have been provisioned following the [Tanzu Service Mesh Environment Requirements and Supported Platforms](https://docs.vmware.com/en/VMware-Tanzu-Service-Mesh/services/tanzu-service-mesh-environment-requirements-and-supported-platforms/GUID-D0B939BE-474E-4075-9A65-3D72B5B9F237.html#workload-cluster-resource-requirements-0).

### Software Test Tools

This project contains a `Dockerfile` that comes with preconfigured CLIs like `kubectl`, `tanzu`, `kubectl-vshpere`, ... to provide a pre-built and configured environment that makes executing the provided test cases easier (Called here as Local Management Container).To be able to connect with a Kubernetes Cluster copy/download that Kubernetes Cluster's `kubeconfig` to a file located in `config/kube.conf` inside this project structure (NOTE: This file should NOT be checked into a public source repository). When running the Local Management Container from the supplied `make` file the `kubeconfig` will be automatically mapped/copied to the running continer and allow for `kubectl` commands to your Kubernetes Cluster.

#### Building and Running the Local Management Container

##### Build Container

```sh
make build
```

##### Rebuild Container

```sh
make rebuild
```

##### Start and exec to the container

```sh
make run
```

##### Join Running Container

```sh
make join
```

##### Start an already built Local Management Container

```sh
make start
```

##### Stop a running Local Management Container*

```sh
make stop
```

### Test-Cases-Inventory

#### Scenario SC01: Environment Setup & Validation

Test Case ID | Test Case Description |
--- | --- |
[SC01-TC01](scenarios/sc01-environment-setup/sc01-tc01-validate-tsm-console.md) | Validate TSM console accessible |

#### Scenario SC02: Cluster Onboarding

Test Case ID | Test Case Description |
[SC02-TC03](scenarios/sc02-cluster-onboarding/sc02-tc03-onboard-tsm-api.md) | Using TSM REST API |
--- | --- |

#### Scenario SC03: Application Deployment
Test Case ID | Test Case Description |
[SC03-TC01](scenarios/sc03-application-deployment/sc03-tc01-acme-fitness-application.md) | Deploying ACME Fitness Sample Application |
--- | --- |

#### Scenario SC04: Application Observability

Test Case ID | Test Case Description |
--- | --- |
--- | --- |

#### Scenario SC05: Application Resiliency

Test Case ID | Test Case Description |
--- | --- |
--- | --- |

#### Scenario SC06: Application Performance

Test Case ID | Test Case Description |
--- | --- |
--- | --- |
