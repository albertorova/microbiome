# # Instalar phyloseq (solo la primera vez)
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("phyloseq")

# Asegúrate de que las librerías necesarias estén cargadas
library(phyloseq)
library(ggplot2)
library(dplyr)
library(viridis)

args <- commandArgs(trailingOnly = TRUE)
# args ahora es un vector de caracteres con todos los argumentos pasados después del script

# Puedes acceder a tu argumento con args[1], args[2], etc.
input_file <- args[1]

# Usa la variable input_file directamente sin comillas
df <- read.csv(input_file, sep="\t", strip.white = TRUE, stringsAsFactors = FALSE, row.names = 1)

##########################################################################

#Crear objeto phyloseq
metaphlanToPhyloseq <- function(
    tax,
    metadat=NULL,
    simplenames=TRUE,
    roundtointeger=FALSE,
    split="|"){
  ## tax is a matrix or data.frame with the table of taxonomic abundances, rows are taxa, columns are samples
  ## metadat is an optional data.frame of specimen metadata, rows are samples, columns are variables
  ## if simplenames=TRUE, use only the most detailed level of taxa names in the final object
  ## if roundtointeger=TRUE, values will be rounded to the nearest integer
  xnames = rownames(tax)
  shortnames = gsub(paste0(".+\\", split), "", xnames)
  if(simplenames){
    rownames(tax) = shortnames
  }
  if(roundtointeger){
    tax = round(tax * 1e4)
  }
  x2 = strsplit(xnames, split=split, fixed=TRUE)
  taxmat = matrix(NA, ncol=max(sapply(x2, length)), nrow=length(x2))
  colnames(taxmat) = c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species", "Strain")[1:ncol(taxmat)]
  rownames(taxmat) = rownames(tax)
  for (i in 1:nrow(taxmat)){
    taxmat[i, 1:length(x2[[i]])] <- x2[[i]]
  }
  taxmat = gsub("[a-z]__", "", taxmat)
  taxmat = phyloseq::tax_table(taxmat)
  otutab = phyloseq::otu_table(tax, taxa_are_rows=TRUE)
  if(is.null(metadat)){
    res = phyloseq::phyloseq(taxmat, otutab)
  }else{
    res = phyloseq::phyloseq(taxmat, otutab, phyloseq::sample_data(metadat))
  }
  return(res)
}

#Crear objeto phyloseq
physeq <- metaphlanToPhyloseq(df)

#############################################################################

# Utiliza psmelt() para derretir los datos del objeto phyloseq a un dataframe
df_melted <- psmelt(physeq)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
k <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Kingdom)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Kingdom") +
  theme(axis.text.x = element_text(angle = 0))

print(k)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
p <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Phylum)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Phylum") +
  theme(axis.text.x = element_text(angle = 0))

print(p)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
c <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Class)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Class") +
  theme(axis.text.x = element_text(angle = 0))

print(c)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
o <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Order)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Order") +
  theme(axis.text.x = element_text(angle = 0))

print(o)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
f <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Family)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Family") +
  theme(axis.text.x = element_text(angle = 0))

print(f)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
g <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Genus)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Genus") +
  theme(axis.text.x = element_text(angle = 0))

print(g)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
s <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Species)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Species") +
  theme(axis.text.x = element_text(angle = 0))

print(s)

# Ahora crea un gráfico de barras apiladas con la abundancia relativa
t <- ggplot(df_melted, aes(x = Sample, y = Abundance, fill = Strain)) +
  geom_bar(stat = "identity", position = "fill") +
  scale_fill_viridis_d(option = "D") +  # Paleta de colores tipo arcoíris para datos discretos
  theme_minimal() +
  labs(x = "Sample", y = "Relative Abundance", fill = "Strain") +
  theme(axis.text.x = element_text(angle = 0))

print(t)

