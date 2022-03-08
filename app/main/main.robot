*** Settings ***
Resource    keywords.robot
Suite Setup    Open Home Page
Suite Teardown    Close Browser

*** Test Cases ***
TC_001 Ensure all product categories have an icon
    Click hamburger menu
    Wait Until Page Contains Element    css:ul.sidebar-category-list > li.sidebar-category-list__link a > span > svg
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

TC_003 Ensure search feature is working (with keyword 'PS5')
    ${SEARCH_KEYWORD}=    Set Variable    PS5
    Goto homepage
    Search by keyword    ${SEARCH_KEYWORD}
    Take product search image
    Goto product detail
    Product detail should contain    ${SEARCH_KEYWORD}
    Take product detail image

TC_004 Ensure product search picture and product detail picture match
    Product pictures should exists
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

TC_007 Ensure that price on the product page
    Goto homepage
    Search by keyword    keyboard
    Goto product detail
    Verify price exists

TC_008 Ensure the hamburger menu works
    Click hamburger menu
    Verify hamburger drop down menu exists

TC_009 Ensure sign up button working properly
    Goto homepage
    Click sign up button

TC_010 Ensure already existing user error pops up
    Create already existing user    dragonden2010@gmail.com    testPass1    rand    rand    987654321
