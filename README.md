# Control Room Documentation

## TODO 
- check if nat gateway is working
- better security policies
- learn how to properly ssh into private subnets
- key management
- load balancer

## Cloud Architecture Description
1 VPC (/24)
- 1 public subnet (/25)
- 2 private subnets (2x /26)

2 security groups
- for public subnets
  - inbound
    - http (port 80)
    - ssh (port 22)
  - outbound
    - all traffic (0.0.0.0/0)
- for private subnets
  - inbound
    - api comms (todo)
    - ssh (port 22) from public subnet only
  - outbound
    - all traffic (0.0.0.0/0)

1 Internet Gateway
1 NAT Gateway

4 Route Tables
- 1 inherent from the VPC (provides connection within it)
- 1 associates public subnet to internet gateway
- 2 associate private subnets to nat gateway

4 EC2 Instances
- 2 in public subnet
- 1 in each private subnet


## References
[SSH Agent Forwarding](https://mistwire.com/ssh-agent-forwarding-in-aws/) to connect to instances in private subnets securely
