param(
    [int]$Port = 9000,
    [string]$Secret = "SYSTEM_AUTOMATION_SUPER_SECRET_2026"
)

Add-Type -AssemblyName System.Net.HttpListener
Add-Type -AssemblyName System.Security.Cryptography
Add-Type -AssemblyName System.Text

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:$Port/")
$listener.Start()

Write-Host "🔐 Secure webhook listening on port $Port" -ForegroundColor Cyan

while ($true) {
    $context = $listener.GetContext()
    $request = $context.Request

    $reader = New-Object IO.StreamReader($request.InputStream)
    $payload = $reader.ReadToEnd()

    $signature = $request.Headers["X-Hub-Signature-256"]

    $hmac = New-Object System.Security.Cryptography.HMACSHA256
    $hmac.Key = [Text.Encoding]::UTF8.GetBytes($Secret)
    $hash = $hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($payload))
    $expected = "sha256=" + ([BitConverter]::ToString($hash) -replace "-", "").ToLower()

    if ($signature -ne $expected) {
        Write-Host "❌ Invalid signature. Request rejected." -ForegroundColor Red
        $context.Response.StatusCode = 401
        $context.Response.Close()
        continue
    }

    Write-Host "✅ Valid webhook received" -ForegroundColor Green
    Write-Host $payload

    # 🔥 PLACE AUTOMATION HERE
    pwsh scripts\init.ps1

    $context.Response.StatusCode = 200
    $context.Response.Close()
}
