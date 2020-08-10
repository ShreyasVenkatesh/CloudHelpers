## Bulk Secret Export ##
## Description : This is a power shell script to export selected Secrets from a given Source Azure Key Vault to Azure Destination Key Vault.
## $sourceKeyVault : Name of Source Key Vault
## $destinationKeyVault : Name of Destination Key Vault
## $secretsList : List of secrets for ex: secret1,secret2,secret3

Param(
[Parameter(Mandatory)]
[string]$sourceKeyVault,
[Parameter(Mandatory)]
[string]$destinationKeyVault,
[Parameter(Mandatory)]
[string[]]$secretsList
)

#Display Secrets in New Key Vault
Write-Host ' Checking If secrets are present in source Key Vault :' $sourceKeyVault ' to be moved to destination Key Vault :' $destinationKeyVault
$SecretsFound = $false
#Loop over secrets to be moved to destination key vault
foreach($currentSecret in $secretsList)
{
    $sourceSecretDetails = Get-AzKeyVaultSecret -VaultName $sourceKeyVault -Name $currentSecret
    if($sourceSecretDetails)
    {
        $SecretName = $sourceSecretDetails.Name
        $secureString = ConvertTo-SecureString -String $sourceSecretDetails.SecretValueText -AsPlainText -Force  
        Write-Host 'Found Secret in soruce Key Vault :' $sourceKeyVault 'Secret Name =' $SecretName ': Value =' $sourceSecretDetails.SecretValueText
        Set-AzKeyVaultSecret -VaultName $destinationKeyVault -Name $SecretName -SecretValue $secureString
        Write-Host 'Successfully added Secret in destination Key Vault :' $destinationKeyVault' Secret Name =' $SecretName
        $SecretsFound = $true
    }
}
if(!$SecretsFound)
{
    Write-Host 'No Secrets in Source Key Vault'
}
