$session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
$session.UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36 Edg/135.0.0.0"
$session.Cookies.Add((New-Object System.Net.Cookie("intercom-device-id-", 
$session.Cookies.Add((New-Object System.Net.Cookie("iterableEndUserId", 
$session.Cookies.Add((New-Object System.Net.Cookie("_ga", 
$session.Cookies.Add((New-Object System.Net.Cookie("rskxRunCookie", 
$session.Cookies.Add((New-Object System.Net.Cookie("rCookie", 
$session.Cookies.Add((New-Object System.Net.Cookie("hubspotutk", 
$session.Cookies.Add((New-Object System.Net.Cookie("lastRskxRun", 
$session.Cookies.Add((New-Object System.Net.Cookie("__hstc", 
$session.Cookies.Add((New-Object System.Net.Cookie("", 
$session.Cookies.Add((New-Object System.Net.Cookie("intercom-id-", 
$session.Cookies.Add((New-Object System.Net.Cookie("toast-session", 
$session.Cookies.Add((New-Object System.Net.Cookie("cf_clearance", 
$session.Cookies.Add((New-Object System.Net.Cookie("intercom-session-", 
$session.Cookies.Add((New-Object System.Net.Cookie("_iidt", 
$session.Cookies.Add((New-Object System.Net.Cookie("_vid_t", 
$session.Cookies.Add((New-Object System.Net.Cookie("__session", 
$session.Cookies.Add((New-Object System.Net.Cookie("_dd_s", 

$vouchersResponse = Invoke-WebRequest -UseBasicParsing -Uri "https://fluz.app/vouchers?status=AVAILABLE%2CPENDING%2CEXPIRED%2CUSED&_data=routes%2Fvouchers%2F_route" `
  -WebSession $session `
  -Headers @{
  "authority"                   = "fluz.app"
  "method"                      = "GET"
  "path"                        = "/vouchers?status=AVAILABLE%2CPENDING%2CEXPIRED%2CUSED&_data=routes%2Fvouchers%2F_route"
  "scheme"                      = "https"
  "accept"                      = "*/*"
  "accept-encoding"             = ""
  "accept-language"             = "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6,zh-HK;q=0.5"
  "priority"                    = "u=1, i"
  "referer"                     = "https://fluz.app/stores"
  "sec-ch-ua"                   = "`"Microsoft Edge`";v=`"135`", `"Not-A.Brand`";v=`"8`", `"Chromium`";v=`"135`""
  "sec-ch-ua-mobile"            = "?0"
  "sec-ch-ua-platform"          = "`"Windows`""
  "sec-fetch-dest"              = "empty"
  "sec-fetch-mode"              = "cors"
  "sec-fetch-site"              = "same-origin"
}


$vouchers = $vouchersResponse.Content | ConvertFrom-Json

$Count = 20
foreach ($voucher in $vouchers.vouchers) 
{
  if ($voucher.cashback_voucher_status -ne "AVAILABLE") {
    continue
  }

  if ($Count -eq 0) {
    break
  }
  $Count = $Count - 1
  
  Write-Host ${voucher.cashback_voucher_id}
  <##>
  Invoke-WebRequest -UseBasicParsing -Uri "https://fluz.app/gift-card/purchase?_data=routes%2Fgift-card%2B%2Fpurchase" `
  -Method "POST" `
  -WebSession $session `
  -Headers @{
  "authority"="fluz.app"
    "method"="POST"
    "path"="/gift-card/purchase?_data=routes%2Fgift-card%2B%2Fpurchase"
    "scheme"="https"
    "accept"="*/*"
    "accept-encoding"="gzip, deflate, br, zstd"
    "accept-language"="zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6,zh-HK;q=0.5"
    "origin"="https://fluz.app"
    "priority"="u=1, i"
    "referer"="https://fluz.app/stores"
    "sec-ch-ua"="`"Microsoft Edge`";v=`"135`", `"Not-A.Brand`";v=`"8`", `"Chromium`";v=`"135`""
    "sec-ch-ua-mobile"="?0"
    "sec-ch-ua-platform"="`"Windows`""
    "sec-fetch-dest"="empty"
    "sec-fetch-mode"="cors"
    "sec-fetch-site"="same-origin"
  } `
  -ContentType "application/json" `
  -Body "{`"payload`":{`"seat_id`":`"???`",`"offer_id`":`"424d4977-9cbe-4be6-be70-8ed4a5b1e071`",`"purchase_amount`":10,`"fluzpay_amount`":10,`"cashback_voucher_id`":`"$($voucher.cashback_voucher_id)`",`"bank_card_id`":`"???`",`"rskfd_id`":`"`",`"deviceDetails`":{`"deviceId`":`"???`",`"interface`":`"BROWSER`",`"macAddress`":`"0:0:0:0:0`",`"os`":`"Windows`",`"osVersion`":`"11`",`"softwareVersion`":`"`",`"type`":`"DESKTOP`",`"brand`":`"Edge`",`"model`":`"135.0.0`"},`"channel`":`"UWP`",`"isMobile`":false},`"pinAuthToken`":`"???`"}"
}
