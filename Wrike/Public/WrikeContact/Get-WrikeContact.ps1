function Get-WrikeContact {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [string]$FirstName,

        [Parameter(Mandatory = $false)]
        [string]$LastName
    )

    BEGIN {
        $VerbosePrefix = "Get-WrikeContact:"
        $ReturnObject = @()

        $QueryParams = @{}
        $QueryParams.UriPath = 'contacts'
        $QueryParams.Query = @{}
    }

    PROCESS {
        $Query = Invoke-WrikeApiQuery @QueryParams

        foreach ($entry in $Query.data) {
            $New = New-WrikeContact
            $New.FullData = $entry

            $New.ContactId = $entry.id
            $New.FirstName = $entry.firstName
            $New.LastName = $entry.lastName
            $New.Type = $entry.type
            $New.EmailAddress = $entry.profiles.email
            $New.Title = $entry.title

            $ReturnObject += $New
        }
    }

    END {
        $global:WrikeServer.Contacts = $ReturnObject
        if ($FirstName -or $LastName) {
            $ReturnObject = $ReturnObject | Where-Object { $_.FirstName -eq $FirstName -and $_.LastName -eq $LastName }
        }
        $ReturnObject
    }
}
