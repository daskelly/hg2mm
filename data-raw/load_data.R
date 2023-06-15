# Load data to be used by the package
# This is following methods for working with internal package 
# data that are outlined at https://r-pkgs.org/data.html

hg2mm_db <- readr::read_tsv("data-raw/HOM_MouseHumanSequence.rpt.gz")

## ALL mouse genes have symbols associated:
# filter(hg2mm_db, `Common Organism Name` == 'mouse, laboratory') %>%
#     pull(Symbol) %>% is.na() %>% sum()
## ALL human genes have symbols associated:
# filter(hg2mm_db, `Common Organism Name` == 'human') %>%
#     pull(Symbol) %>% is.na() %>% sum()

## Wrangle data to make it easier to match orthologs
ortho <- dplyr::group_by(hg2mm_db, `DB Class Key`) %>%
    ## get genes with >=1 ortholog in both human AND mouse
    dplyr::filter(dplyr::n() > 1) %>%
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
hg2mm.ortho <- dplyr::group_by(ortho, `DB Class Key`) %>%
    tidyr::pivot_wider(names_from = `Common Organism Name`, 
                       values_from = Symbol, values_fn = list) %>%
    dplyr::rename(mouse = `mouse, laboratory`) %>%
    dplyr::ungroup() %>%
    dplyr::select(-`DB Class Key`) %>%
    tidyr::unnest(c(mouse, human))

## Make a tibble of exact one-to-one gene matches between human-mouse:
hg2mm.one2one <- dplyr::group_by(hg2mm.ortho, mouse) %>% 
    dplyr::filter(dplyr::n() == 1) %>%
    dplyr::group_by(human) %>% dplyr::filter(dplyr::n() == 1)

## Make a table of matches between one human gene and 1+ mouse genes
## We DON'T want instances where 1 mouse gene maps to multiple human
## e.g. filter(ortho, mouse == 'Pla2g4b')
hg2mm.unique_human <- dplyr::group_by(hg2mm.ortho, mouse) %>% 
    dplyr::filter(dplyr::n() == 1)

## Make a table of matches between one mouse gene and 1+ human genes
## We DON'T want instances where 1 human gene maps to multiple mouse
## e.g. filter(ortho, human == 'RETNLB')
hg2mm.unique_mouse <- dplyr::group_by(hg2mm.ortho, human) %>% 
    dplyr::filter(dplyr::n() == 1)


usethis::use_data(hg2mm.ortho, hg2mm.one2one, hg2mm.unique_human, 
                  hg2mm.unique_mouse, overwrite = TRUE, internal = TRUE)
