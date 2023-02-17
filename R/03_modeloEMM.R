# Cargo recount3
library("recount3")

# Cargamos nuestro rse
load('processed-data/rse_gene_SRP199678.RData')

rse_gene_SRP199678 <- expand_sra_attributes(rse_gene_SRP199678)

# Creo el sample data para Explore Model Matrix
sampleData <- data.frame(
    age_months = rse_gene_SRP199678$sra_attribute.age,
    genotype = rse_gene_SRP199678$sra_attribute.cx3cr1_genotype )

# Uso EMM y lo ploteo
vd <- ExploreModelMatrix::VisualizeDesign(
    sampleData = sampleData,
    designFormula = ~ 0 + genotype + age_months,
    textSizeFitted = 7
)

cowplot::plot_grid(plotlist = vd$plotlist)

