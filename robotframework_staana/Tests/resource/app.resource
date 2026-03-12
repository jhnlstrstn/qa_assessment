*** Settings ***
Library    SeleniumLibrary
Variables    ../variables/loginpage.py
Library    ../libraries/CommonLibrary.py

*** Variables ***
${TEST_URL}    https://marmelab.com/react-admin-demo/
@{sales_submenu}    Orders    Invoices
@{catalog_submenu}    Posters    Categories
@{customers_submenu}    Customers    Segments
&{MENU}    Sales=${sales_submenu}    Catalog=${catalog_submenu}    Customers=${customers_submenu}
${USERS}

*** Keywords ***

Launch Browser
    [Arguments]    ${url}=${TEST_URL}
    Open Browser    ${url}    chrome    options=add_argument("--start-maximized")
    Wait Until Element Is Visible    //input[@name="username"]

Login
    [Arguments]    ${username}=demo    ${password}=24chicken
    Input Text    ${login_txt_username}   ${username}
    Input Text    ${login_txt_password}    ${password}
    Click Button    ${login_btn_submit}
    Wait Until Element Is Visible    //div[@id="main-content"]

Get Parent Menu
    [Arguments]    ${sub_menu}
    FOR    ${key}    IN    @{MENU.keys()}
        Return From Keyword If    "${sub_menu}" in ${MENU["${key}"]}    //li[descendant::p[text()="${key}"]]
    END 

    RETURN    ${None}


Navigate
    [Arguments]    ${sub_menu}
    Click Element    //a[descendant::p[text()="Orders"]]
    ${sub_menu_loc}    Set Variable    //a[descendant::p[text()="${sub_menu}"]]
    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${sub_menu_loc}

    IF    not ${status}
        ${parent_menu}    Get Parent Menu    ${sub_menu}
        Click Element    ${parent_menu}
        Wait Until Element Is Visible    ${sub_menu_loc}
    END        
    Click Element    ${sub_menu_loc}
    Wait Until Element Is Visible    //h6[//span[text()="${sub_menu}"]]
    Run Keyword If    "${sub_menu}"=="Customers"
    ...    Sleep    2s