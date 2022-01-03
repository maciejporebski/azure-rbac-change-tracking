$basePath = "roles"
Write-Host "Checking if base role directory '$($basePath)' exists"
if (!(Test-Path -Path $basePath)) {
    Write-Host "Creating base role directory '$($basePath)'"
    New-Item -Name $basePath -ItemType "directory"
}

$toc = "# Azure RBAC Roles - Change Tracking`n"
$toc += "This repository documents changes to Azure RBAC roles, by periodically fetching the definitions of the roles using Get-AzRoleDefinition and committing the results to this repository.`n`n"
$toc += "| Role Name | Role Id |`n| --- | --- |`n"

Write-Host "Fetching RBAC Role Definitions"
$roleDefinitions = (Get-AzRoleDefinition | Sort-Object -Property 'Name')
Write-Host "Retrieved $($roleDefinitions.Count) roles"

foreach ($roleDefinition in $roleDefinitions) {
    Write-Host "Processing role '$($roleDefinition.Name)' with Id '$($roleDefinition.Id)'"
    $filePath = "$($basePath)/$($roleDefinition.Id).json"
    $roleJson = $roleDefinition | ConvertTo-Json
    $roleJson | Out-File -FilePath $filePath
    $toc += "| [$($roleDefinition.Name)]($($filePath)) | [$($roleDefinition.Id)]($($filePath)) |`n"
}

$toc += "`n`n"

Write-Host "Outputting README file"
$toc | Out-File -FilePath "README.md"