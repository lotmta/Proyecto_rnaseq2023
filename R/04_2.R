# Cargo recount3 y ggplot2
library("recount3")
library("ggplot2")
library("edgeR")
library("limma")
library("pheatmap")

# Cargamos nuestro rse
load('processed-data/rse_gene_SRP199678.RData')

rse_gene_SRP199678 <- expand_sra_attributes(rse_gene_SRP199678)

# Normalizacion de datos
dge <- DGEList(
    counts = assay(rse_gene_SRP199678, "counts"),
    genes = rowData(rse_gene_SRP199678)
)
dge <- calcNormFactors(dge)

# Creamos los 9 grupos
rse_gene_SRP199678$categoria <- paste(rse_gene_SRP199678$sra_attribute.age, rse_gene_SRP199678$sra_attribute.cx3cr1_genotype)

# Vemos la diferencia de expresion entre los 9 grupos, los grupos con 2 meses tiende a tener mas
# outliers con menor expresion, en especial 2 months KO, pero la diferencia no es tan grande
ggplot(as.data.frame(colData(rse_gene_SRP199678)), aes(y = assigned_gene_prop, x = categoria)) +
    geom_boxplot() +
    theme_bw(base_size = 7) +
    ylab("Assigned Gene Prop") +
    xlab("Grupo")
# Mismo problema que con el EMM, orden numérico hace rara la visualización

mod <- model.matrix( ~ sra_attribute.cx3cr1_genotype + assigned_gene_prop,
                     data = colData(rse_gene_SRP199678)
)
colnames(mod)

# Usamos limma para el analisis de expresion diferencial
vGene <- voom(dge, mod, plot = TRUE)

exprs_heatmap <- vGene$E[rank(de_results$adj.P.Val) <= 100, ]

df <- as.data.frame(colData(rse_gene_SRP199678)[, c('sra_attribute.cx3cr1_genotype', 'categoria')])
colnames(df) <- c('Genotipo', 'categoria')

pheatmap(
    exprs_heatmap,
    cluster_rows = TRUE,
    cluster_cols = TRUE,
    show_rownames = FALSE,
    show_colnames = FALSE,
    annotation_col = df
)

