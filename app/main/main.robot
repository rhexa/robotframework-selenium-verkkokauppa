*** Settings ***
Resource    keywords.robot

*** Test Cases ***
Open browser
    Open Home Page

Ensure all product categories have an icon
    Categories should have icon

Ensure all product categories have a landing page
    Categories should have landing Page