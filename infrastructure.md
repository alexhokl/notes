### Nick Craver

- [Stack Overflow: The Architecture - 2016 Edition](https://nickcraver.com/blog/2016/02/17/stack-overflow-the-architecture-2016-edition/)
- [Stack Overflow: The Hardware - 2016 Edition](https://nickcraver.com/blog/2016/03/29/stack-overflow-the-hardware-2016-edition/)
- [Stack Overflow: How We Do Deployment - 2016 Edition](https://nickcraver.com/blog/2016/05/03/stack-overflow-how-we-do-deployment-2016-edition/)
- [HTTPS on Stack Overflow: The End of a Long Road](https://nickcraver.com/blog/2017/05/22/https-on-stack-overflow/)

### Libraries

- [Terraform](https://www.terraform.io/)
  - in Hashicorp Configuration Language (HCL)
  - storing infrastructure state by local files
- [Pulumi](https://pulumi.io/)
  - in most of the popular languages
  - storing infrastructure state on the cloud https://app.pulumi.com

### Monitoring

Notes from talk *Monitoring and Debugging Containerized Systems at Scale* by
Jaana Dogan

- discovering critical paths of application
- making it reliable then fast
- making it debuggable
- `docekr run --add-host=somehost:192.168.1.2 -d container-name`
- Use timeline or trace list from OpenCensus
- OpenCensus is not a replacement of existing instrumentation frameworks or
    systems
- OpenCensus is trying to provide a more standardised way of logging data

##### Docker Swarm

- One of the possible combinations of tools is 
  - Fluentd
    - as a collector
    - converts strings into JSON objects
  - influxdb
    - as a storage
  - Grafrana
    - as presentation

