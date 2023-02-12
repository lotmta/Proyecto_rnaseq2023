# Cargo recount3
library("recount3")

# Cambio la url
options(recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release")

# Cargo los datos del estudio, en este caso SRP199678 ( Cx3cr1-deficient microglia exhibit a premature aging transcriptome )
proj_info <- subset(
    available_projects(organism = 'mouse'),
    project == "SRP199678" & project_type == "data_sources"
)

# Se crea el rse
rse_gene_SRP199678 = create_rse(proj_info)

# Convierto las cuentas por nucleotido a cuentas por lectura
assay(rse_gene_SRP199678, "counts") <- compute_read_counts(rse_gene_SRP199678)

# Guardamos el rse para poder usarlo en otros scripts
save(rse_gene_SRP199678, file = 'raw-data/rse_gene_SRP199678.RData')

