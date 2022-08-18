# Deploying

## Prerequisites

- [curl](https://curl.se/download.html)
- [pack](https://buildpacks.io/docs/tools/pack/) >= `0.23.0`
- [func](https://github.com/knative-sandbox/kn-plugin-func/blob/main/docs/installing_cli.md)


## Deployment

### Code iteration without OCI image
Use node directly: 
```
npm install
npm start
curl localhost:8080
```

### Run the image locally using Docker

Build your image and run it using Docker: 
```
pack build node-function --path . --buildpack paketo-buildpacks/nodejs --builder paketobuildpacks/builder:base
docker run -it --rm -p 8080:8080 node-function
curl localhost:8080
```

### Run the image using Tilt in a Kubernetes cluster

You may use [tilt](https://github.com/tilt-dev/tilt) `>v0.27.2` in combination with TAP's VS Code plugin to enable live development features including Application Live View and Live Update.

Update the `allow_k8s_contexts` line of the `Tiltfile` to indicate the Kubernetes context to use. 

Update the `Tiltfile` or set the SOURCE_IMAGE environment variable to indicate the registry path where TAP should store your image. 

```
export SOURCE_IMAGE=registry-fqdn/project/my-function-name
tilt up
tilt down
```

### Run the image using the tanzu cli

```
tanzu apps workload apply -f config/workload.yaml --source-image dev.registry.tanzu.vmware.com/jeltgroth/nodefunc
tanzu apps workload get node-function | grep http
```

## Testing

With our functions, you should see some HTML or sample text returned indicating a success.

### HTTP

After deploying your function, you can interact with the function by running:

```
curl -w'\n' localhost:8080/hire \
 -H "Content-Type: application/json" \
 -d '{"firstName":"John", "lastName":"Doe"}' -i
 ```

> Where `/hire` as a path invokes that specific function

### CloudEvents

If you'd like to test this function, you may use this CloudEvent saved as `cloudevent.json`:

```
{
    "specversion" : "1.0",
    "type" : "hire",
    "source" : "https://spring.io/",
    "id" : "A234-1234-1234",
    "datacontenttype" : "application/json",
    "data": {
        "firstName": "John",
        "lastName": "Doe"
    }
}
```

> NOTE: that you should change the contents of the CloudEvent you're testing against as you update the function.

After [deploying](https://github.com/vmware-tanzu/function-buildpacks-for-knative/blob/main/DEPLOYING.md) your function as an image, you can test with:

```
curl -X POST -H "Content-Type: application/cloudevents+json" -d @cloudevent.json http://localhost:8080
```

## TAP Deployment


## Deploying to Kubernetes as a TAP workload with Tanzu CLI

TAP can deploy workloads directly from a git repository.  Push your function's source code to a git repository and update `spec.source.git` in the `config/workload.yaml` file to point to that repository. 

Then, use this command: 

```
tanzu apps workload apply -f config/workload.yaml
```

## Interacting with Tanzu Application Platform

Determine the URL to use for the accessing the app by running:

```
tanzu apps workload get node-function
```

> NOTE: This depends on the TAP installation having DNS configured for the Knative ingress.

After deploying your function, you can interact with the function by using:

> NOTE: Replace the <URL> placeholder with the actual URL.

### for HTTP

```
curl -w'\n' <URL>/hire \
 -H "Content-Type: application/json" \
 -d '{"firstName":"John", "lastName":"Doe"}' -i
 ```

> Where `/hire` as a path invokes that specific function

### for CloudEvents

If you'd like to test this function, you may use this CloudEvent saved as `cloudevent.json`:

```
{
    "specversion" : "1.0",
    "type" : "hire",
    "source" : "https://spring.io/",
    "id" : "A234-1234-1234",
    "datacontenttype" : "application/json",
    "data": {
        "firstName": "John",
        "lastName": "Doe"
    }
}
```

> NOTE: that you should change the contents of the CloudEvent you're testing against as you update the function.

```
curl -X POST -H "Content-Type: application/cloudevents+json" -d @cloudevent.json <URL>
```
