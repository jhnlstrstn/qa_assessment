*** Settings ***
Library    SeleniumLibrary
Resource    ../resource/app.resource
Variables    ../variables/customers.py 

*** Variables ***
${total_customer_spending}     ${0.0}
${user_spending_no}    ${0}

*** Keywords ***

Open Create Modal
    Click Element    //a[text()="Create"]
    Wait Until Element Is Visible    //h6[descendant::span[text()="Create Customer"]]

Add a Customer
    [Arguments]    ${user}
    Navigate    Customers
    Open Create Modal

    Input Text    ${cust_txt_first_name}    ${user['first_name']}
    Input Text    ${cust_txt_last_name}    ${user['last_name']}
    Input Text    ${cust_txt_email}    ${user['email']}
    Input Text    ${cust_txt_birthday}    ${user['birthday']}
    Input Text    ${cust_txt_address}    ${user['address']['street']} ${user['address']['suite']} 
    Input Text    ${cust_txt_city}    ${user['address']['city']}
    Input Text    ${cust_txt_stateAbbr}    ${user['address']['stateAbbr']} 
    Input Text    ${cust_txt_zipcode}    ${user['address']['zipcode']}
    Input Text    ${cust_txt_password}    ${user['password']}
    Input Text    ${cust_txt_confirm_password}    ${user['password']}
    Click Button    ${cust_btn_save}
    Wait Until Element Is Visible    //div[text()="Customer created"]

Format Birthday
    [Arguments]    ${date}
    ${formatted}    Evaluate    "/".join("${date}".split("-")[1:]+["${date}".split("-")[0]])
    RETURN    ${formatted}

