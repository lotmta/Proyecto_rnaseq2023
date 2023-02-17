# Cargo recount3 y ggplot2
library("recount3")
library("ggplot2")
library("edgeR")
library("limma")
library("pheatmap")

# Cargamos nuestro rse y lo expandimos
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

rse_gene_SRP199678$sra_attribute.age <- as.numeric(rse_gene_SRP199678$sra_attribute.age)
rse_gene_SRP199678$sra_attribute.cx3cr1_genotype <- factor(tolower(rse_gene_SRP199678$sra_attribute.cx3cr1_genotype))


# Vemos la diferencia de expresion entre los 9 grupos, los grupos con 2 meses tiende a tener mas
# outliers con menor expresion, en especial 2 months KO, pero la diferencia no es tan grande
ggplot(as.data.frame(colData(rse_gene_SRP199678)), aes(y = assigned_gene_prop, x = categoria)) +
    geom_boxplot() +
    theme_bw(base_size = 7) +
    ylab("Assigned Gene Prop") +
    xlab("Grupo")
# Orden numérico hace rara la visualización (12,2,24 en vez de 2,12,24)

# Para que se guarde en una resolucion decente
ggsave(path = 'plots/',filename= 'Asigned_Gene_Prop.png',device='tiff', dpi=250)


# Creamos el modelo para las graficas de expresion diferencial
mod <- model.matrix( ~ 0 + sra_attribute.age + sra_attribute.cx3cr1_genotype + assigned_gene_prop,
                    data = colData(rse_gene_SRP199678)
)
colnames(mod)

# Usamos limma para el analisis de expresion diferencial
vGene <- voom(dge, mod, plot = TRUE)

eb_results <- eBayes(lmFit(vGene))

de_results <- topTable(
    eb_results,
    coef = 2,
    number = nrow(rse_gene_SRP199678),
    sort.by = "none"
)
dim(de_results)

# Hacemos el heatmap
exprs_heatmap <- vGene$E[rank(de_results$adj.P.Val) <= 100, ]

df <- as.data.frame(colData(rse_gene_SRP199678)[, c('sra_attribute.age', 'sra_attribute.cx3cr1_genotype', 'categoria')])
colnames(df) <- c("Edad", 'Genotipo','Categoria')


pheatmap(
    exprs_heatmap,
    cluster_rows = TRUE,
    cluster_cols = TRUE,
    show_rownames = FALSE,
    show_colnames = FALSE,
    annotation_col = df
)

ggsave(path = 'plots/',filename= 'heatmap.png',device='tiff', dpi=250)

# Algo puede estar mal, no hay relación entre fenotipo y el nivel de expresión, probablemente un error de mi parte.
# Pero si hay relación entre la edad, si no estoy mal yo, el genotipo no tiene relación

# Hago volcano plot para ver en que genes hay mayor diferencia de expresión
volcanoplot(eb_results, coef = 2, highlight = 2, names = de_results$gene_name)
# Hrnpa2b1 y Hnrnpk

# Creo una funcion a la que le doy un gen de interés y me regresa una gráfica de expresión comparando
# los 9 grupos. La guarda directamente al directorio, no se muestra directamente en pantalla
findGeneExp <- function(geneName){
    # Busco su ID
    ID <- rowData(rse_gene_SRP199678)$gene_id[rowData(rse_gene_SRP199678[,'SRR9139049'])$gene_name == geneName]

    # Creo un rse con solo ese gen, esto para hacer una comparación de expresión con los grupos con solo este
    rse_singlGene <- rse_gene_SRP199678[rownames(rse_gene_SRP199678) == ID]

    singlGeneAnalisis <- data.frame(
        geneCat = rse_singlGene$categoria,
        expValue = assay(rse_singlGene)[,]
    )

    ggplot(singlGeneAnalisis,aes(y = expValue, x = geneCat)) +
        geom_boxplot() +
        ggtitle(paste('Expresion de',geneName)) +
        theme_bw(base_size = 7) +
        ylab("Nivel de Expresion") +
        xlab("Grupo")

    # Para que se guarde en una resolucion decente
    ggsave(path = 'plots/',filename= paste(geneName, 'ExpPlot.png', sep =''),device='tiff', dpi=250)


}

# La llamo para Hnrnpa2b1
findGeneExp('Hnrnpa2b1')
# Parece que la diferencia de expresión se debe a unos outliers, en general es casi la misma

# La llamo para Hnrnpk
findGeneExp('Hnrnpk')
