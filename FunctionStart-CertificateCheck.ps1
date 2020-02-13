function Start-CertificateCheck {
 
    if ($host.version.Major -eq '5') {
        $0Days = 0
        $90days = 90
        $timeoutMilliseconds = 10000
        $urls = @(
            "https://dskalfjds.com"
            "https://espn.com",
            "https://nfl.com"
        )
 
        #disabling the cert validation check. This is what makes this whole thing work with invalid certs...
        [Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
        foreach ($url in $urls) {
            $req = [Net.HttpWebRequest]::Create($url)
            $req.Timeout = $timeoutMilliseconds
 
            try {
                $req.GetResponse() | Out-Null
            }
            catch {
            }
 
            [datetime]$expiration = $req.ServicePoint.Certificate.GetExpirationDateString()
            [int]$certExpiresIn = ($expiration - $(Get-Date)).Days
            $certName = $req.ServicePoint.Certificate.GetName()
            #$certPublicKeyString = $req.ServicePoint.Certificate.GetPublicKeyString()
            #$certSerialNumber = $req.ServicePoint.Certificate.GetSerialNumberString()
            #$certThumbprint = $req.ServicePoint.Certificate.GetCertHashString()
            $certEffectiveDate = $req.ServicePoint.Certificate.GetEffectiveDateString()
            $certIssuer = $req.ServicePoint.Certificate.GetIssuerName()
 
            if ($certExpiresIn -gt $90days) {
                Write-Host "Cert for site $url expires in $certExpiresIn days [on $expiration]" -ForegroundColor Green
            }
 
            elseif ($certExpiresIn -gt $0days) {
                Write-Host "Cert for site $url expires in $certExpiresIn days [on $expiration]" -ForegroundColor Yellow
            }
 
            else {
                Write-Host "Cert for site $url expired $certExpiresIn days agon [on $expiration]" -ForegroundColor Red
            }
 
           
            [pscustomobject]@{
                URL             = $url
                CertificateName = $certName
                IssueDate       = $CertEffectiveDate
                ExpirationDate  = $expiration
                ExpirationDays  = $certExpiresIn
                Issuer          = $certIssuer
            }
 
            Remove-Variable req
            Remove-Variable expiration
            Remove-Variable certExpiresIn
        }
    }
 
    else {
        Write-Host "This Functions only works in powershell version 5!" -ForegroundColor Red
    }
}
