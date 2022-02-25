*** Settings ***
Resource    keywords.robot

*** Test Cases ***
Open browser
    Open Home Page

Ensure all product categories have an icon
    Categories should have icon