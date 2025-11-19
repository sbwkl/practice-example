@echo off

IF exist target (echo 'target exist, skip') ELSE (mkdir target)
xcopy notebook target\notebook /E

pause