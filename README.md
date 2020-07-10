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

#### Add AWS Keys

Add you access_key and secret_access_key in `~/.aws/credentials`, if you do not have one, [click here](https://aws.amazon.com/pt/premiumsupport/knowledge-center/create-access-key/)

```
[influx-aws]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

#### Define the passwords

In the file `ansible/playbooks/secrets.yaml` fill the passwords of the users

``` yaml
---
  users:
    admin_influx: pass_influx (Admin User in influxDB)
    grafana: pass_grafana (Read Only user in InfluxDB for datasource)
    telegraf: pass_telegraf (Write Only user in InfluxDB - To agent send metrics)
    grafana-admin: pass_grafana_admin (Admin user in Grafana)
    grafana-user: admin (Do not change this - Admin user name in Grafana)
```

#### VPC and Subnets

Create or use your default public VPC and Subnet ID of AWS to fill the variables in `terraform/variables/variables.tf`

```
...
variable "VPC" {
  default = "vpc-id"
}

variable "SUBNET"{
  default = "subnet-id"
}
```

#### Terraform

In terraform folder, run:

``` bash
teraform init
terraform apply --auto-approve
```

### Installing the agents

In order to receive metrics of other hosts, you will need to [install the agent](https://docs.influxdata.com/telegraf/v1.14/introduction/installation/), you can find an example of configuration in `examples` folder. Remember to change output telegraf password:

```
...
[[outputs.influxdb]]
  urls = ["http://0.0.0.0:8086"]
  database = "dados_pc"
  username = "telegraf"
  password = "Telegraf pass defined in secrets.yaml" # << Here
  skip_database_creation = true
...
```

#### Tips

If you want to collect metrics of others hosts, remember to change URLs in `[[outputs.influxdb]]` too!

### Accessing

After the end of terraform you will receive an IP, use it to access your Grafana. Your grafana user will be `admin` and password is the one defined in `secrets.yaml` as `grafana-admin`

![Output](./miscs/output.png)