Verify Customer Identity Details
    [Arguments]    ${user}
    Navigate    Customers
    ${user_row}    Get Customer Row    ${user}
    Wait Until Element Is Visible    ((//tbody//tr)[${user_row}]//td)[2]    
    Click Element    ((//tbody//tr)[${user_row}]//td)[2]
    Wait Until Element Is Visible    ${cust_txt_first_name}

    ${locators}    Create List    ${cust_txt_first_name}    ${cust_txt_last_name}    ${cust_txt_email}    ${cust_txt_birthday}    ${cust_txt_address}    ${cust_txt_city}    ${cust_txt_stateAbbr}    ${cust_txt_zipcode}    ${cust_txt_password}    ${cust_txt_confirm_password}
    ${expected_values}    Create List    ${user['first_name']}    ${user['last_name']}    ${user['email']}    ${user['birthday']}    ${user['address']['street']} ${user['address']['suite']}    ${user['address']['city']}    ${user['address']['stateAbbr']}    ${user['address']['zipcode']}    ${user['password']}    ${user['password']}

    FOR    ${i}    ${locator}    IN ENUMERATE    @{locators}
        Mouse Over    ${locator}
        ${value_text}    Get Value    ${locator}
        IF    '${locator}'=='${cust_txt_birthday}'
            ${value_text}    Format Birthday    ${value_text}
        END
        Should Be Equal As Strings    ${expected_values[${i}]}    ${value_text}
    END

Get Customer Row
    [Arguments]    ${user}
    Navigate    Customers
    ${web_elems}    Get WebElements    //tbody//tr
    FOR    ${i}    ${elem}    IN ENUMERATE    @{web_elems}
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${name}    Clean Text    ${name}
        Return From Keyword If    "${user['first_name']} ${user['last_name']}"=="${name}"    ${i+1}
    END
    RETURN    None  

Clean Text
    [Arguments]    ${text}
    IF    "\\n" in """${text}"""
        ${text}    Evaluate    """${text}""".replace("\\n","")[1:]
    END
    Return From Keyword    ${text}
    
Clear Then Input Text
    [Arguments]    ${locator}    ${text}
    IF    '${locator}'=='${cust_txt_birthday}'
        Press Keys    ${locator}    CTRL+a    BACKSPACE    ARROW_LEFT    CTRL+a    BACKSPACE    ARROW_LEFT    CTRL+a    BACKSPACE
    ELSE
        Press Keys    ${locator}    CTRL+a    BACKSPACE
    END
    Input Text    ${locator}    ${text}

Verify If Customer Is Added In The Table   
    [Arguments]    ${user}
    ${user_row}    Get Customer Row    ${user}
    Should Not Be Equal As Strings    None    ${user_row}

Update Customer Identity Details
    [Arguments]    ${user}

    Clear Then Input Text    ${cust_txt_first_name}    ${user['first_name']}
    Clear Then Input Text    ${cust_txt_last_name}    ${user['last_name']}
    Clear Then Input Text    ${cust_txt_email}    ${user['email']}
    Clear Then Input Text    ${cust_txt_birthday}    ${user['birthday']}
    Clear Then Input Text    ${cust_txt_address}    ${user['address']['street']} ${user['address']['suite']} 
    Clear Then Input Text    ${cust_txt_city}    ${user['address']['city']}
    Clear Then Input Text    ${cust_txt_stateAbbr}    ${user['address']['stateAbbr']} 
    Clear Then Input Text    ${cust_txt_zipcode}    ${user['address']['zipcode']}
    Clear Then Input Text    ${cust_txt_password}    ${user['password']}
    Clear Then Input Text    ${cust_txt_confirm_password}    ${user['password']}
    Click Button    ${cust_btn_save}
    Wait Until Element Is Visible    //div[text()="Customer updated"]

Log Table Data
    [Arguments]    ${i}
    Log To Console    \n
    ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
    ${name}    Clean Text    ${name}
    ${last_seen}    Get Text    ((//tbody//tr)[${i+1}]//td)[3]
    ${orders}    Get Text    ((//tbody//tr)[${i+1}]//td)[4]
    ${total_spent}    Get Text    ((//tbody//tr)[${i+1}]//td)[5]
    ${latest_purchase}    Get Text    ((//tbody//tr)[${i+1}]//td)[6]
    ${news}   Get Element Attribute    ((//tbody//tr)[${i+1}]//td)[7]//*[name()="svg"]    aria-label
    ${segments}    Get Segments    ${i}

    Log To Console    ====== User ${i+1} ======
    Log To Console    Name: ${name}
    Log To Console    Last Seen: ${last_seen}
    Log To Console    Orders: ${orders} 
    Log To Console    Total Spent: ${total_spent}       
    IF    '${latest_purchase}' != ''
        Log To Console    Latest Purchase: ${latest_purchase}     
    END
    Log To Console    News: ${news}
    IF    '${segments}' != ''
        Log To Console    Segments: ${segments}     
    END

Get Segments
    [Arguments]    ${i}
    ${web_elems}    Get WebElements    //tbody//tr
    ${j}   Set Variable    0
    FOR    ${j}    ${elem}    IN ENUMERATE    @{web_elems}
        IF    ${j}==${i}
            ${segments}    Get Text    ((//tbody//tr)[${i+1}]//td)[8]
            ${segments}    Clean Segment Text    ${segments}
            RETURN    ${segments}
        END
    END    
    RETURN     ${None}

Clean Segment Text
    [Arguments]    ${text}
    IF    "\\n" in """${text}"""
        ${text}    Evaluate    """${text}""".replace("\\n",", ")[0:]
    END
    Return From Keyword    ${text}

Display Users With Spending
    [Arguments]    ${i}
    ${total_spent}    Get Text    ((//tbody//tr)[${i+1}]//td)[5]
    IF    '${total_spent}' != '$0.00'
        ${name}    Get Text    ((//tbody//tr)[${i+1}]//td)[2]
        ${name}    Clean Text    ${name}
        ${new_user_spending_no}    Evaluate    ${user_spending_no}+${1}  
        Set Global Variable    ${user_spending_no}    ${new_user_spending_no}
        Log To Console    ${user_spending_no}. ${name}: ${total_spent}
        ${total_spent}    Clean Total Text    ${total_spent}
        Calculate Total Spending    ${total_spent}
    END

Calculate Total Spending
    [Arguments]    ${total_spent}
    ${new_total}    Evaluate    ${total_spent}+${total_customer_spending}
    Set Global Variable    ${total_customer_spending}    ${new_total}

Display Total Spending
    ${total_customer_spending}    Evaluate    f"{${total_customer_spending}:.2f}"
    Log To Console    \n===================================
    Log To Console    Total Customer Spending: $${total_customer_spending}
    Log To Console    ===================================

    Validate Total Spending    ${total_customer_spending}
    Set Global Variable    ${total_customer_spending}   ${0}

Validate Total Spending
    [Arguments]    ${total_customer_spending}
    IF    ${total_customer_spending}<3500.00
        Log To Console    FAIL: Total Spending ($${total_customer_spending}) is below minimum threshold ($3,500).\n
    ELSE
        Log To Console    PASS: Total Spending ($${total_customer_spending}) meets minimum threshold ($3,500).\n
    END
    

Clean Total Text
    [Arguments]    ${text}
    ${text}    Evaluate    """${text}""".replace("$","")[0:]
    ${text}    Evaluate    """${text}""".replace(",","")[0:]
    ${text}    Evaluate    """${text}""".replace(" ","")[0:]
    Return From Keyword    ${text}