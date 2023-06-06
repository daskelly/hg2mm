test_that("function works from human side", {
    hgenes <- c("WDR53", "RETNLB", "RETNLA", "ZSCAN5B");
    expect_equal(
        hg2mm(hgenes, query = "human", target = "mouse", method = "one2one"),
        tibble::tibble(your_gene = hgenes,
                       mouse = c("Wdr53", "NA", "NA", "NA")))
    expect_equal(
        hg2mm(hgenes, query = "human", target = "mouse", method = "unique_query"),
        tibble::tibble(your_gene = c("WDR53", rep("RETNLB", 3), "RETNLA", "ZSCAN5B"),
                       mouse = c("Wdr53", "Retnlb", "Retnlg", "Retnla", "NA", "NA")))
    expect_equal(
        hg2mm(hgenes, query = "human", target = "mouse", method = "unique_target"),
        tibble::tibble(your_gene = hgenes,
                       mouse = c("Wdr53", "NA", "NA", "Zscan5b")))
    expect_equal(
        hg2mm(hgenes, query = "human", target = "mouse", method = "all"),
        tibble::tibble(your_gene = c("WDR53", rep("RETNLB", 3), "RETNLA", "ZSCAN5B"),
                       mouse = c("Wdr53", "Retnlb", "Retnlg", "Retnla", "NA", "Zscan5b")))
    
})

test_that("function works from mouse side", {
    mgenes <- c("Wdr53", "Retnla", "Zscan5b");
    expect_equal(
        hg2mm(mgenes, query = "mouse", target = "human", method = "one2one"),
        tibble::tibble(your_gene = mgenes,
                       human = c("WDR53", "NA", "NA")))
    expect_equal(
        hg2mm(mgenes, query = "mouse", target = "human", method = "unique_query"),
        tibble::tibble(your_gene = c("Wdr53", "Retnla", rep("Zscan5b", 4)),
                       human = c("WDR53", "NA", "ZSCAN5A", "ZSCAN5B", "ZSCAN5C", "ZSCAN5DP")))
    expect_equal(
        hg2mm(mgenes, query = "mouse", target = "human", method = "unique_target"),
        tibble::tibble(your_gene = mgenes,
                       human = c("WDR53", "RETNLB", "NA")))
    expect_equal(
        hg2mm(mgenes, query = "mouse", target = "human", method = "all"),
        tibble::tibble(your_gene = c("Wdr53", "Retnla", rep("Zscan5b", 4)),
                       human = c("WDR53", "RETNLB", "ZSCAN5A", "ZSCAN5B", "ZSCAN5C", "ZSCAN5DP")))
    
})
