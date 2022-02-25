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
    Open headless browser    ${URL}

Open headless browser
    [Arguments]    ${URL}
    Open Browser    ${URL}    ${HEADLESS_BROWSER}    options=add_argument("--remote-debugging-port=9515");add_argument("--no-sandbox"); add_argument("--disable-dev-shm-usage")

Categories should have icon
    Click hamburger menu
    Wait Until Page Contains Element    css:ul.sidebar-category-list > li.sidebar-category-list__link
    @{LIST_ELEMENT}=    Get WebElements    css:ul.sidebar-category-list > li.sidebar-category-list__link a > span > svg
    
    FOR    ${element}    IN    @{LIST_ELEMENT}
        Page Should Contain Element    ${element}
    END

    Close hamburger menu

Categories should have landing Page
    Click hamburger menu
    ${CATEGORY_SIZE}=    Get Element Count    css:ul.sidebar-category-list > li.sidebar-category-list__link > a
    Close hamburger menu

    FOR    ${Ind}    IN RANGE   ${CATEGORY_SIZE}
    # FOR    ${Ind}    IN RANGE   1
        Click hamburger menu
        @{CATEGORIES}=    Get WebElements    css:ul.sidebar-category-list > li.sidebar-category-list__link > a
        @{CATEGORIES_TEXT}=    Get WebElements    css:ul.sidebar-category-list > li.sidebar-category-list__link > a > span.category-list-item
        ${CATEGORY}=    Get From List    ${CATEGORIES}    ${Ind}
        ${Text}=    Get Text    ${CATEGORIES_TEXT}[${Ind}]

        Open category and page should contain    ${CATEGORY}    ${Text}
    END

Click hamburger menu
    Wait Until Page Contains Element   css:div.header label > svg[data-icon='bars']
    Click Element    css:div.header label > svg[data-icon='bars']

Close hamburger menu
    Wait Until Page Contains Element   css:div#sidebar-header-main > label > svg[data-icon='times']
    Click Element    css:div#sidebar-header-main > label > svg[data-icon='times']

Landing page element should contain
    [Arguments]    ${Locator}    ${Text}
    Wait Until Page Contains Element    ${Locator}
    Element Should Contain   ${Locator}     ${Text}


Open category and page should contain
    [Arguments]    ${Location}    ${Text}
    ${Pass}=    Run Keyword And Return Status    Click Element    ${Location}
    Run Keyword If    ${Pass} == ${FALSE}    Wait Until Keyword Succeeds    10    1    Scroll and click element    ${Location}
    Continue For Loop If    '${Text}' == 'Yritysmyynti'
    ${Pass}=    Run Keyword And Return Status    Landing page element should contain    css:main > header > div    ${Text}
    Run Keyword If    ${Pass} == ${FALSE}    Landing page element should contain    css:main#main div.row h1    ${Text}

Scroll and click element
    [Arguments]    ${Location}
    Click Element    css:div.sidebar-scroll-buttons--bottom > svg[data-icon='arrow-down']
    Wait Until Element Is Not Visible   css:div.sidebar-scroll-buttons--bottom > svg[data-icon='arrow-down']
    Click Element    ${Location}