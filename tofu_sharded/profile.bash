#!/bin/bash
ls ../fruits | xargs -n 1 -P 8 ./plan_with_workspace.bash