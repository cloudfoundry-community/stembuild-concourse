$ErrorActionPreference = "Stop"

$prefix = "C:\Users\ddieruf\Source\stembuild-concourse"
$rootFolder = "minio/stemcell-concourse"
$versionfolder = "$rootFolder/0.0.1"

go build -o $prefix\p-automator $prefix\cmd\p-automator\main.go

New-Item -Force -Path "$env:TEMP\tmp_tasks","$env:TEMP\tmp_tasks\tasks" -ItemType Directory
Copy-Item -Recurse -Force $prefix\tasks\* $env:TEMP\tmp_tasks\tasks
Compress-Archive -Force -CompressionLevel Fastest -Path $env:TEMP\tmp_tasks\* -DestinationPath $prefix\tasks.zip
Remove-Item $env:TEMP\tmp_tasks -Recurse

mc stat $versionfolder/LGPO.zip
if ($LASTEXITCODE -ne 0){
  mc cp C:\tmp\LGPO.zip $versionfolder/LGPO.zip
}

mc stat $versionfolder/tasks.zip
if ($LASTEXITCODE -eq 0){
  mc rm --force $versionfolder/tasks.zip
}
mc cp $prefix\tasks.zip $versionfolder/tasks.zip
