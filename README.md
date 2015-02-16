# PTero Workflow Management System

## Getting Started
To launch a virtual machine running the PTero services, you need to install
[VirtualBox](https://www.virtualbox.org/) and
[Vagrant](https://www.vagrantup.com/) using the installation instructions for
your platform.

To experiment with PTero, then run:

```bash
git clone http://github.com/genome/ptero.git
cd ptero
```

The `ptero init` command will setup all of the PTero submodules:

```bash
./ptero init
```

The `vagrant up` command will spin-up a guest virtual machine, running Ubuntu
14.04 (trusty).  Vagrant then launches a complete set of PTero services on the
guest, which can be accessed from your host machine.

```bash
vagrant up
```

### Submitting a Workflow
The PTero services are now ready to accept HTTP requests.  Using an HTTP
client, such as Postman, POST the following json workflow document to
`http://192.168.20.20:7000/v1/workflows`.  Don't forget to include the
`Content-Type: application/json` header:

```json
{  
   "tasks":{  
      "A":{  
         "methods":[  
            {  
               "name":"execute",
               "service":"shell-command",
               "parameters":{  
                  "commandLine":[  
                     "./echo_command"
                  ],
                  "user":"vagrant",
                  "workingDirectory":"/home/vagrant/ptero/services/workflow/tests/scripts",
                  "environment":{  
                     "VIRTUAL_ENV":"/home/vagrant/ptero/services/shell-command/.tox/dev-noenv",
                     "PATH":"/home/vagrant/ptero/services/shell-command/.tox/dev-noenv/bin:/home/vagrant/bin:/home/vagrant/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/vagrant/bin:/home/vagrant/bin"
                  }
               }
            }
         ]
      }
   },
   "links":[  
      {  
         "source":"input connector",
         "destination":"A",
         "sourceProperty":"in_a",
         "destinationProperty":"param"
      },
      {  
         "source":"A",
         "destination":"output connector",
         "sourceProperty":"param",
         "destinationProperty":"out_a"
      }
   ],
   "inputs":{  
      "in_a":"kittens"
   }
}
```

You should expect a 201 response with an empty body.  The `Location` header
will be set to a URL which you can GET to see the POSTed workflow.

### Checking the Workflow Status
Once the workflow has finished, the `status` key will be present in the
response body.

GET http://192.168.20.20:7000/v1/workflows/1
```json
{
    "links": [
        {
            "sourceProperty": "param",
            "destination": "output connector",
            "destinationProperty": "out_a",
            "source": "A"
        },
        {
            "sourceProperty": "in_a",
            "destination": "A",
            "destinationProperty": "param",
            "source": "input connector"
        }
    ],
    "reports": {
        "workflow-outputs": "http://192.168.20.20:7000/v1/reports/workflow-outputs?workflow_id=1"
    },
    "tasks": {
        "A": {
            "name": "A",
            "type": "method-list"
        }
    },
    "status": "success",
    "inputs": {
        "in_a": "kittens"
    }
}
```

### Getting Workflow Outputs
To access the outputs of the completed workflow perform a GET on the URL listed
under the reports.workflow-outputs path.  

GET http://192.168.20.20:7000/v1/reports/workflow-outputs?workflow_id=1
```json
{
    "outputs": {
        "out_a": "kittens"
    }
}
```

For now, the `workflow-outputs` report is the only report.  Additional reports
are under develoment.

## Contributing
If you want to get started developing PTero, then you should also fork all the
submodule repositories and specify your [GitHub](https://github.com/) username
before running:

```bash
sudo apt-get update
sudo apt-get install curl
./ptero init -u <username>
```

This will clone all needed submodules and setup remotes for your forks of those
repos.  It will not directly fork those repos on github.
