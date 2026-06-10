#!/bin/bash
TF_WORKSPACE=$1 exec tofu plan -concise -out=plans/"${1}.plan"
