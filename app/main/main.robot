*** Settings ***
Resource    keywords.robot

*** Test Cases ***
Open browser
    Open Home Page

Ensure all product categories have an icon
    Categories should have icon

Ensure all product categories have a landing page
    Categories should have landing Page

Ensure search feature is working (with keyword 'PS5')
    Search feature should works    PS5

Ensure product search picture and product detail picture match
    Product pictures should match