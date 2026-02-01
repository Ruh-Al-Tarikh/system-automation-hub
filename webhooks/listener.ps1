param([int]$Port = 9000)

Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://+:/")
$listener.Start()

Write-Host "Webhook listening on port ..."

while ($true) {
    $context = $listener.GetContext()
    $request = $context.Request
    $reader = New-Object IO.StreamReader($request.InputStream)
    $payload = $reader.ReadToEnd()

    Write-Host "Webhook received:" -ForegroundColor Green
    Write-Host $payload

    $context.Response.StatusCode = 200
    $context.Response.Close()
}
