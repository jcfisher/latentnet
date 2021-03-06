\name{ergmm}
\alias{ergmm}
\alias{latent}
\alias{latentcluster}
\title{Fit a Latent Space Random Graph Model}
\description{
  \code{\link{ergmm}} is used to fit latent space and latent space cluster random network models, 
    as described by Hoff, Raftery and Handcock (2002),
    Handcock, Raftery and Tantrum (2005), and Krivitsky, Handcock,
    Raftery, and Hoff (2009).
  \code{\link{ergmm}} can return either a Bayesian model fit
  or the two-stage MLE.
}
\usage{
ergmm(formula, response=NULL, family="Bernoulli",fam.par=NULL,
      control=ergmm.control(), user.start=list(), prior=ergmm.prior(),
      tofit=c("mcmc", "mkl", "mkl.mbc", "procrustes",
      "klswitch"), Z.ref=NULL, Z.K.ref=NULL, seed=NULL,
      verbose=FALSE)
}
\arguments{
  
  \item{formula}{An \R formula object, of the form
    \code{g ~ <term 1> + <term 2> ...},
    where \code{g} is a network object or a matrix that can be coerced to a
    network object, and \code{<term 1>}, \code{<term 2>}, etc., are each 
    terms for the model. See \code{\link{terms.ergmm}} for the terms
    that can be fitted.
    To create a network object in \R, use the \code{network} function,
    then add nodal attributes to it using \code{set.vertex.attribute} 
    if necessary.

    Note that, as in \code{\link{lm}}, the model will include an
    \code{\link{intercept}} term. This behavior can be overridden by
    including a \code{-1} or \code{+0} term in the formula, and a
    \code{\link[=terms.ergmm]{1(mean=...,var=...)}} term can be used
    to set a prior different from default.}
  
  \item{response}{An optional edge attribute that serves as the response
    variable. By default, presence (1) or absence (0) of an edge in
    \code{g} is used.}
  \item{family}{A character vector specifying the conditional distribution of
    each edge value. See \link{families.ergmm} for the currently
    implemented families.}
  \item{fam.par}{For those families that require additional parameters,
    a list.}
  \item{control}{The MCMC parameters that do not affect the posterior
    distribution such as the sample size, the proposal variances, and
    tuning parameters, in the
    form of a named list. See \code{\link{ergmm.control}} for more
    information and defaults.}
  \item{user.start}{An optional initial configuration parameters for
    MCMC in the form of a list. By default, posterior mode conditioned on cluster assignments
    is used. It is permitted to only supply some of the parameters of a
    configuration. If this is done, the remaining paramters are fitted
    conditional on those supplied.}
  \item{prior}{The prior parameters for the model being fitted in the
    form of a named list. See \link{terms.ergmm} for the names to use.
    If given, will override those given in the
    formula terms, making it useful as a convenient way to store and reproduce a
    prior distribution. The list or prior parameters can also be
    extracted from an \link[=ergmm.object]{ERGMM fit object}. See
    \code{\link{ergmm.prior}} for more information.}
  \item{tofit}{A character vector listing some subset of "pmode",
      "mcmc", "mkl", "mkl.mbc", "mle","procrustes", and "klswitch",
      defaulting to all of the above, instructing \code{\link{ergmm}}
      what should be returned as a part of the
      \link[=ergmm.object]{ERGMM fit object}. Omiting can be used to
      skip particular steps in the fitting process. If the requested
      procedure or output depends on some other procedure or output not
      explictly listed, the dependency will be resolved automatically.}
  \item{Z.ref}{If given, used as a reference for Procrustes analysis.}
  \item{Z.K.ref}{If given, used as a reference for label-switching.}
  \item{seed}{If supplied, random number seed.}
  \item{verbose}{If this is \code{TRUE} (or \code{1}), causes information to be
    printed out about the progress of the fitting, particularly initial
    value generation. Higher values lead to greater verbosity.}
}
\value{
  \code{\link{ergmm}} returns an object of class \code{\link[=ergmm.object]{ergmm}}
  containing the information about the posterior.
}
\seealso{network, set.vertex.attributes, set.network.attributes,
  summary.ergmm, terms.ergmm, families.ergmm}
\references{
   Mark S. Handcock, Adrian E. Raftery and Jeremy Tantrum (2002).
  \emph{Model-Based Clustering for Social Networks.} Journal of the Royal
  Statistical Society: Series A, 170(2), 301-354.
  
  Peter D. Hoff,  Adrian E. Raftery and Mark S. Handcock (2002).
  \emph{Latent space approaches to social network analysis.} 
  Journal of the American Statistical Association, 97(460), 
  1090-1098.
  
  Pavel N. Krivitsky, Mark S. Handcock, Adrian E. Raftery, and Peter
  D. Hoff (2009). \emph{Representing degree distributions, clustering, and
  homophily in social networks with latent cluster random effects
  models}.  Social Networks, 31(3), 204-213.

 Pavel N. Krivitsky and Mark S. Handcock (2008).
 \emph{Fitting Position Latent Cluster Models for Social Networks with
 \code{latentnet}}. Journal of Statistical Software, 24(5).
}
\examples{
\donttest{
#
# Use 'data(package = "latentnet")' to list the data sets in a
#
data(package="latentnet")
#
# Using Sampson's Monk data, lets fit a 
# simple latent position model
#
data(sampson)
samp.fit <- ergmm(samplike ~ euclidean(d=2))
#
# See if we have convergence in the MCMC
mcmc.diagnostics(samp.fit)
#
# Plot the fit
#
plot(samp.fit)
#
# Using Sampson's Monk data, lets fit a latent clustering random effects model
#
samp.fit2 <- ergmm(samplike ~ euclidean(d=2, G=3)+rreceiver)
#
# See if we have convergence in the MCMC
mcmc.diagnostics(samp.fit2)
#
# Plot the fit.
#
plot(samp.fit2, pie=TRUE)
}
}
\keyword{graphs}
