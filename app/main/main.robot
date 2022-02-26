*** Settings ***
Resource    keywords.robot
Suite Setup    Open Home Page
Suite Teardown    Close Browser

*** Test Cases ***
Open browser
    Open Home Page

TC_001 Ensure all product categories have an icon
    Click hamburger menu
    Wait Until Page Contains Element    css:ul.sidebar-category-list > li.sidebar-category-list__link
    Verify each category link has icon
    Close hamburger menu

Ensure all product categories have a landing page
    Categories should have landing Page

Ensure search feature is working (with keyword 'PS5')
    Search feature should works    PS5

Ensure product search picture and product detail picture match
    Product pictures should match