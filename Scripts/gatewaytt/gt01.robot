*** Settings ***
Library           RemoteSwingLibrary    debug=True
Library           OperatingSystem
Library           Process
Library           WhiteLibrary

*** Test Cases ***
None Existing Application start fails before timeout
    [Timeout]    3 seconds
    Run Keyword And Expect Error    *    Start Application    no-one    this command fails immediatly    timeout=1

Starting and stopping application with main window
    [Timeout]    10 seconds
    Start Application    myapp2    C:/Program Files/7edit.com/7Edit 2.x/7edit.exe    timeout=15 seconds
    System Exit

Start application removes the JAVA_TOOL_OPTIONS from enviroment
    [Timeout]    10 seconds
    Set environment variable    JAVA_TOOL_OPTIONS    ${EMPTY}
    log    1111111111111111
    Start Application    myapp2    C:/Program Files/7edit.com/7Edit 2.x/7edit.exe    timeout=5 seconds
    log    1111111111111111
    Should be equal    %{JAVA_TOOL_OPTIONS}    ${EMPTY}
    System Exit

Connecting to a started application
    [Timeout]    15 seconds
    Set java tool options
    ${handle}=    Start Process    java C:/Python2711/remoteswinglibrary-2.2.9/src/test/java/org/robotframework/remoteswinglibrary/MySwingApp.java    shell=True
    log    1111111111111111
    Application Started    myjava
    log    1111111111111111
    Exit and check process    ${handle}    myjava
    Set environment variable    JAVA_TOOL_OPTIONS    ${EMPTY}

Connecting to a specific application
    [Timeout]    30 seconds
    Set java tool options
    ${handle1}=    Start Process    java C:/Python2711/remoteswinglibrary-2.2.9/src/test/java/org/robotframework/remoteswinglibrary/MySwingApp.java    shell=True
    ${handle2}=    Start Process    java C:/Python2711/remoteswinglibrary-2.2.9/src/test/java/org/robotframework/remoteswinglibrary/MySwingApp.java    shell=True
    ${handle3}=    Start Process    java C:/Python2711/remoteswinglibrary-2.2.9/src/test/java/org/robotframework/remoteswinglibrary/MySwingApp.java    shell=True
    log    1111111111111111
    Application Started    three    name_contains=three
    Application Started    one    name_contains=one
    Application Started    two    name_contains=two
    log    22222222222222
    Exit and check process    ${handle2}    two
    Exit and check process    ${handle3}    three
    Exit and check process    ${handle1}    one
    Set environment variable    JAVA_TOOL_OPTIONS    ${EMPTY}

Connecting to an application and using java agent option
    [Timeout]    20 seconds
    ${agent}=    Set Variable    -javaagent:"${REMOTESWINGLIBRARYPATH}"\=127.0.0.1:${REMOTESWINGLIBRARYPORT}
    log    ${agent}
    ${handle}=    Start Process    java ${agent} C:/Python2711/remoteswinglibrary-2.2.9/src/test/java/org/robotframework/remoteswinglibrary/MySwingApp.java    shell=True
    Application Started    app
    Exit and check process    ${handle}    app

Ensure application closing
    [Timeout]    15 seconds
    Start Application    myapp    java org.robotframework.remoteswinglibrary.MySwingApp    timeout=5
    Ensure Application Should Close    5 seconds    My Closing Keyword    myapp

Ensure application closing when timeout
    [Timeout]    10 seconds
    Start Application    myapp    java org.robotframework.remoteswinglibrary.MySwingApp    timeout=5 seconds
    Run Keyword and expect error    *Application was not closed before timeout*    Ensure Application Should Close    1 second    No Operation

Unallowed SwingLibrary keywords
    [Timeout]    15 seconds
    Start Application    myapp3    java C:/Python2711/remoteswinglibrary-2.2.9/src/test/java/org/robotframework/remoteswinglibrary/MySwingApp.java    timeout=5 seconds
    Keyword Should Not Exist    Launch Application
    Keyword Should Not Exist    Start Application In Separate Thread
    [Teardown]    System Exit

Logging java properties
    [Timeout]    15 seconds
    Start Application    mapp    java C:/Python2711/remoteswinglibrary-2.2.9/src/test/java/org/robotframework/remoteswinglibrary/MySwingApp.java    timeout=5 seconds
    ${props}=    Log Java System Properties
    Should Contain    ${props}    System.getenv():
    [Teardown]    System Exit

test11
    [Timeout]    15 seconds
    ${handle}=    start Process    E:/Edit/edit.exe    shell=True
    Process Should Be Running    ${handle}
    log    ${handle}
    log    success1
    Application started    myapp
    log    success2
    System Exit    ${handle}
    Wait until keyword succeeds    5 seconds    0.5 seconds    Process Should Be Stopped    ${handle}

test12
    [Timeout]    15 seconds
    Set java tool options
    ${handle}=    Start Process    E:/Edit/edit.exe    shell=True
    Application Started    myjava

test13
    [Timeout]    10 seconds
    Set environment variable    JAVA_TOOL_OPTIONS    ${EMPTY}
    Start Application    myapp2    E:/Edit/edit.exe    timeout=5 seconds

*** Keywords ***
Keyword Should Not Exist
    [Arguments]    ${keyword}
    Run Keyword And Expect Error    No keyword with name '${keyword}' found.    Keyword Should Exist    ${keyword}

Exit and check process
    [Arguments]    ${handler}    ${alias}
    Switch To Application    ${alias}
    Process Should Be Running    ${handler}
    System Exit
    Wait until keyword succeeds    5 seconds    0.5 seconds    Process Should Be Stopped    ${handler}

My Closing Keyword
    [Arguments]    ${alias}
    Switch To Application    ${alias}
    Log    something plaah
    System Exit
