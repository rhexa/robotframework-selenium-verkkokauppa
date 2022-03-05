*** Settings ***
Resource    keywords.robot
Suite Setup    Open Home Page
Suite Teardown    Close Browser

*** Test Cases ***
TC_001 Ensure all product categories have an icon
    Click hamburger menu
    Wait Until Page Contains Element    css:ul.sidebar-category-list > li.sidebar-category-list__link
    Verify each category link has icon
    Close hamburger menu

TC_002 Ensure all product categories have a landing page
    ${CATEGORY_SIZE}=    Get product categories count
    FOR    ${Ind}    IN RANGE   ${CATEGORY_SIZE}
        Click hamburger menu
        @{CATEGORIES}=    Get product categories webelements
        ${CATEGORY}=    Get From List    ${CATEGORIES}    ${Ind}
        ${Text}=    Get product category text    ${CATEGORIES}[${Ind}]
        Continue For Loop If    '${Text}' == 'Yritysmyynti'
        Open product category    ${CATEGORY}
        Product landing page should contain    ${Text}
    END

Ensure search feature is working (with keyword 'PS5')
    Search feature should works    PS5

Ensure product search picture and product detail picture match
    Product pictures should match

TC_005 Can you find topics "Esittely" and "Lisätiedot" from product page
    Search by keyword    PS5
    Goto product detail
    Product detail should contain    Esittely
    Product detail should contain    Lisätiedot

TC_006 Ensure the add to the cart button works
    Search by keyword    keyboard
    Goto product detail
    Click add to basket button