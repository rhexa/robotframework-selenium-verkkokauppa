*** Settings ***
Library    SeleniumLibrary
Library    String
Library    Collections
Library    DateTime
Library    OperatingSystem

*** Variables ***
${URL}          https://www.verkkokauppa.com/
${BROWSER}      chrome
${HEADLESS_BROWSER}   headlesschrome
${ENVIRONMENT}    Production

*** Keywords ***
Open Home Page
    Run Keyword And Return If    '${ENVIRONMENT}' == 'Development'    Open Development
    Open Production

Open Development
    Open browser    ${URL}   ${BROWSER}

Open Production
    Open browser    ${URL}   ${HEADLESS_BROWSER}   options=add_argument("--remote-debugging-port=9515");add_argument("--no-sandbox"); add_argument("--disable-dev-shm-usage")