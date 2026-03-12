*** Settings ***
Library    SeleniumLibrary
Library    Collections

*** Variables *** 
${var_1}    5

*** Test Cases ***
TEST-00001
    [Documentation]    Operations

    ${var_1}    Set Variable    ${5}
    ${var_2}    Set Variable    3

    # Addition
    ${ans}    Evaluate    ${var_1}+${var_2}
    Log To Console    ${ans}
    Log To Console    ${var_1+${var_2}} 

    #Subtraction
    ${ans}    Evaluate    ${var_1}-${var_2}
    Log To Console    ${ans}
    Log To Console    ${var_1-${var_2}} 
    
    #Multiplication
    ${ans}    Evaluate    ${var_1}*${var_2}
    Log To Console    ${ans}
    Log To Console    ${var_1*${var_2}}    

    #Division
    ${ans}    Evaluate    ${var_1}/${var_2}
    Log To Console    ${ans}
    Log To Console    ${var_1/${var_2}}    
    
TEST-00002
    [Documentation]    String Concatenation
    ${var_1}    Set Variable    ${5}
    ${var_2}    Set Variable    3
    ${var_3}    Set Variable    ABC
    ${var_4}    Set Variable    ABCDE

    ${result}    Evaluate    "${var_1}" + " " + "${var_2}"
    ${result}    Set Variable    ${var_1} ${var_2}
    Log To Console    ${result}
    Log To Console    ${var_1} ${var_2} ${SPACE} ${var_3} ${var_4}

TEST-00003
    [Documentation]    List Examples
    ${list_1}    Create List    value_1    value_2    value_3
    Log To Console    ${list_1}
    Log To Console    ${list_1[0]}
    Log To Console    ${list_1}[1]
    Append To List    ${list_1}    value_4
    Log To Console    ${list_1}

TEST-00004
    [Documentation]    Dictionary
    ${dict_1}    Create Dictionary    key_1=value_1    key_2=value_2
    Log To Console    ${dict_1}
    Log To Console    ${dict_1['key_1']}
    Set To Dictionary    ${dict_1}    key_1=value_3    key_4=value_4
    Log To Console    ${dict_1}

TEST-00005
    [Documentation]    For Loop Examples
    
    ${list_1}    Create List    value_1    value_2    value_3

    # FOR LOOP - LIST
    FOR    ${element}    IN    @{list_1}
        Log To Console    ${element}
    END

    FOR    ${element}    IN    value_1    value_2    value_3
        Log To Console    ${element}
    END

    # IN RANGE LOOP
    FOR    ${i}    IN RANGE    0    10    2
        Log To Console    ${i}
    END
    
    # GET LENGTH
    ${len}    Get Length    ${list_1}
    Log To Console    ${len}

    # FOR LOOP - LIST
    FOR    ${i}    IN RANGE     0    ${len}
        Log To Console    ${list_1[${i}]}
    END

    # IN ENUMERATE LOOP
    FOR    ${index}    ${element}    IN ENUMERATE    @{list_1}
        Log To Console    ${index+1} - ${element}
    END

    # FOR LOOP - DICTIONARY
    ${dict_1}    Create Dictionary    key_1=value_1    key_2=value_2    key_3=value_3    key_4=value_4
    FOR    ${key}    IN    @{dict_1.keys()}
        Log To Console    ${key}  
        Log To Console    ${dict_1["${key}"]}      
    END
    
    # nested for loop
    #     FOR    ${i}    IN    1    2    3
    FOR    ${i}    IN RANGE   1    4
        FOR    ${j}    IN    A    B    C
            Log To Console    ${i}-${j}
        END
        
    END
    
TEST-00006
    [Documentation]    Assertions
    ${ans}    Evaluate    1+1
    # Should Be Equal    ${ans}    2
    # Should Be Equal As Integers    ${ans}    2
    Should Be Equal As Strings    ${ans}    2
    
TEST-00007   
    [Documentation]    IF STATEMENTS

    ${ans}    Evaluate    1+1
    IF    ${ANS}--2
        Fail    Failed
    END
    

    # ${var_3}    Set Variable    ${var_1}+${var_2}
    # Log    ${var_3}

    # ${concat}    Evaluate    "${var_1}"+"${var_2}"
    # log    ${concat}

    # Log to Console    ${${var_1}+${var_2}}

# *** Keywords ***
#     [Arguments]    ${text}    ${level}=INFO

