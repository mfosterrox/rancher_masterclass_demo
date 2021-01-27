# Cluster Setup

- [Cluster Setup](#cluster-setup)
  - [Getting Started](#getting-started)
    - [What You'll Need](#what-youll-need)
  - [How the Makefile Works](#how-the-makefile-works)
    - [Repository Structure](#repository-structure)
  - [GCP Setup](#gcp-setup)
    - [Adding Credentials](#adding-credentials)
    - [The Make Commands](#the-make-commands)
  - [To Start](#to-start)
    - [To create the VM's](#to-create-the-vms)
    - [To create the Cluster](#to-create-the-cluster)
    - [Outputs](#outputs)

## Getting Started

For now, only cluster in **GCP** can be created. The Kubernetes cluster is deployed using Ranchers RKE binary and is an up to date 1.19 cluster version. The deployment relies on GNU Make, Terraform, RKE and kubectl, as well as a valid GCP account.

### What You'll Need

1. [GNU Make install](https://www.gnu.org/software/make/). 
   - You can use [Chocolatey](https://chocolatey.org/install) for Windows users and I would recommend [Cygwin](http://www.cygwin.com/) to run linux commands.
2. [Terraform > 0.13](https://www.terraform.io/downloads.html) installed on your local machine.
3. [RKE binary](https://rancher.com/docs/rke/latest/en/installation/) upgraded to the latest version.
4. [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) of course.

## How the Makefile Works

The Makefile is setup to create the VM's for the RKE cluster to be deployed on top. The code is setup to deploy 3 VM instances (1 control, plane 2 workers) and output a `config.yml` file after setup. This `config.yml` file is what RKE uses to create the Kubernetes cluster. 

The deployment is broken into two parts. The VM creation, then the cluster creation. From inside the cluster_setup directory, you should see the following folders and files.

### Repository Structure

```shell
cluster_setup/
  └ Makefile
  └ cluster/      (Cluster configs generated here) 
  └ files/
    └ cluster.yml
    └ init.sh 
    └ auth.json   (YOUR GCP AUTH FILE)
    └ id_rsa.pub  (YOUR PUBLIC SSH KEY)
  └ state/        (Terraform state files can be found here)
  └ environment.tf
  └ main.tf
  └ network.tf
  └ provider.tf
  └ variables.tf
```

## GCP Setup

### Adding Credentials
Two files that are needed for the GCP setup are the Auth.json file and your public ssh key Both files need to be located in the `rancher_masterclass_demo/files/` directory and named;
  - `auth.json`
  - `id_rsa.pub`
This will allow access to your gcp project and set your public key in the created VM instances allowing for SSH access.

### The Make Commands
The Makefile currently has 7 **WORKING** commands for the cluster setup:

**make init**: Initialize Terraform and import the providers

**make validate**: Validate the modules and .tf files

**make plan**: equivalent to 'Terraform Plan' - will display the created resources

**make apply**: Will create the virtual machines for the cluster

**make rke-up**: Use **AFTER** the virtual machines have been created to bootstrap the cluster.

**make kube-config**: move kube_config_config to ~/.kube/config 

**make sockshop**: Bring up the sockshop application

**make rke-remove**: Remove the k8s cluster

**make destroy**: Destroy the VM resources (and save you money!!)


## To Start

Make sure that you have the necessary applications to run the commands and execute:

### To create the VM's
`make make init`
`make make plan`
`make make apply`

### To create the Cluster
`make make rke-up`

### Outputs

1. The state files will be written to `rancher_masterclass_demo/state/*` after running `make apply`.
2. The kubeconfig file be output to `rancher_masterclass_demo/cluster/kube_config.yml`
3. You will need to make to output `kube_config file` your new `rancher_masterclass_demo/.kube/config` file