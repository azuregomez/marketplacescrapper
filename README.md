# marketplacescrapper
This is an old fashioned screenscrapper for all the Azure Marketplace offerings that are elegible for Azure benefits (like decrementing a MACC).
The website is updated regularly and it has over 4,000 offerings that match this criteria:<br>
https://marketplace.microsoft.com/en-us/search/products?page=1&filters=Azure-benefit-eligible<br>
The scrapper is a Powershell script.

Steps:
<ol>
<li>Download the dlls from here: <br>
https://www.nuget.org/packages/Selenium.WebDriver<br>
https://www.nuget.org/packages/Selenium.Support<br>
and rename the .nupkg to .zip<br>
If you want the canonical entry point (language‑agnostic):  https://www.selenium.dev/downloads/
</li>  
<li>Unzip to a good location, like C:\Selenium</li>
<li>Run scraper2.ps1<br>The result is an Excel spreadsheet</li>
</ol>


