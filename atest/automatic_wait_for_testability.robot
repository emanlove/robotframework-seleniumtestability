*** Settings ***
Documentation   Verifies automatic injection & waiting features
Suite Setup     Start Flask App
Suite Teardown  Internal Suite Teardown
Test Template   Automatically Call Testability Ready
Library         SeleniumLibrary  plugins=${CURDIR}/../src/SeleniumTestability;True;60 seconds;False
Library         Timer
Resource        resources.robot

*** Test Cases ***
Verify Fetch In Firefox
  ${FF}  fetch  not executed  executed at least once  3.5  4.5

Verify Timeout In Firefox
  ${FF}  shorttimeout  not executed  executed at least once  3.5  4.5

Verify XHR In Firefox
  ${FF}  xhr  not executed  executed at least once  3.5  4.5

Verify CSS Transition In Firefox
  ${FF}  transition  not executed  executed at least once  3.5  4.5

Verify CSS Animation In Firefox
  ${FF}  animate  not executed  executed at least once  3.5  4.5

Verify Fetch In Chrome
  ${GC}  fetch  not executed  executed at least once  3.5  4.5

Verify Timeout In Chrome
  ${GC}  shorttimeout  not executed  executed at least once  3.5  4.5

Verify XHR In Chrome
  ${GC}  xhr  not executed  executed at least once  3.5  4.5

Verify CSS Transition In Chrome
  ${GC}  transition  not executed  executed at least once  3.5  4.5

Verify CSS Animation In Chrome
  ${GC}  animate  not executed  executed at least once  3.5  4.5

*** Keywords ***
Add Final Benchmark Table
  [Documentation]  Verifies that all timers done during the suite are passing
  Verify All Timers  fail_on_errors=False

Internal Suite Teardown
  [Documentation]  Final teardown
  Add Final Benchmark Table
  Teardown Test Environment
  Remove All Timers

Automatically Call Testability Ready
  [Arguments]  ${BROWSER}  ${ID}  ${PRE_MESSAGE}  ${POST_MESSAGE}  ${HIGHER_THAN}  ${LOWER_THAN}
  [Documentation]  test template for manual waiting & injection tests
  Setup Web Environment   ${BROWSER}    ${URL}
  Element Text Should Be  id:${id}-result  ${PRE_MESSAGE}
  Start Timer  ${TEST NAME}-onClick
  Click Element  id:${id}-button
  Stop Timer  ${TEST NAME}-onClick
  Start Timer  ${TEST NAME}-onGetText
  Element Text Should Be  id:${id}-result  ${POST_MESSAGE}
  Stop Timer  ${TEST NAME}-onGetText
  Start Timer  ${TEST NAME}-onWait
  Wait For Testability Ready
  Stop Timer  ${TEST NAME}-onWait
  Verify Single Timer  0.5  0  ${TEST NAME}-onClick
  Verify Single Timer  ${LOWER_THAN}  ${HIGHER_THAN}  ${TEST NAME}-onGetText
  Verify Single Timer  0.5  0  ${TEST NAME}-onWait
  [Teardown]  Teardown Web Environment
