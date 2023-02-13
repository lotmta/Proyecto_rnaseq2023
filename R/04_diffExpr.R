# Cargo recount3 y ggplot2
library("recount3")
library("ggplot2")

# Cargamos nuestro rse
load('processed-data/rse_gene_SRP199678.RData')

# Creamos los 9 grupos
rse_gene_SRP199678$categoria <- paste(rse_gene_SRP199678$sra_attribute.age, rse_gene_SRP199678$sra_attribute.cx3cr1_genotype)
