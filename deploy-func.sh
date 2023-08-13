#!/bin/bash

FUNCTION_APP_NAME=torger-function-app

cd functions

npm run build

func azure functionapp publish $FUNCTION_APP_NAME