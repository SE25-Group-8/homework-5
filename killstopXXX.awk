#!/usr/bin/awk -f

# List of stop words
BEGIN {
    stopwords["is"]; stopwords["the"]; stopwords["in"]; stopwords["but"];
    stopwords["can"]; stopwords["a"]; stopwords["that"]; stopwords["it"];
    stopwords["for"]; stopwords["on"]; stopwords["with"]; stopwords["as"];
    stopwords["this"]; stopwords["was"]; stopwords["at"]; stopwords["by"];
    stopwords["an"]; stopwords["be"]; stopwords["from"]; stopwords["or"];
    stopwords["are"]; stopwords["to"]; stopwords["of"];
}

{
    new_line = ""
    for (i = 1; i <= NF; i++) {
        word = $i
        if (!(word in stopwords)) {
            new_line = new_line (new_line == "" ? "" : " ") word
        }
    }
    print new_line
}