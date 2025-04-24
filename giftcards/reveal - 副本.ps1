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
$session.Cookies.Add((New-Object System.Net.Cookie("_ga_", 
$session.Cookies.Add((New-Object System.Net.Cookie("intercom-id-", 
$session.Cookies.Add((New-Object System.Net.Cookie("cf_clearance", 
$session.Cookies.Add((New-Object System.Net.Cookie("toast-session", 
$session.Cookies.Add((New-Object System.Net.Cookie("intercom-session-", 
$session.Cookies.Add((New-Object System.Net.Cookie("__session", 
$session.Cookies.Add((New-Object System.Net.Cookie("_iidt", 
$session.Cookies.Add((New-Object System.Net.Cookie("_vid_t", 
$session.Cookies.Add((New-Object System.Net.Cookie("_dd_s", 

$giftCards = Invoke-WebRequest -UseBasicParsing -Uri "https://fluz.app/cards?type=GIFT_CARDS&_data=routes%2Fcards%2B%2F_route" `
-WebSession $session `
-Headers @{
"authority"="fluz.app"
  "method"="GET"
  "path"="/cards?type=GIFT_CARDS&_data=routes%2Fcards%2B%2F_route"
  "scheme"="https"
  "accept"="*/*"
  "accept-encoding"=""
  "accept-language"="zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6,zh-HK;q=0.5"
  "priority"="u=1, i"
  "referer"="https://fluz.app/cards"
  "sec-ch-ua"="`"Microsoft Edge`";v=`"135`", `"Not-A.Brand`";v=`"8`", `"Chromium`";v=`"135`""
  "sec-ch-ua-mobile"="?0"
  "sec-ch-ua-platform"="`"Windows`""
  "sec-fetch-dest"="empty"
  "sec-fetch-mode"="cors"
  "sec-fetch-site"="same-origin"
}

$cards = $giftCards | ConvertFrom-Json

foreach ($card in $cards.giftCards.rows)
{
    if ([int]$card.purchase_display_id -le 8198111) {
        continue
    }

    $response = Invoke-WebRequest -UseBasicParsing -Uri "https://fluz.app/gift-card/reveal?_data=routes%2Fgift-card%2B%2Freveal" `
    -Method "POST" `
    -WebSession $session `
    -Headers @{
    "authority"="fluz.app"
      "method"="POST"
      "path"="/gift-card/reveal?_data=routes%2Fgift-card%2B%2Freveal"
      "scheme"="https"
      "accept"="*/*"
      "accept-encoding"=""
      "accept-language"="zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6,zh-HK;q=0.5"
      "origin"="https://fluz.app"
      "priority"="u=1, i"
      "referer"="https://fluz.app/cards/gift-cards/view/$($card.purchased_gift_card_id)"
      "sec-ch-ua"="`"Microsoft Edge`";v=`"135`", `"Not-A.Brand`";v=`"8`", `"Chromium`";v=`"135`""
      "sec-ch-ua-mobile"="?0"
      "sec-ch-ua-platform"="`"Windows`""
      "sec-fetch-dest"="empty"
      "sec-fetch-mode"="cors"
      "sec-fetch-site"="same-origin"
    } `
    -ContentType "application/json" `
    -Body "{`"giftCardId`":`"$($card.purchased_gift_card_id)`",`"deviceDetails`":{`"deviceId`":`"???`",`"interface`":`"BROWSER`",`"macAddress`":`"0:0:0:0:0`",`"os`":`"Windows`",`"osVersion`":`"11`",`"softwareVersion`":`"`",`"type`":`"DESKTOP`",`"brand`":`"Edge`",`"model`":`"135.0.0`"},`"pinAuthToken`":`"???`"}"
    $secret = $response.Content | ConvertFrom-Json
    Write-Output "$($secret.code) $($secret.pin)"
}