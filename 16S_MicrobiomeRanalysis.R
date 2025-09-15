# Load required packages
# For data manipulation 
library(tidyverse)
#For handling DNA sequences and writing FASTA files
library(Biostrings)
#Read input files
taxonomy <- read.csv("C:/Users/Dorcas Chebet/Q2_ONT/taxonomy.csv",
                     header = TRUE, stringsAsFactors = FALSE)

sequences <- read.csv("C:/Users/Dorcas Chebet/Q2_ONT/dna-sequences.csv",
                      header = TRUE, stringsAsFactors = FALSE)
# checking columns in taxonomy table
colnames(taxonomy)
#Split taxonomy string into levels
taxonomy_split <- taxonomy %>%
  separate(taxonomy,
           into = c("Kingdom","Phylum","Class","Order","Family","Genus","Species"),
           sep = ";", fill = "right", remove = FALSE)
#Keep only Bacteria
taxonomy_bacteria <- taxonomy_split %>%
  filter(Kingdom == "d__Bacteria")
#Separating the  classified vs unclassified at Genus level
classified_genus <- taxonomy_bacteria %>%
  filter(!is.na(Genus) & Genus != "")

unclassified_genus <- taxonomy_bacteria %>%
  filter(is.na(Genus) | Genus == "")
#Merge unclassified taxa with sequences using OTUID
unclassified_sequences <- merge(unclassified_genus, sequences,
                                by.x = "OTUID", by.y = "Sequence_ID")
#Keep only ID + Sequence
fasta_seqs <- unclassified_sequences %>%
  select(OTUID, Sequence)
#Write unclassified sequences to FASTA
dna <- DNAStringSet(setNames(fasta_seqs$Sequence, fasta_seqs$OTUID))
writeXStringSet(dna, filepath = "C:/Users/Dorcas Chebet/Q2_ONT/unclassified_sequences.fasta")

write.csv(classified_genus, 
          "C:/Users/Dorcas Chebet/Q2_ONT/classified_genus.csv", 
          row.names = FALSE)
