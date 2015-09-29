# PTero Workflow Management System

## Getting Started
Follow [this guide](https://github.com/genome/ptero/wiki/Getting-Started) to setup a vm with the ptero services running in it (don't worry it's short).

### Submitting a Workflow
The PTero services are now ready to accept HTTP requests.  Using an HTTP
client, such as Postman, POST the following json workflow document to
`http://192.168.20.20:7000/v1/workflows`.  Don't forget to include the
`Content-Type: application/json` header:

```json
{
    "inputs": {},
    "links": [
        {
            "destination": "output connector",
            "source": "Say Hello"
        },
        {
            "destination": "Say Hello",
            "source": "input connector"
        }
    ],
    "tasks": {
        "Say Hello": {
            "methods": [
                {
                    "name": "print hello",
                    "parameters": {
                        "commandLine": [
                            "bash",
                            "-c",
                            "echo hello 1>&2; echo world!"
                        ],
                        "environment": {},
                        "user": "vagrant",
                        "workingDirectory": "/home/vagrant/ptero/services/workflow/tests/scripts"
                    },
                    "service": "job",
                    "serviceUrl": "http://localhost:5000/v1"
                }
            ]
        }
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
  "name": "M5ZD6QXeTC6gcTp5x-7tBQ",
  "reports": {
    "workflow-details": "http://localhost:7000/v1/reports/workflow-details?workflow_id=1",
    "workflow-executions": "http://localhost:7000/v1/reports/workflow-executions?workflow_id=1",
    "workflow-outputs": "http://localhost:7000/v1/reports/workflow-outputs?workflow_id=1",
    "workflow-skeleton": "http://localhost:7000/v1/reports/workflow-skeleton?workflow_id=1",
    "workflow-status": "http://localhost:7000/v1/reports/workflow-status?workflow_id=1",
    "workflow-submission-data": "http://localhost:7000/v1/reports/workflow-submission-data?workflow_id=1"
  },
  "status": "succeeded"
}
```

### Getting Workflow Outputs
To access the outputs of the completed workflow perform a GET on the URL listed
under the `reports.workflow-outputs` path.  

GET http://192.168.20.20:7000/v1/reports/workflow-outputs?workflow_id=1
```json
{
    "outputs": null
}
```

A more detailed report about the workflow is available by following the url at `reports.workflow-details`:

GET http://192.168.20.20:7000/v1/reports/workflow-details?workflow_id=1
```json
{
    "inputs": {},
    "links": [
        {
            "destination": "output connector",
            "source": "Say Hello"
        },
        {
            "destination": "Say Hello",
            "source": "input connector"
        }
    ],
    "name": "M5ZD6QXeTC6gcTp5x-7tBQ",
    "status": "succeeded",
    "tasks": {
        "Say Hello": {
            "executions": {
                "0": {
                    "begins": [
                        0
                    ],
                    "color": 0,
                    "colors": [
                        0
                    ],
                    "data": {
                        "petri_response_links": {
                            "created": "http://localhost:6001/v1/nets/4NqFjgmmRFGYwcm0cuHkAg/places/21/tokens?color=0&color_group=0"
                        }
                    },
                    "name": "Say Hello.4",
                    "parent_color": null,
                    "status": "succeeded",
                    "status_history": [
                        {
                            "status": "running",
                            "timestamp": "2015-09-26 01:48:26.003525+00:00"
                        },
                        {
                            "status": "scheduled",
                            "timestamp": "2015-09-26 01:48:26.003525+00:00"
                        },
                        {
                            "status": "new",
                            "timestamp": "2015-09-26 01:48:26.003525+00:00"
                        },
                        {
                            "status": "succeeded",
                            "timestamp": "2015-09-26 01:48:27.633535+00:00"
                        }
                    ]
                }
            },
            "methods": [
                {
                    "executions": {
                        "0": {
                            "begins": [
                                0
                            ],
                            "color": 0,
                            "colors": [
                                0
                            ],
                            "data": {
                                "exitCode": 0,
                                "jobId": "f70838fd-87c7-45ad-9ae1-bdd5a2e6226a",
                                "job_id": "f70838fd-87c7-45ad-9ae1-bdd5a2e6226a",
                                "petri_response_links": {
                                    "created": "http://localhost:6001/v1/nets/4NqFjgmmRFGYwcm0cuHkAg/places/40/tokens?color=0&color_group=0"
                                },
                                "petri_response_links_for_job": {
                                    "failure": "http://localhost:6001/v1/nets/4NqFjgmmRFGYwcm0cuHkAg/places/49/tokens?color=0&color_group=0",
                                    "success": "http://localhost:6001/v1/nets/4NqFjgmmRFGYwcm0cuHkAg/places/15/tokens?color=0&color_group=0"
                                },
                                "status": "succeeded",
                                "stderr": "hello\n",
                                "stdout": "world!\n"
                            },
                            "name": "Say Hello.print hello.5",
                            "parent_color": null,
                            "status": "succeeded",
                            "status_history": [
                                {
                                    "status": "new",
                                    "timestamp": "2015-09-26 01:48:26.099681+00:00"
                                },
                                {
                                    "status": "scheduled",
                                    "timestamp": "2015-09-26 01:48:26.201118+00:00"
                                },
                                {
                                    "status": "running",
                                    "timestamp": "2015-09-26 01:48:27.422265+00:00"
                                },
                                {
                                    "status": "succeeded",
                                    "timestamp": "2015-09-26 01:48:27.463615+00:00"
                                }
                            ]
                        }
                    },
                    "name": "print hello",
                    "parameters": {
                        "commandLine": [
                            "bash",
                            "-c",
                            "echo hello 1>&2; echo world!"
                        ],
                        "environment": {},
                        "user": "vagrant",
                        "workingDirectory": "/home/vagrant/ptero/services/workflow/tests/scripts"
                    },
                    "service": "job",
                    "serviceUrl": "http://localhost:5000/v1"
                }
            ]
        }
    }
}
```

## Contributing
We accept github pull-requests, so if you want to get started developing PTero,
then you should also fork all the submodule repositories and specify your 
[GitHub](https://github.com/) username before running:

```bash
sudo apt-get update
sudo apt-get install curl
./ptero init -u <username>
```

This will clone all needed submodules and setup remotes for your forks of those
repos.  It will not directly fork those repos on github.
