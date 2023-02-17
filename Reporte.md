# Analisis de expresion diferencial; Cx3cr1-deficient microglia exhibit a premature aging transcriptome (SRP199678)

*Lot Mateo Hernández Espinosa*


## Antecedentes
El envejecimiento es, en gran parte, todavía un misterio. No sabemos a ciencia cierta que lo provoca, que significa biologicamente su progreso, o cuales de las tantas maneras en las que se presenta a nivel celular son una consecuencia o causa de este. Una teoría relativamente recientemente nos dice que una posible causa principal de este fenómeno es la acumulación de mutaciones epigeneticas en las células, estas causan que genes sean desregulados en la célula, genes que deberían estar apagados en un tipo celular se encienden, genes esenciales para cierto tipo celular son apagados, y en general hay cambios en los niveles de expresión en todo el genoma. Estos cambios hacen que las células pierdan poco a poco su identidad y funcionen cada vez peor, lo que causa que órganos empiecen a fallar, aumenta la posibilidad de cáncer por desregulacion de oncogenes y en general causa los fenotipos que asociamos con la edad avanzada.

El estudio que voy a usar para mi análisis busca ver si mutaciones en el gen Cx3cr1 aceleran este envejecimiento epigenetico, para esto hicieron RNA seq de ratones mutantes KO para este gen, heterocigotos y WT. Si su hipótesis es cierta, deberíamos de ver como el transcriptoma de los ratones KO se "degrada" (o mas bien, la identidad de este) mas rápido que el de ratones WT. Algo como esto:

![<sup>*Ejemplo de un transcriptoma 'envejeciendo' <br />* Source: https://yankner.hms.harvard.edu/research/transcriptional-and-epigenetic-regulation-aging-brain<sup>](https://yankner.hms.harvard.edu/sites/yankner.hms.harvard.edu/files/research-project-images/Transcriptinal-and-epigenetic-regulation.png)

&nbsp;

## Datos y Modelo Estadistico
Como ya mencione, tenemos 3 tipos de ratones en cuanto a genotipo. Aquellos que no tienen Cx3cr1 (KO), aquellos con solo una copia (Het) y los controles, con ambas copias (WT). Para este análisis también tomamos en cuenta, por obvias razones, la edad de los ratones, muestras se tomaron de todos los grupos de ratones a 2, 12 y 24 meses de edad. Para tomar en cuenta todas estas variables, se agruparan los datos en 9 grupos, representados en el modelo estadístico:

![<sup>*Modelo Estadistico para el Análisis*<sup>](https://raw.githubusercontent.com/lotmta/Proyecto_rnaseq2023/master/plots/Matriz_modelo.png)

&nbsp;

## Análisis
Primero, para ver si todos los grupos tienen el mismo nivel de calidad de datos, usando como referencia la proporción de lecturas, ploteamos esto comparando los 9 grupos.

![<sup>*Proporción de lecturas por grupo*<sup>](https://raw.githubusercontent.com/lotmta/Proyecto_rnaseq2023/master/plots/Asigned_Gene_Prop.png)

Como se ve en la gráfica, todos los grupos tienen una proporción muy similar en cuanto a lecturas. Parece haber unos outliers con bajas lecturas, pero no llegan a menos de 0.6 por lo que aun es bastante alto, solo se ve por debajo ya que la gráfica no comienza con y en 0. Los ratones de 2 meses de edad si tienden ligeramente a tener mas lecturas, el genotipo no parece tener relación.

&nbsp;

&nbsp;

Realice también un voom plot, parece si haber diferencia de expresión significativa, con muchos genes cayendo por encima de 1.5, pero puede que se deba al numero elevado de grupos en el modelo.

![<sup>*voom plot*<sup>](https://raw.githubusercontent.com/lotmta/Proyecto_rnaseq2023/master/plots/voom.png)

&nbsp;

Para ver ya a gran escala si hay diferencias notables en el transcriptoma entre los grupos, ya sea por genotipo, edad o la combinación de estos, realice el siguiente heatmap.

![<sup>*Heatmap*<sup>](https://raw.githubusercontent.com/lotmta/Proyecto_rnaseq2023/master/plots/Heatmap.png)

Como se puede ver en el heatmap, el genotipo parece tener no impacto en los niveles de expresión de los ratones. Lo único que tiene algún tipo de relación es la edad de estos, sin importar el genotipo, individuos viejos parecen tener mayor expresión en general que los jóvenes. Esto queda con lo que ya sabíamos sobre el envejecimiento y la acumulación de ruido epigenetico, pero es decepcionante para la hipótesis de la investigación.

&nbsp;
&nbsp;

Después de estos resultado decepcionantes, hice un volcano plot para ver que genes tienen mayor expresión diferencial en los grupos y poder checar si esta diferencia tiene alguna relacion con el genotipo.

![<sup>*Volcano plot*<sup>](https://raw.githubusercontent.com/lotmta/Proyecto_rnaseq2023/master/plots/volcanoPlot.png)

Decidí ver a fondo los 2 mejores genes de aquí ya que parecen ser familiares; Hnrnpa2b1 y Hnrnpk.

&nbsp;
&nbsp;

Obtuve los datos y grafique los resultados comparando todos los grupos, pero los resultados hablan por si mismos:

![<sup>*Comparacion de expresion del gen Hnrnpa2b1ExpPlot*<sup>](https://raw.githubusercontent.com/lotmta/Proyecto_rnaseq2023/master/plots/Hnrnpa2b1ExpPlot.png)

![<sup>*Comparacion de expresion del gen HnrnpkExpPlot*<sup>](https://raw.githubusercontent.com/lotmta/Proyecto_rnaseq2023/master/plots/HnrnpkExpPlot.png)

Dejando de lado unos outliers, la expresión es casi igual para todos los grupos. Si algo, la diferencia mayor fue entre edad de nuevo, el genotipo no tiene ninguna relación con los cambios mínimos que se ven.

## Conclusiones
La hipótesis propuesta por el estudio parece ser completamente errónea. No hay ninguna prueba de que alguna alteración al gen Cx3cr1 (o hasta eliminarlo) tenga un efecto significante en el transcriptoma, o en la velocidad en la que este envejece. Se logra ver como la edad altera este, pero sin ninguna influencia del genotipo.

Es posible que me haya equivocado en cuanto a mi análisis de datos y esto haya causado los resultados decepcionantes, yo mismo tengo dudas fuertes en cuanto a varios de mis pasos, pero como están las cosas, el análisis muestra que Cx3cr1 no tiene efecto en cuanto al envejecimiento epigenetico.
