#!/bin/bash
RED='\033[0;31m'
NC='\033[0m' # No Color
function red {
	printf "${RED}$1${NC}\n"
}
