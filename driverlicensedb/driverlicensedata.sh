#!/bin/bash
#driverlicensedata.sql
#--inserting the data into agestate table
#--delete from agestate;
#truncate agestate;
let linenum=0
#  psql -U pguser -d driverlicense -c "truncate agestate"
read
while IFS=$'\t' read statename lpermitage rpermitage fpermitage; do
  unset IFS
  psql -U pguser -d driverlicense -c "insert into agestate (name, learnerpermitage, restrictedpermitage, fulllicenseage) values ('$statename' ,$lpermitage ,$rpermitage, $fpermitage)"
let linenum++
done 
psql -U pguser -d driverlicense -c "select * from agestate"
echo "Total lines $linenum"
