#!/usr/bin/awk -E
#mkstatecode.awk
# we will download a page from web and then we save a the data from the download file into another file which we will use in to our database.
# -O will use to give the new name to the file we get from web using wget command
#wget -O newfile name weburl

BEGIN {
  webpagefile="statecodeswikipage.html"
  webpageurl="https://en.wikipedia.org/wiki/List_of_U.S._state_abbreviations"
 # system("wget -O " webpagefile " " webpageurl)
  ARGV[ARGC++]=webpagefile
  cellindex=-1

}

#table started at line# 91 and ends at line#1077

#we need cell #1 and 6 of the table.
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
  ++rowindex
}

/<td\>/ {
  ++cellindex
}

cellindex == 0 && rowindex >=4 && rowindex <=54{
  #match($0, /title="([a-zA-Z ]*) Department/, matcharray)
  match($0, /title="(New |South |North |West |Rhode |District of )?(\w+)/, matcharray)
  cellcontent=matcharray[1]matcharray[2]
  #print NR, cellcontent
  printf("\%s\t", cellcontent)
}

cellindex == 5 && rowindex >=4 && rowindex <=54{
  match($0, /">([A-Z][A-Z])/, matcharray)
  cellcontent=matcharray[1] 
  #print NR, cellcontent
  printf("%s", cellcontent)
}

cellindex == 6 {
  printf("\n")
}


#dotable == 1 {print}
