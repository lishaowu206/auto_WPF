*** Settings ***
Test Teardown     Terminate Process    ${handle}    kill=true
Test Template     Launch Application With Arguments
Library           WhiteLibrary
Library           Process
Library           OperatingSystem
Library           String
Resource          ../resource.robot
Library           WhiteLibrary
Library           Process
Resource          ../resource.robot
Library           WhiteLibrary
Resource          ../resource.robot

*** Variables ***
${EMPTY_STRING}    "${SPACE}${SPACE}${SPACE}"
${EMPTY_STRING2}    ${SPACE}${SPACE}${SPACE}
${PROCESS_NAME}    UIAutomationTest

*** Test Cases ***
No Arguments
    ${EMPTY}    No command line args provided

Empty String
    ""    ${EMPTY}

Space
    ${EMPTY_STRING}    ${EMPTY_STRING2}

Single Argument
    -single_argument    -single_argument

Single Argument With Space
    "-single argument"    -single argument

Two Arguments
    -argument1 -argument2    -argument1;-argument2

Two Arguments With Space
    "-argument 1" "-argument 2"    -argument 1;-argument 2

Three Arguments
    -argument1 -argument2 -argument3    -argument1;-argument2;-argument3

Three Arguments With Space
    "-argument 1" "-argument 2" "-argument 3"    -argument 1;-argument 2;-argument 3

File Paths
    test/test2.txt test\\test2.exe    test/test2.txt;test\\test2.exe

File Paths2
    test${/}test2.txt test\\test2.exe    test\\test2.txt;test\\test2.exe

Special Characters
    \# ? \\ / - _ \$    \#;?;\\;/;-;_;\$

Attach To A Running Application By Name
    Attach Application By Name    ${TEST APPLICATION NAME}
    Application Should Be Attached

Attach To A Running Application By Id
    Attach Application By Id    ${test application id}
    Application Should Be Attached

Attach To A Running Application By Invalid Name
    Run Keyword And Expect Error    STARTS: Unable to locate application with identifier: ${INVALID TEST APPLICATION NAME}    Attach Application By Name    ${INVALID TEST APPLICATION NAME}

Attach To A Running Application By Invalid Name With Timeout
    Run Keyword And Expect Error    STARTS: Unable to locate application with identifier: ${INVALID TEST APPLICATION NAME}    Attach Application By Name    ${INVALID TEST APPLICATION NAME}    timeout=20 seconds

Attach To Application With Timeout
    [Setup]    Delayed Start Test Application
    [Timeout]    1 minute
    Attach Application By Name    ${TEST APPLICATION NAME}    timeout=1 minute
    Application Should Be Attached
    Close Application
    [Teardown]    Terminate Process    delayed    kill=true

Wait Until Application Has Stopped
    Close Application
    Wait Until Application Has Stopped    ${PROCESS_NAME}    20

Failing Wait Until Application Has Stopped
    Run Keyword And Expect Error    Application 'UIAutomationTest' did not exit within 1 second    Wait Until Application Has Stopped    ${PROCESS_NAME}    1
    [Teardown]    Close Application

*** Keywords ***
Launch Application With Arguments
    [Arguments]    ${arguments}    ${result}
    Launch Application For Test    ${arguments}
    Command Line Arguments Should Be    ${result}
    Close Application

Command Line Arguments Should Be
    [Arguments]    ${value}
    Verify Text In Textbox    command_line_arguments_value    ${value}

Delayed Start Test Application
    Start Process    ${DELAYED TEST APPLICATION}    alias=delayed    stdout=${EXECDIR}${/}output${/}stdout.txt    stderr=${EXECDIR}${/}output${/}stderr.txt

Start Test Application
    ${handle} =    Start Process    ${TEST APPLICATION}
    Set Test Variable    ${handle}
    ${test application id} =    Get Process Id    ${handle}
    Set Test Variable    ${test application id}

Application Should Be Attached
    Attach Window    UI Automation Test Window
    Verify Label    lblA    Value 1
