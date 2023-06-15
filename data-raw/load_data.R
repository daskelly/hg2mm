#' Load data to be used by the package
#'
#' @return
#'
#' @examples
#' load_data()
load_data <- function() {
    if (exists("hg2mm.hg2mm_db")) return()
    hg2mm_db <- readr::read_tsv("HOM_MouseHumanSequence.rpt.gz")
    assign("hg2mm.hg2mm_db", hg2mm_db, envir = .GlobalEnv)
    
    ## ALL mouse genes have symbols associated:
    # filter(hg2mm_db, `Common Organism Name` == 'mouse, laboratory') %>%
    #     pull(Symbol) %>% is.na() %>% sum()
    ## ALL human genes have symbols associated:
    # filter(hg2mm_db, `Common Organism Name` == 'human') %>%
    #     pull(Symbol) %>% is.na() %>% sum()
    
    ## Wrangle data to make it easier to match orthologs
    ortho <- dplyr::group_by(hg2mm_db, `DB Class Key`) %>%
        ## get genes with >=1 ortholog in both human AND mouse
        dplyr::filter(n() > 1) %>%
        dplyr::filter("human" %in% `Common Organism Name`) %>%
        dplyr::filter("mouse, laboratory" %in% `Common Organism Name`) %>%
        dplyr::ungroup() %>%
        dplyr::select(`DB Class Key`, `Common Organism Name`, Symbol) %>%
        dplyr::distinct()
    ## Is there one mouse entry for each DB Class Key??
    # group_by(ortho, `DB Class Key`) %>% 
    #     count(`Common Organism Name`) %>%
    #     pivot_wider(names_from = `Common Organism Name`, 
    #                 values_from = n) %>%
    #     pull(`mouse, laboratory`) %>% range()
    ## YES!
    ## However, there can be multiple human entries for one DB Class Key:
    ## e.g. filter(ortho, `DB Class Key` == 44052762)
    ortho <- dplyr::group_by(ortho, `DB Class Key`) %>%
        tidyr::pivot_wider(names_from = `Common Organism Name`, 
                    values_from = Symbol, values_fn = list) %>%
        dplyr::rename(mouse = `mouse, laboratory`) %>%
        dplyr::ungroup() %>%
        dplyr::select(-`DB Class Key`) %>%
        tidyr::unnest(c(mouse, human))
    assign("hg2mm.ortho", ortho, envir = .GlobalEnv)
    
    ## Make a tibble of exact one-to-one gene matches between human-mouse:
    one2one <- dplyr::group_by(ortho, mouse) %>% dplyr::filter(n() == 1) %>%
        dplyr::group_by(human) %>% dplyr::filter(n() == 1)
    assign("hg2mm.one2one", one2one, envir = .GlobalEnv)
    
    ## Make a table of matches between one human gene and 1+ mouse genes
    ## We DON'T want instances where 1 mouse gene maps to multiple human
    ## e.g. filter(ortho, mouse == 'Pla2g4b')
    unique_human <- dplyr::group_by(ortho, mouse) %>% dplyr::filter(n() == 1)
    assign("hg2mm.unique_human", unique_human, envir = .GlobalEnv)
    ## Make a table of matches between one mouse gene and 1+ human genes
    ## We DON'T want instances where 1 human gene maps to multiple mouse
    ## e.g. filter(ortho, human == 'RETNLB')
    unique_mouse <- dplyr::group_by(ortho, human) %>% dplyr::filter(n() == 1)
    assign("hg2mm.unique_mouse", unique_mouse, envir = .GlobalEnv)
}

#filter(unique_human, human == 'RETNLB')
#filter(unique_mouse, human == 'RETNLB')
#filter(unique_human, mouse == 'Zscan5b')
#filter(unique_mouse, mouse == 'Zscan5b')
