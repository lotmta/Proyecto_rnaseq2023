# Cargo recount3
library("recount3")

# Cargamos nuestro rse
load('processed-data/rse_gene_SRP199678.RData')

rse_gene_SRP199678 <- expand_sra_attributes(rse_gene_SRP199678)

# Creo el sample data para Explore Model Matrix
sampleData <- data.frame(
    age = rse_gene_SRP199678$sra_attribute.age,
    genotype = rse_gene_SRP199678$sra_attribute.cx3cr1_genotype )

# Uso EMM y lo ploteo
vd <- ExploreModelMatrix::VisualizeDesign(
    sampleData = sampleData,
    designFormula = ~ 0 + genotype + age,
    textSizeFitted = 4
)

cowplot::plot_grid(plotlist = vd$plotlist)

# Nota: estaría bien que en la edad el orden en la grafica fuera 2 months, 1 year, 2 years, porque como toma
# el orden numerico pone 1 year, 2 months, 2 years, pero no se como cambiarlo para que haga algo
