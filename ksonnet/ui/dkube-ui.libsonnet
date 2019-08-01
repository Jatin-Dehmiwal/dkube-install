{
  all(params):: [
    $.parts(params.namespace).deploy(params.tag , params.dkubeUIImage, params.dkubeDockerSecret),
  ],

  parts(namespace):: {
    deploy(tag,dkubeUIImage, dkubeDockerSecret):: {
      "apiVersion": "extensions/v1beta1", 
      "kind": "Deployment", 
      "metadata": {
        "labels": {
          "app": "dkube-ui"
        }, 
        "name": "dkube-ui-" + tag, 
        "namespace": namespace
      }, 
      "spec": {
        "selector": {
          "matchLabels": {
            "app": "dkube-ui"
          }
        }, 
        "template": {
          "metadata": {
            "labels": {
              "app": "dkube-ui"
            }
          }, 
          "spec": {
            "imagePullSecrets": [
              {
                "name": dkubeDockerSecret
              }
            ],
            "tolerations": [
              {
                "operator": "Exists"
              },
            ],
            "containers": [
              {
                "image": dkubeUIImage, 
                "imagePullPolicy": "IfNotPresent", 
                "name": "ui", 
                "ports": [
                  {
                    "containerPort": 3000, 
                    "name": "ui", 
                    "protocol": "TCP"
                  }
                ]
              }
            ],
            "dnsConfig": {
                "options": [
                    {
                        "name": "single-request-reopen"
                    },
                    {
                        "name": "timeout",
                        "value": "30"
                    }
                ]
            },
          }
        }
      }
    }  // deploy
  },  // parts
}
