param
(
    [Parameter(Mandatory=$True)]
    [string]
    $sqlServerName,

    [Parameter(Mandatory=$True)]
    [string]
    $sqlDatabaseName,
    
    [Parameter(Mandatory=$True)]
    [string]
    $apiAppName,

    [Parameter(Mandatory=$True)]
    [string]
    $accessToken,

    [Parameter(Mandatory=$True)]
    [string]
    $apiAppManagedIdentityPrincipalId
)

function FormatManagedIdentityPrincipalId {
    param (
        [string]
        $principalId
    )
    $byteArray = [Guid]::Parse($principalId).ToByteArray()
    $formatted = '0x'
    foreach ($byte in $byteArray) {
        if($byte -lt 16){
            $formatted += '0'
        }
        $formatted += [System.Convert]::ToString($byte, 16)
        
    }
    return $formatted
}

$managedIdentitySID = FormatManagedIdentityPrincipalId -principalId $apiAppManagedIdentityPrincipalId
Write-Host $managedIdentitySID

$dbConnectionString = "Data Source=$sqlServerName;Initial Catalog=$sqlDatabaseName;"
$dbConnection = New-Object System.Data.SqlClient.SqlConnection
$dbConnection.ConnectionString = $dbConnectionString
$dbConnection.add_InfoMessage([System.Data.SqlClient.SqlInfoMessageEventHandler] {
    param($sender, $event) 
    Write-Host $event.Message
})

$dbConnection.AccessToken = $accessToken
$dbConnection.Open()

$apiDbCommand = New-Object System.Data.SqlClient.SqlCommand
$apiDbCommand.CommandText = "DROP USER IF EXISTS [$apiAppName]
                             CREATE USER [$apiAppName] WITH SID=$managedIdentitySID, TYPE=E
                             ALTER ROLE db_datareader ADD MEMBER [$apiAppName]
                             ALTER ROLE db_datawriter ADD MEMBER [$apiAppName]"
                             
$apiDbCommand.Connection = $dbConnection
$apiDbCommand.ExecuteNonQuery() | Out-Null


