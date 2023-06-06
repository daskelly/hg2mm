hg2mm <- function(genes, 
                  query = c('human', 'mouse'),
                  target = c('mouse', 'human'), 
                  method = c("one2one", "unique_query", "unique_target", "all")
                  ) {
    # Ortholog data are from Mouse Genome Informatics at JAX
    # "one2one" means any genes that are one-to-one orthologs to each other
    # assuming query = 'human' and target = 'mouse':
    # "unique_query" returns orthologs in mouse that map to one gene in humans
    # "unique_target" returns orthologs in human that map to one gene in mouse
    # "all" means any ortholog relationships are returned
    assertthat::assert_that(is.character(genes))
    query <- match.arg(query)
    target <- match.arg(target)
    assertthat::assert_that(query != target)
    method <- match.arg(method)
    load_data()
    
    if (method == "one2one") {
        df <- one2one
    } else if (method == "unique_query") {
        df <- get(paste0("unique_", query))
        
    } else if (method == "unique_target") {
        df <- get(paste0("unique_", target))
    } else {
        assertthat::assert_that(method == 'all')
        df <- ortho
    }
    x <- tibble::tibble(your_gene = genes) %>%
        dplyr::left_join(df, by = c('your_gene' = query))
    return(x)
}
# genes <- c("WDR53", "RETNLA", "RETNLB", "INS")
# RETNLB duplicated on mouse lineage (one gene in human, many in mouse)
# hg2mm(genes, method = 'one2one')
# hg2mm(genes, method = 'all')
#
# genes <- c("Retnla", "Wdr53")
# Zscan5b is single gene in mouse but many dups in human
#

# genes <- c("RETNLB", "ZSCAN5B")
# genes <- c("Retnlb", "Zscan5b")
