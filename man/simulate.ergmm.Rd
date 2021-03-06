\name{simulate}
\alias{simulate}
\alias{simulate.ergmm.model}
\alias{simulate.ergmm}
\title{Draw from the distribution of an Exponential Random Graph Mixed Model}
\usage{
\method{simulate}{ergmm}(object, nsim = 1, seed = NULL,\dots)
\method{simulate}{ergmm.model}(object,nsim=1,seed=NULL,par,prior=list(),\dots)
}
\description{
  If passed a \code{\link[=ergmm.object]{ergmm}} fit object, \code{simulate} is used to simulate networks from the posterior of an exponetial random graph mixed model fit. Alternatively, a \code{\link[=ergmm.model.object]{ergmm.model}} object can be passed to simulate based on a particular parametr configuration.
}

\arguments{

  \item{object}{either an object of class
   \code{\link[=ergmm.object]{ergmm}} for posterior simulation, or an
   object of class \code{\link[=ergmm.model.object]{ergmm.model}} for a
   specific model.  }

 \item{nsim}{number of networks to draw (independently)}
 
 \item{seed}{random seed to use; defaults to using the current state of
   the random number generator}
 
 \item{par}{a list
   with the parameter configuration based on which to simulate}

 \item{prior}{a list
   with the prior distribution
   parameters that deviate from their defaults}

 \item{\dots}{Additional arguments. Currently unused.}
 
}

\details{
  A sample of networks is randomly drawn from the specified
  model. If a needed value of \code{par} is missing, it is generated
  from its prior distribution.
}

\value{
  If \code{nsim = 1}, \code{simulate} returns an object of class
  \code{\link[network]{network}}. Otherwise, an object of class \code{network.series} that is a list
  consisting of the following elements:
  \item{\$formula}{The formula used to generate the sample.}
  \item{\$networks}{A list of the generated networks.}
}
\seealso{\code{\link{ergmm}}, \code{ network}, \code{\link[network]{print.network}}}
\examples{
#
# Fit a short MCMC run: just the MCMC.
#
data(sampson)
gest <- ergmm(samplike ~ euclidean(d=2,G=3),
              control=ergmm.control(burnin=100,interval=5,sample.size=100),tofit="mcmc")
#
# Draw from the posterior
#
g.sim <- simulate(gest)
plot(g.sim)
#
# Draw from the first draw from the posterior
#
g.sim <- with(gest,simulate(model,par=sample[[1]],prior=prior))
plot(g.sim)
}
\keyword{graphs}
\keyword{models}
\keyword{nonlinear}
\keyword{nonparametric}
\keyword{cluster}
\keyword{datagen}