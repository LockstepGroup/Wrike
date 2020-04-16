Class WrikeServer {
    [string]$BaseFqdn = 'www.wrike.com/api/v4'
    [string]$UriPath
    [string]$ApiToken

    [array]$CustomFields
    [array]$Contacts

    #region Tracking
    ########################################################################

    hidden [bool]$Connected
    [array]$UrlHistory
    [array]$RawQueryResultHistory
    [array]$QueryHistory
    $LastError
    $LastResult

    ########################################################################
    #endregion Tracking

    # Create query string
    static [string] createQueryString ([hashtable]$hashTable) {
        $i = 0
        $queryString = "?"
        foreach ($hash in $hashTable.GetEnumerator()) {
            $i++
            $queryString += $hash.Name + "=" + $hash.Value
            if ($i -lt $HashTable.Count) {
                $queryString += "&"
            }
        }
        return $queryString
    }

    # Generate Api URL
    [String] getApiUrl([string]$formattedQueryString) {
        if ($this.BaseFqdn) {
            $url = "https://" + $this.BaseFqdn + '/' + $this.UriPath + $formattedQueryString
            return $url
        } else {
            return $null
        }
    }

    #region processQueryResult
    ########################################################################

    [psobject] processQueryResult ($unprocessedResult) {
        return $unprocessedResult
    }

    ########################################################################
    #endregion processQueryResult

    #region invokeApiQuery
    ########################################################################

    [psobject] invokeApiQuery([hashtable]$queryString) {

        # ITG uses the query string as a body attribute, keeping this function as is for now and just using an empty querystring
        $url = $this.getApiUrl('')

        # Populate Query/Url History
        $this.UrlHistory += $url
        $this.QueryHistory += $queryString

        # try query
        try {
            $QueryParams = @{}
            $QueryParams.Uri = $url
            #$QueryParams.UseBasicParsing = $true
            $QueryParams.Body = $queryString
            $QueryParams.Headers = @{
                'Authorization' = "bearer $($this.ApiToken)"
            }

            $rawResult = Invoke-RestMethod @QueryParams
        } catch {
            Throw $_
        }

        $this.RawQueryResultHistory += $rawResult
        $this.LastResult = $rawResult

        $proccessedResult = $this.processQueryResult($rawResult)

        return $proccessedResult
    }

    ########################################################################
    #endregion invokeApiQuery

    #region Initiators
    ########################################################################

    # empty initiator
    WrikeServer() {
    }

    ########################################################################
    #endregion Initiators
}
