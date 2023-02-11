# Cargo recount3
library("recount3")


# Cambio la url
options(recount3_url = "https://recount-opendata.s3.amazonaws.com/recount3/release")


# Cargo los datos del estudio, en este caso SRP133502 ( scRNAseq of aging dermal fibroblasts )
proj_info <- subset(
    available_projects(organism = 'mouse'),
    project == "SRP133502" & project_type == "data_sources"
)


# Se crea el rse
rse_gene_SRP133502 = create_rse(proj_info)


# Convierto las cuentas por nucleotido a cuentas por lectura
assay(rse_gene_SRP133502, "counts") <- compute_read_counts(rse_gene_SRP133502)

# Con expand hago la info mas facil de usar
rse_gene_SRP133502 <- expand_sra_attributes(rse_gene_SRP133502)
