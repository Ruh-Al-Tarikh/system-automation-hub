# =============================================
# System Automation Hub Launcher - Clean Version
# =============================================
$port = 9000
$listenerScript = ".\webhooks\listener.ps1"

Write-Host "🚀 Starting System Automation Hub..."

# --- Start Listener in the same window ---
Write-Host "🔐 Starting listener..."
Start-Job -ScriptBlock { pwsh .\webhooks\listener.ps1 }

# --- Start ngrok in a visible window ---
Write-Host "🌐 Starting ngrok..."
Start-Process ngrok -ArgumentList "http $port" -WindowStyle Normal

# --- Wait a few seconds for ngrok ---
Start-Sleep -Seconds 5

# --- Try to fetch ngrok public URL ---
try {
    $ngrokApi = Invoke-RestMethod http://127.0.0.1:4040/api/tunnels
    $publicUrl = $ngrokApi.tunnels[0].public_url
    Write-Host "🌐 ngrok tunnel started: $publicUrl"
    # Optional: copy to clipboard
    $publicUrl | Set-Clipboard
    Write-Host "📋 URL copied to clipboard!"
} catch {
    Write-Host "⚠️ Could not fetch ngrok URL automatically. Open http://127.0.0.1:4040 for details."
}

Write-Host "`n✅ All set! Add this webhook URL to GitHub and push a commit to see logs."
