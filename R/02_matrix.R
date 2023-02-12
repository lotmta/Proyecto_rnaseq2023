# Cargo recount3
library("recount3")

# Cargamos nuestro rse
load('raw-data/rse_gene_SRP199678.RData')

# Revisamos la calidad de los samples
rse_gene_SRP199678$assigned_gene_prop <- rse_gene_SRP199678$recount_qc.gene_fc_count_all.assigned / rse_gene_SRP199678$recount_qc.gene_fc_count_all.total
hist(rse_gene_SRP199678$assigned_gene_prop)
# Como todos son de buena calidad (gene_prop > 0.6 en todos) no hay necesidad de eliminar alguno

# Vemos los niveles de expresión de los genes para eliminar aquellos que no son expresados
gene_means <- rowMeans(assay(rse_gene_SRP199678, "counts"))
summary(gene_means)

rse_gene_SRP199678 <- rse_gene_SRP199678[gene_means > 0.1, ]

# Guardo los datos filtrados
save(rse_gene_SRP199678, file = 'processed-data/rse_gene_SRP199678.RData')

# Exploro los atributos del rse para ver cuales usare en mi análisis
rse_gene_SRP199678 <- expand_sra_attributes(rse_gene_SRP199678)

colData(rse_gene_SRP199678)[
    ,
    grepl("^sra_attribute", colnames(colData(rse_gene_SRP199678)))
]

# Para mi análisis, usare la edad y el genotipo en cuanto al gen cx3cr1, por lo que los pasare a factor
# para poder usarlos en el modelo
rse_gene_SRP199678$sra_attribute.age <- factor(rse_gene_SRP199678$sra_attribute.age)
rse_gene_SRP199678$sra_attribute.cx3cr1_genotype <- factor(tolower(rse_gene_SRP199678$sra_attribute.cx3cr1_genotype))

# Hago un summary
summary(as.data.frame(colData(rse_gene_SRP199678)[
    ,
    grepl("^sra_attribute.[age|cx3cr1_genotype]", colnames(colData(rse_gene_SRP199678)))
]))

