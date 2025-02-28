BEGIN {
    # Initialize array to store top words
    top_word_count = 0;
    current_para = "";
    para_count = 0;
}

# First pass: read the top words file
PASS == 1 {
    top_words[top_word_count++] = $0;
    next;
}

# Second pass: process the cleaned text file
PASS == 2 {
    # Starting a new paragraph when we have a non-empty line
    if (NF > 0) {
        # Concatenate words with the current paragraph
        if (current_para != "") {
            current_para = current_para " " $0;
        } else {
            current_para = $0;
        }
    } 
    # Empty line marks the end of a paragraph
    else if (current_para != "") {
        # Process the completed paragraph
        process_paragraph();
        current_para = "";
    }
}

# Function to process a paragraph
function process_paragraph() {
    split(current_para, words, " ");
    
    # Reset counts for this paragraph
    for (i = 0; i < top_word_count; i++) {
        paragraph_counts[para_count, i] = 0;
    }
    
    # Count occurrences of each top word in the paragraph
    for (i in words) {
        for (j = 0; j < top_word_count; j++) {
            if (words[i] == top_words[j]) {
                paragraph_counts[para_count, j]++;
            }
        }
    }
    
    para_count++;
}

END {
    # Process the last paragraph if there's any content
    if (current_para != "") {
        process_paragraph();
    }
    
    # Output the header (top words comma-separated)
    for (i = 0; i < top_word_count; i++) {
        printf("%s%s", top_words[i], (i < top_word_count - 1 ? "," : ""));
    }
    printf("\n");
    
    # Output the frequency table (one line per paragraph)
    for (i = 0; i < para_count; i++) {
        for (j = 0; j < top_word_count; j++) {
            printf("%d%s", paragraph_counts[i, j], (j < top_word_count - 1 ? "," : ""));
        }
        printf("\n");
    }
}