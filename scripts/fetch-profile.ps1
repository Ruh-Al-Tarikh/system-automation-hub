[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidUsingWriteHost", "")]
param (
    [Parameter(Mandatory=$false)]
    [string]$Username = "octocat"
)

Write-Host "🔍 Fetching GitHub profile for: $Username..." -ForegroundColor Cyan

try {
    $uri = "https://api.github.com/users/$Username"
    $profile = Invoke-RestMethod -Uri $uri -Method Get

    Write-Host "`n👤 Profile Information:" -ForegroundColor Green
    Write-Host "---------------------------"
    Write-Host "Login:      $($profile.login)"
    Write-Host "Name:       $($profile.name)"
    Write-Host "Bio:        $($profile.bio)"
    Write-Host "Repos:      $($profile.public_repos)"
    Write-Host "Followers:  $($profile.followers)"
    Write-Host "Following:  $($profile.following)"
    Write-Host "URL:        $($profile.html_url)"
    Write-Host "---------------------------"
} catch {
    Write-Host "❌ Error: Could not fetch profile for '$Username'. Details: $($_.Exception.Message)" -ForegroundColor Red
}
