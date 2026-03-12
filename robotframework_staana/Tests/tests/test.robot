*** Settings ***
Resource    ../resource/app.resource
Resource    ../resource/customers.resource
Suite Setup    Suite Init

*** Test Cases ***
# TEST-1
#     [Documentation]    User should be able to add a customer
#     Add a Customer    ${USERS[0]}
#     Verify Customer Identity Details    ${USERS[0]}
#     Verify If Customer Is Added In The Table  ${USERS[0]}

# TEST-2
#     Log To Console    hi

TEST-1
    [Documentation]    ADD FIRST 5 USERS
    FOR    ${i}    IN RANGE    5
        Add a Customer    ${USERS[${i}]}
        Verify Customer Identity Details    ${USERS[${i}]}
        Verify If Customer Is Added In The Table  ${USERS[${i}]}
    END

TEST-2
    [Documentation]    UPDATE EXISTING COLUMNS
    FOR    ${i}    IN RANGE    5    10
        Navigate    Customers
        Click Element    ((//tbody//tr)[${i+1}]//td)[2]
        Wait Until Element Is Visible    //input[@name="first_name"]
        Update Customer Identity Details    ${USERS[${i}]}
        Verify Customer Identity Details    ${USERS[${i}]}
        Verify If Customer Is Added In The Table  ${USERS[${i}]}
    END

TEST-3
    [Documentation]    LOG TABLE DATA
    Navigate    Customers
    FOR    ${i}    IN RANGE    25
        Log Table Data    ${i}
    END
    
TEST-4
    [Documentation]    ANALYZE USER SPENDING
    Navigate    Customers
    Log To Console    \n
    FOR    ${i}    IN RANGE    25
        Display Users With Spending    ${i}
    END
    Display Total Spending

*** Keywords ***
Suite Init
    Launch Browser
    Login
    ${users}    Get Users
    Set Suite Variable    ${USERS}    ${users}

# Search 
#     [Arguments]    ${text}
#     Input Text    ${SEARCH_BAR}    ${text}