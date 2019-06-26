# stembuild-concourse
A collection to tasks that implement stembuild cli.


### Powershell Set Pipeline
```
fly -t con set-pipeline `
  --pipeline create-windows-stemcell `
  --config .\pipeline.yml `
  --load-vars-from .\vars.yml
```

### Bash Set Pipeline
```bash
fly -t con set-pipeline \
  --pipeline create-windows-stemcell \
  --config ./pipeline.yml \
  --load-vars-from ./vars.yml
```