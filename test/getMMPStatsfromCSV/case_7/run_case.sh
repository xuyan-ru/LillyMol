#!/bin/bash

if [ -z "$LILLYMOL_HOME" ] || [ -z "$BUILD_DIR" ]; then 
    echo "System variables LILLYMOL_HOME and BUILD_DIR are required for running the test"
    echo "Please export LILLYMOL_HOME (local path to LillyMol code)"
    echo "Please export BUILD_DIR (the folder name under the bin folder after build)"
    echo "Example: export LILLYMOL_HOME=/home/user/LillyMol"
    echo "Example: export BUILD_DIR=Linux-gcc-7.2.1" 
    exit 1
else
    BIN_DIR="$LILLYMOL_HOME/contrib/script/py/mmp/"
fi

test_command=getMMPStatsfromCSV
case=case_7
case_id="Case 7"

test_top="$LILLYMOL_HOME/test"
test_cmd_top="$test_top/$test_command"

diff_tool=../../fileDiff.sh

command="$BIN_DIR/$test_command.py"

if [ ! -x "$command" ]; then
    echo "$command is not executable or does not exist"
    exit 1
fi

in="$test_cmd_top/$case/in/dalkeJCM2018_ChEMBL_hERGsubset.csv"
out=dalke_c7.pairs
gold_out="$test_cmd_top/$case/out/dalke_c7.pairs.sum"

echo "Testing: $command"

$command -i "$in" -o "$out"  -s SMILES -n CHEMBL_ID -a hERG_pIC50 -A DIFF50 -p ALL -t 2>>err.txt
# restrict file size as too large for git
head -n 100 $out.sum > $out.sum.bak
mv $out.sum.bak $out.sum
$diff_tool $out.sum $gold_out
ret=$?

if [ $ret -eq 1 ]
then
    echo "$case_id : TEST PASS"
else
    echo "$case_id : TEST FAIL"
fi

rm -f $out $out.sum
rm -f err.txt