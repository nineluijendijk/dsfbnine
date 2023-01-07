#' Title
#'
#' @param GenBankIDs A text file containing the GenBank identifiers of the species of interest, separated by newlines. Comments starting with # allowed.
#' @param database String with the name of the database to use.
#'
#' @return An object of class "DNAbin".
#' @export
#'
#' @examples
#' \dontrun{
#' dna <- fastaImporter(here::here("inst/extdata/GenBankIDs2.txt"))
#' }
fastaImporter <- function(GenBankIDs, database = "nucleotide"){
  species <-scan(file = GenBankIDs, what = "character", sep = "\n", comment.char = "#")
  fasta_seqs <- rentrez::entrez_fetch(db = database,
                                      id = species,
                                      rettype = "fasta")
  write(fasta_seqs,
        file="temp")
  grep("^*$", readLines("temp"), invert = TRUE, value = TRUE) %>% write(file = here::here("sequences.fasta"))
  file.remove("temp")
  dna <- ape::read.FASTA(here::here("sequences.fasta"), type = "DNA")
  file.remove("sequences.fasta")
  dna
}
