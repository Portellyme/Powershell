#For non-core versions of PowerShell
Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
             ServicePoint srvPoint, X509Certificate certificate,
             WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = [TrustAllCertsPolicy]::new()


#For core versions
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$True}