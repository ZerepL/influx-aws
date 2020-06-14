# Home monitoring system

A lab monitoring system implemented with Ubuntu using InfluxDB, Grafana and Telegraf.

![Grafana](./miscs/grafana.png)

## Why Ubuntu

- Has free tier in AWS

## How to deploy

### Requirements

- [AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Terraform](https://www.terraform.io/downloads.html)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### Running 
- Add you access_key and secret_access_key in ~/.aws/credentials as `influx-aws`
- Run:
 
``` bash
teraform init
terraform apply --auto-approve
```
