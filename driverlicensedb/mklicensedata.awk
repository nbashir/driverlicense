#!/usr/bin/awk -E
#mklicensedata.awk
# we will download a page from web and then we save a the data from the download file into another file which we will use in to our database.
# -O will will use to give the new name to the file we get from web using wget command
#wget -O newfile name weburl

BEGIN {
  webpagefile="driverlicensewikipage.html"
  webpageurl="https://en.wikipedia.org/wiki/Driver%27s_license_in_the_United_States"
  #wget -O $webpagefile $webpageurl
  ARGV[ARGC++]=webpagefile
  cellindex=-1
printf ("#statename\tlearnerpermitage\trestrictedpermitage\tfulllicenseage\n")
}

#table started at line# 148 and ends at line#679

#we need cell #1, 3, 4 and 5 of the table.
# we will use awk which work like while read loop and read each line of the table
#NR is the line number in awk. line
#/<table class="wikitable sortable">/ first action will print the line 

#NR == 148 {print}

/<table class="wikitable sortable">/ {
  #print "found our table at line " NR
  dotable=1
}

dotable == 1 && /<\/table>/ {exit}

/<tr\>/ {
  cellindex=-1
}

/<td\>/ {
  ++cellindex
}

cellindex == 0 {
  #match($0, /title="([a-zA-Z ]*) Department/, matcharray)
  match($0, /title="(New |South |North |West |Rhode |District of )?(\w+)/, matcharray)
  cellcontent=matcharray[1]matcharray[2]
  #print NR, cellcontent
  printf("%s", cellcontent)
}

cellindex >= 2 && cellindex <= 4 {
#  match($0, />(.* years)(, [0-9]+ months)?<\/td>/, matcharray)
  match($0, />([0-9]+) years(, ([0-9]+) months)?/, matcharray)
  #cellcontent=matcharray[1] matcharray[2]
years=matcharray[1]
months=matcharray[3]
agemonths=years*12+months

  #print NR, cellcontent
  printf("\t%d", agemonths)
}

cellindex == 4 {
  printf("\n")
}


#dotable == 1 {print}
