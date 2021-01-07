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

    # Generate Api URL
    [String] getApiUrl() {
        if ($this.BaseFqdn) {
            $url = "https://" + $this.BaseFqdn + '/' + $this.UriPath
            return $url
        } else {
            return $null
        }
    }

    # create body string
    [string] createBodyString ([hashtable]$hashTable) {
        $i = 0
        $queryString = ""
        foreach ($hash in $hashTable.GetEnumerator()) {
            $i++
            $queryString += $hash.Name + "=" + $hash.Value
            if ($i -lt $HashTable.Count) {
                $queryString += "&"
            }
        }
        return $queryString
    }

    # Create query string
    <# [string] createQueryString ([hashtable]$hashTable) {
        $i = 0
        $queryString = "?"
        foreach ($hash in $hashTable.GetEnumerator()) {
            $i++
            $queryString += $hash.Name + "=" + [System.Web.HTTPUtility]::UrlEncode($hash.Value)
            if ($i -lt $HashTable.Count) {
                $queryString += "&"
            }
        }
        return $queryString
    } #>

    [string] createQueryString ([hashtable]$hashTable) {
        $QueryString = [System.Web.httputility]::ParseQueryString("")

        foreach ($Pair in $hashTable.GetEnumerator()) {
            $QueryString[$($Pair.Name)] = $($Pair.Value)
        }

        return ("?" + $QueryString.ToString())
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

    [psobject] invokeApiQuery([hashtable]$queryString, [string]$method) {

        # Wrike uses the query string as a body attribute, keeping this function as is for now and just using an empty querystring
        $url = $this.getApiUrl()

        # Populate Query/Url History
        $this.UrlHistory += $url
        $this.QueryHistory += $queryString

        # try query
        try {
            $QueryParams = @{}
            $QueryParams.Uri = $url
            switch ($method) {
                'PUT' {
                    $QueryParams.Uri += $this.createQueryString($queryString)
                }
                'POST' {
                    $QueryParams.Body = $this.createBodyString($queryString)
                }
            }
            <# if ($method -eq 'PUT') {
                $QueryParams.Uri += $this.createQueryString($queryString)
            } else {
                $QueryParams.Body = $this.createBodyString($queryString)
            } #>
            $QueryParams.Method = $method
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

    # with just a querystring
    [psobject] invokeApiQuery([hashtable]$queryString) {
        return $this.invokeApiQuery($queryString, 'GET')
    }

    # with just a method
    [psobject] invokeApiQuery([string]$method) {
        return $this.invokeApiQuery(@{}, $method)
    }

    # with no method or querystring specified
    [psobject] invokeApiQuery() {
        return $this.invokeApiQuery(@{}, 'GET')
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
