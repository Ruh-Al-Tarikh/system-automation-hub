# =============================================
# System Automation Hub - Webhook Listener
# =============================================
$port = 9000
$endpoint = "http://localhost:$port/"

# Ensure we don't try to start another listener if one is already running in this session
if ($null -ne $listener) {
    try { $listener.Stop() } catch { Write-Verbose "Listener already stopped." }
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($endpoint)

try {
    $listener.Start()
    Write-Host "🚀 Listener started on $endpoint"
    Write-Host "Press Ctrl+C to stop.`n"

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Received $($request.HttpMethod) request from $($request.RemoteEndPoint)"

        # Read body if available
        if ($request.HasEntityBody) {
            $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
            $body = $reader.ReadToEnd()
            Write-Host "Payload: $body"
        }

        # Simple response
        $buffer = [System.Text.Encoding]::UTF8.GetBytes("System Automation Hub: Event Received")
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.Close()
    }
} catch {
    Write-Host "❌ Error: $($_.Exception.Message)"
} finally {
    if ($null -ne $listener) {
        $listener.Stop()
    }
}
