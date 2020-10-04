$Blueprint_name = 'Az_PCI_DSS_BP'
$Blueprint_assignment_name = 'Assignment-Az_PCI_DSS_BP'
$storage_account = "demopcidss1004"
$subscription = "b7ef1cbb-30ce-4e1c-bb95-1324f2d207b8"

Write-Output "Installing Blueprint Module"
Install-Module -Name Az.Blueprint -Repository PSGallery -MinimumVersion 0.2.11 -AllowClobber -Force -Verbose
Import-Module -Name Az.Blueprint

$user = "$env:userid"
$pass = "$env:password"
$Pword = ConvertTo_SecureString -String $pass -AsPlainText -Force
$tenant = "$env:tenantid"
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $user,$Pword
Connect-AzAccount -Credential $Credential -Tenant $tenant -ServicePrincipal

cd .\Artifacts
$blueprint = New-AzBlueprint -Name $Blueprint_name -BlueprintFile "Blueprint.json" -SubscriptionID $subscription

New-AzBlueprintArtifact -Blueprint $blueprint -Name 'Allowed_locations_for_resource_groups' -ArtifactFile 'Allowed_locations_for_resource_groups.json'
New-AzBlueprintArtifact -Blueprint $blueprint -Name 'Allowed_locations' -ArtifactFile "Allowed_locations.json"
New-AzBlueprintArtifact -Blueprint $blueprint -Name 'controls_and_deploy' -ArtifactFile "controls_and_deploy.json"
New-AzBlueprintArtifact -Blueprint $blueprint -Name 'Deploy_auditing_on_SQL_servers' -ArtifactFile 'Deploy_auditing_on_SQL_servers.json'
New-AzBlueprintArtifact -Blueprint $blueprint -Name 'Deploy_SQL_DB_transparent_data_encryption' -ArtifactFile 'Deploy_SQL_DB_transparent_data_encryption.json'
New-AzBlueprintArtifact -Blueprint $blueprint -Name 'Deploy_Threat_Detection_on_SQL_servers' -ArtifactFile 'Deploy_Threat_Detection_on_SQL_servers.json'
New-AzBlueprintArtifact -Blueprint $blueprint -Name 'Require_encryption_on_Data_lake_store_accounts' -ArtifactFile 'Require_encryption_on_Data_lake_store_accounts.json'

Publish-AzBlueprint -Blueprint $blueprint -Version 1.1

New-AzBlueprintAssignment -Blueprint $blueprint -Name $Blueprint_assignment_name -Location "East US" -SubscriptionId $subscription -Parameter @{deployAuditingonSqlservers_storageAccountsResourceGroup=$storage_account}