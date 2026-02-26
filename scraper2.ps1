###############################################################################
# Azure Marketplace Scraper - Selenium 4 + EdgeDriver (explicit driver path)
###############################################################################

# Load Selenium DLLs from your path
Add-Type -Path "C:\Selenium\lib\net8.0\WebDriver.dll"
Add-Type -Path "C:\Selenium\lib\net8.0\WebDriver.Support.dll"

# Use your msedgedriver path
$driverPath = "C:\Tools\msedgedriver.exe"

# Create a driver service (required to bypass SeleniumManager)
$service = [OpenQA.Selenium.Edge.EdgeDriverService]::CreateDefaultService(
    (Split-Path $driverPath),
    (Split-Path $driverPath -Leaf)
)
$service.HideCommandPromptWindow = $true

# Configure Edge
$edgeOptions = New-Object OpenQA.Selenium.Edge.EdgeOptions
$edgeOptions.AddArgument("start-maximized")
# Uncomment for headless scraping:
# $edgeOptions.AddArgument("headless=new")

# Start WebDriver
$driver = New-Object OpenQA.Selenium.Edge.EdgeDriver($service, $edgeOptions)

$results = @()

$baseUrl = "https://marketplace.microsoft.com/en-us/search/products?page={0}&filters=Azure-benefit-eligible"

for ($page = 1; $page -le 69; $page++) {

    $url = $baseUrl -f $page
    Write-Host "Scraping page $page ($url)"

    $driver.Navigate().GoToUrl($url)
    Start-Sleep -Seconds 4   # allow React hydration

    # Select offer cards
    $cards = $driver.FindElements(
        [OpenQA.Selenium.By]::CssSelector("a[data-testid='tile-link-container']")
    )

    Write-Host "  Found $($cards.Count) cards..."

    foreach ($card in $cards) {

        $title = ""
        $publisher = ""
        $description = ""

        try { $title = $card.FindElement([OpenQA.Selenium.By]::CssSelector("span.title")).Text.Trim() } catch {}
        try { $publisher = $card.FindElement([OpenQA.Selenium.By]::CssSelector("span.publisher")).Text.Trim() } catch {}
        try { $description = $card.FindElement([OpenQA.Selenium.By]::CssSelector("span.description")).Text.Trim() } catch {}

        if ($title -ne "") {
            $results += [PSCustomObject]@{
                Name        = $title
                Publisher   = $publisher
                Description = $description
            }
        }
    }
}

$driver.Quit()

$results | Export-Csv -Path "marketplace.csv" -NoTypeInformation -Encoding UTF8

Write-Host "DONE — Total offers scraped: $($results.Count)"
###############################################################################
