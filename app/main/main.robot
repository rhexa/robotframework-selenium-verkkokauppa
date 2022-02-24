*** Settings ***
Resource    keywords.robot

*** Test Cases ***
Open browser
    Open Home Page

Ensure all product categories have an icon
    Wait Until Page Contains Element    css:div.header label > svg[data-icon='bars']
    Click Element    xpath://div[@class='header']/label
    Wait Until Page Contains Element    css:ul.sidebar-category-list > li.sidebar-category-list__link
    @{LIST_ELEMENT}=    Get WebElements    css:ul.sidebar-category-list > li.sidebar-category-list__link a > span > svg
    
    FOR    ${element}    IN    @{LIST_ELEMENT}
        Page Should Contain Element    ${element}
    END

*** Test Cases ***
