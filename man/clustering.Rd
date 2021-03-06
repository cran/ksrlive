% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ksrlive.R
\name{clustering}
\alias{clustering}
\title{Return clustering assignments produced by tight.clust}
\usage{
clustering(tightclust, data)
}
\arguments{
\item{tightclust}{list of objects returned by the tight.clust function}

\item{data}{data frame of time course of substrates, each substrate is a row}
}
\value{
named list containing named vectors of cluster assignments, names correspond to rownames in data
and names of list are kinase identifiers

}
\description{
\code{clustering} returns vectors of clustering assignments
}
\details{
The function clustering creates a named list of cluster assignments for substrates.
}
\examples{
data(phosphonetworkdf)
data(datakin)
# only need what is present in data
phosphonetwork_data <- phosphonetwork_df[
phosphonetwork_df[,"SUB_IDENT"] \%in\% data_kin[,"SUB_IDENT"]
,]
fam <- list(akt = c("P31749", "P31751"))
kin_data_fam_exc <- KSR.list(phosphonetwork_data[, c("SUB_IDENT", "KIN_ACC_ID")], 
                             kinasefamilies = fam,
                             exclusive = TRUE)
# only do for Akt and Mtor (P31749, P42345)
substrate_profiles <- lapply(kin_data_fam_exc[c("P31749", "P42345")], 
function(x){data_kin[match(x, data_kin[,"SUB_IDENT"]),1:9]})

substrate_profiles_random <- lapply(substrate_profiles, 
function(x){rbind(x, random.data(x, random.seed = 123))})

target <- 3
substrate_profiles_tight <- lapply(substrate_profiles_random, function(x){
tightClust::tight.clust(x, target = target, k.min = 7, resamp.num = 100, random.seed = 12345)
})

kin_clust<- mapply(function(x,y){clustering(x, y)}, 
                        substrate_profiles_tight, substrate_profiles, SIMPLIFY = FALSE)
}

