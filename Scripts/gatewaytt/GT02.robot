*** Settings ***
Library           WhiteLibrary

*** Test Cases ***
startapp
    Launch Application    C:/Program Files (x86)/Gateway/Gateway.ConfigManage.exe
    Attach Window    登录
    Input Text To Textbox    txtPassword    Password_002
    Click Button    text:登录
