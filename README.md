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
    "name": "BEb3lCtuQLO_cdwgnE0dsA",
    "reports": {
        "workflow-outputs": "http://192.168.20.20:7000/v1/reports/workflow-outputs?workflow_id=2",
        "workflow-status": "http://192.168.20.20:7000/v1/reports/workflow-status?workflow_id=2",
        "workflow-details": "http://192.168.20.20:7000/v1/reports/workflow-details?workflow_id=2"
    },
    "tasks": {
        "A": {
            "methods": [
                {
                    "name": "execute",
                    "service": "shell-command",
                    "parameters": {
                        "user": "vagrant",
                        "workingDirectory": "/home/vagrant/ptero/services/workflow/tests/scripts",
                        "environment": {
                            "PATH": "/home/vagrant/ptero/services/shell-command/.tox/dev-noenv/bin:/home/vagrant/bin:/home/vagrant/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/vagrant/bin:/home/vagrant/bin",
                            "VIRTUAL_ENV": "/home/vagrant/ptero/services/shell-command/.tox/dev-noenv"
                        },
                        "commandLine": [
                            "./echo_command"
                        ]
                    }
                }
            ]
        }
    },
    "links": [
        {
            "sourceProperty": "param",
            "source": "A",
            "destinationProperty": "out_a",
            "destination": "output connector"
        },
        {
            "sourceProperty": "in_a",
            "source": "input connector",
            "destinationProperty": "param",
            "destination": "A"
        }
    ],
    "inputs": {
        "in_a": "kittens"
    },
    "status": "new"
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

A more detailed report about the workflow is available by following the url at `reports.workflow-details`:

GET http://192.168.20.20:7000/v1/reports/workflow-details?workflow_id=1
```json
{
    "name": "Oubvo2Z2Si2RTib9dFugYA",
    "links": [
        {
            "sourceProperty": "param",
            "source": "A",
            "destinationProperty": "out_a",
            "destination": "output connector"
        },
        {
            "sourceProperty": "in_a",
            "source": "input connector",
            "destinationProperty": "param",
            "destination": "A"
        }
    ],
    "inputs": {
        "in_a": "kittens"
    },
    "status": "succeeded",
    "tasks": {
        "A": {
            "methods": [
                {
                    "name": "execute",
                    "executions": {
                        "0": {
                            "name": "A.execute.5",
                            "status_history": [
                                {
                                    "timestamp": "2015-05-10 00:15:28",
                                    "status": "new"
                                },
                                {
                                    "timestamp": "2015-05-10 00:15:29",
                                    "status": "scheduled"
                                },
                                {
                                    "timestamp": "2015-05-10 00:15:29",
                                    "status": "running"
                                },
                                {
                                    "timestamp": "2015-05-10 00:15:29",
                                    "status": "succeeded"
                                }
                            ],
                            "parent_color": null,
                            "begins": [
                                0
                            ],
                            "status": "succeeded",
                            "data": {
                                "stdout": "Found PTERO_WORKFLOW_EXECUTION_URL = http://localhost:7000/v1/executions/5\nFound execution_data from GET request = {u'begins': [0], u'status': u'running', u'name': u'A.execute.5', u'inputs': {u'param': u'kittens'}, u'color': 0, u'data': {u'petri_response_links': {u'created': u'http://localhost:6000/v1/nets/U18_8ydvTeCFlFGCKDFQQA/places/14/tokens?color=0&color_group=0'}, u'petri_response_links_for_shell_command': {u'failure': u'http://localhost:6000/v1/nets/U18_8ydvTeCFlFGCKDFQQA/places/34/tokens?color=0&color_group=0', u'success': u'http://localhost:6000/v1/nets/U18_8ydvTeCFlFGCKDFQQA/places/8/tokens?color=0&color_group=0'}, u'job_id': u'aae0e6bd-8f75-43d0-9808-92d608ee8454'}, u'colors': [0], u'outputs': {}, u'parent_color': None, u'status_history': [{u'status': u'new', u'timestamp': u'2015-05-10 00:15:28'}, {u'status': u'scheduled', u'timestamp': u'2015-05-10 00:15:29'}, {u'status': u'running', u'timestamp': u'2015-05-10 00:15:29'}]}\nSending PATCH to http://localhost:7000/v1/executions/5 with body: {'outputs': {u'param': u'kittens'}}\n",
                                "petri_response_links_for_shell_command": {
                                    "success": "http://localhost:6000/v1/nets/U18_8ydvTeCFlFGCKDFQQA/places/8/tokens?color=0&color_group=0",
                                    "failure": "http://localhost:6000/v1/nets/U18_8ydvTeCFlFGCKDFQQA/places/34/tokens?color=0&color_group=0"
                                },
                                "status": "succeeded",
                                "job_id": "aae0e6bd-8f75-43d0-9808-92d608ee8454",
                                "exitCode": 0,
                                "stderr": "",
                                "jobId": "aae0e6bd-8f75-43d0-9808-92d608ee8454",
                                "petri_response_links": {
                                    "created": "http://localhost:6000/v1/nets/U18_8ydvTeCFlFGCKDFQQA/places/14/tokens?color=0&color_group=0"
                                }
                            },
                            "outputs": {
                                "param": "kittens"
                            },
                            "inputs": {
                                "param": "kittens"
                            },
                            "color": 0,
                            "colors": [
                                0
                            ]
                        }
                    },
                    "service": "shell-command",
                    "parameters": {
                        "user": "vagrant",
                        "workingDirectory": "/home/vagrant/ptero/services/workflow/tests/scripts",
                        "environment": {
                            "PATH": "/home/vagrant/ptero/services/shell-command/.tox/dev-noenv/bin:/home/vagrant/bin:/home/vagrant/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/vagrant/bin:/home/vagrant/bin",
                            "VIRTUAL_ENV": "/home/vagrant/ptero/services/shell-command/.tox/dev-noenv"
                        },
                        "commandLine": [
                            "./echo_command"
                        ]
                    }
                }
            ],
            "executions": {
                "0": {
                    "name": "A.4",
                    "status_history": [
                        {
                            "timestamp": "2015-05-10 00:15:28",
                            "status": "new"
                        },
                        {
                            "timestamp": "2015-05-10 00:15:28",
                            "status": "scheduled"
                        },
                        {
                            "timestamp": "2015-05-10 00:15:28",
                            "status": "running"
                        },
                        {
                            "timestamp": "2015-05-10 00:15:29",
                            "status": "succeeded"
                        }
                    ],
                    "parent_color": null,
                    "begins": [
                        0
                    ],
                    "status": "succeeded",
                    "data": {
                        "petri_response_links": {
                            "created": "http://localhost:6000/v1/nets/U18_8ydvTeCFlFGCKDFQQA/places/48/tokens?color=0&color_group=0"
                        }
                    },
                    "outputs": {
                        "param": "kittens"
                    },
                    "inputs": {
                        "param": "kittens"
                    },
                    "color": 0,
                    "colors": [
                        0
                    ]
                }
            }
        }
    }
}
```

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
