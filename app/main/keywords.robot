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
${PRODUCT_SEARCH_PICTURE}    temp/product-search-screenshot.png
${PRODUCT_DETAIL_PICTURE}    temp/product-detail-screenshot.png
${PRODUCT_DIFFERENCES_PICTURE}    temp/product-differences.png

*** Keywords ***
Open Home Page
    Run Keyword And Return If    '${ENVIRONMENT}' == 'Development'    Open Development
    Open Production
    Run Keyword And Ignore Error    Click allow cookies

Open Development
    Open browser    ${URL}   ${BROWSER}

Open Production
    Open headless browser    ${URL}

Open headless browser
    [Arguments]    ${URL}
    Open Browser    ${URL}    ${HEADLESS_BROWSER}    options=add_argument("--remote-debugging-port=9515");add_argument("--no-sandbox"); add_argument("--disable-dev-shm-usage")

Click allow cookies
    Wait Until Page Contains Element    css:#allow-cookies
    Click Button    css:#allow-cookies

Click hamburger menu
    Wait Until Page Contains Element   css:div.header label > svg[data-icon='bars']
    Click Element    css:div.header label > svg[data-icon='bars']

Click add to basket button
    Wait Until Page Contains Element   css:.shipment-details button
    @{BUTTONS}=    Get WebElements    css:.shipment-details button
    Click Element    ${BUTTONS}[0]

Close hamburger menu
    Wait Until Page Contains Element   css:div#sidebar-header-main > label > svg[data-icon='times']
    Click Element    css:div#sidebar-header-main > label > svg[data-icon='times']

Fail on missing icon
    [Arguments]    ${Locator}
    ${name}=    Get product category text    ${Locator}
    Fail    ${name} category is missing an icon

Landing page element should contain
    [Arguments]    ${Locator}    ${Text}
    Wait Until Page Contains Element    ${Locator}
    Element Should Contain   ${Locator}     ${Text}

Magick compare images and return distortion
    [Arguments]    ${picture1}    ${picture2}
    ${rc}    ${output}=    Run And Return Rc And Output    magick ${picture1} ${picture2} -metric RMSE -compare -format "%[distortion]" info:
    [Return]    ${output}

Magick compare images and create difference image
    [Arguments]    ${picture1}    ${picture2}    ${result_picture}
    ${rc}    ${output}=    Run And Return Rc And Output    magick ${picture1} ${picture2} -metric RMSE -compare ${result_picture}
    [Return]    ${output}

Get product categories webelements
    @{elements}=    Get WebElements    css:ul.sidebar-category-list > li.sidebar-category-list__link
    [Return]    @{elements}

Get product categories count
    Click hamburger menu
    ${CATEGORY_SIZE}=    Get Element Count    css:ul.sidebar-category-list > li.sidebar-category-list__link
    Close hamburger menu
    [Return]    ${CATEGORY_SIZE}

Get product category text
    [Arguments]    ${Locator}
    ${element}=    Execute Javascript    return arguments[0].querySelector('a > .category-list-item');    ARGUMENTS    ${Locator}
    ${text}=    Get Text    ${element}
    [Return]    ${text}

Goto product detail
    Run Keyword And Ignore Error    Click allow cookies
    Click Element    css:#main ol li:nth-child(1) > article > a

Open product category
    [Arguments]    ${Location}
    ${Pass}=    Run Keyword And Return Status    Click Element    ${Location}
    Run Keyword Unless    ${Pass}    Wait Until Keyword Succeeds    10    1    Scroll and click link    ${Location}

Product landing page should contain
    [Arguments]    ${Text}
    ${Pass}=    Run Keyword And Return Status    Landing page element should contain    css:main > header > div    ${Text}
    Run Keyword Unless    ${Pass}    Landing page element should contain    css:main#main div.row h1    ${Text}

Product detail should contain
    [Arguments]    ${SEARCH_KEYWORD}
    Wait Until Page Contains Element    css:section.description-container__full-text > div > p
    Page Should Contain    ${SEARCH_KEYWORD}
Product pictures should exists
    File Should Exist    ${PRODUCT_SEARCH_PICTURE}
    File Should Exist    ${PRODUCT_DETAIL_PICTURE}
    
Product pictures should match
    ${output}=    Magick compare images and return distortion    ${PRODUCT_SEARCH_PICTURE}    ${PRODUCT_DETAIL_PICTURE}
    ${pass}=    Evaluate    ${output}*100 < 3
    Run Keyword Unless    ${pass}    Magick compare images and create difference image    ${PRODUCT_SEARCH_PICTURE}    ${PRODUCT_DETAIL_PICTURE}    ${PRODUCT_DIFFERENCES_PICTURE}
    Should Be True    ${pass}

Scroll and click link
    [Arguments]    ${Location}
    Run Keyword And Ignore Error    Click Element    css:div.sidebar-scroll-buttons--bottom > svg[data-icon='arrow-down']
    Click Link    ${Location}

Search by keyword
    [Arguments]    ${SEARCH_KEYWORD}
    ${SEARCH_INPUT}=    Set Variable    css:input[type='search'][name='query']
    ${SEARCH_BUTTON}=    Set Variable   css:button[type='submit'][name='submit'] 
    Input Text    ${SEARCH_INPUT}    ${SEARCH_KEYWORD}
    Wait Until Page Contains Element    css:nav[aria-labelledby='suggestions-title'] > section.search-input-with-suggestions__products
    Click Button   ${SEARCH_BUTTON}
    Wait Until Page Contains Element    css:#main ol li article

Take product search image
    ${Link}=    Get Element Attribute    css:ol li:nth-child(1) picture img     src
    @{SplitLink}=    Split String    ${Link}    /
    Set List Value    ${SplitLink}    5    f=auto
    ${Link}=    Evaluate    "/".join(${SplitLink})
    Run And Return Rc And Output    curl -o ${PRODUCT_SEARCH_PICTURE} ${Link}
    
Take product detail image
    ${Link}=    Get Element Attribute    css:.ratio-carousel > .ratio-carousel__slide:nth-child(1) picture > img     src
    @{SplitLink}=    Split String    ${Link}    /
    Set List Value    ${SplitLink}    5    f=auto
    ${Link}=    Evaluate    "/".join(${SplitLink})
    Run And Return Rc And Output    curl -o ${PRODUCT_DETAIL_PICTURE} ${Link}

Verify each category link has icon
    @{ELEMENTS}=    Get product categories webelements
    FOR    ${ELEMENT}    IN    @{ELEMENTS}
        ${ICON}=    Execute Javascript    return arguments[0].querySelector('a > span > svg');    ARGUMENTS    ${ELEMENT}
        Run Keyword Unless    ${ICON}    Fail on missing icon    ${ELEMENT}
    END

Verify hamburger drop down menu exists
     Page Should Contain Element    css:nav.sidebar__navigation-container

Verify price exists
    Wait Until Page Contains Element    css:data[data-price="current"]
    Page Should Contain Element    css:data[data-price="current"]

Verify the basket modal contains word
    ${WORD}=    Set Variable    Ostoskori
    ${MODAL}=    Get WebElement    css:.dropdown-modal-container
    Element Should Contain    ${MODAL}    ${WORD}