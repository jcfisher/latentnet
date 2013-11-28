.mcmc.diagnostics <- function(x, ...)
  UseMethod("mcmc.diagnostics")
  
.mcmc.diagnostics.default <- function(x,...){
  stop("An object must be given as an argument ")
}

mcmc.diagnostics.ergmm <- function(x,which.diags=c("cor","acf","trace","raftery"),
                                   burnin=FALSE,
                                   which.vars=NULL,
                                   vertex.i=c(1),...){
  extraneous.argcheck(...)
  
  if(is.null(x[["sample"]])) stop("MCMC was not run for this ERGMM fit.")

  x <- as.mcmc.list.ergmm(x,burnin,which.vars,vertex.i)
  oldask=par("ask")
  on.exit(par(ask=oldask))
  par(ask=dev.interactive())

  if("cor" %in% which.diags){
    x.ac<-autocorr(x,lags=0:1)
    for(chain in seq(along=x.ac)){
      cat(paste("Chain",chain,"\n"))
      didnt.mix<-colnames(x.ac[[chain]][2,,])[which(is.nan(diag(x.ac[[chain]][2,,])))]
      if(any(is.nan(diag(x.ac[[chain]][2,,]))))
        cat(paste("WARNING: Variables",
                  paste(didnt.mix,collapse=", "),
                  "did not mix AT ALL. MCMC should be rerun with different proposal parameters!\n"))
      for(i in 1:2){
        cat(paste(dimnames(x.ac[[chain]])[[1]][i],"\n"))
        print(x.ac[[chain]][i,,])
        cat("\n")
      }
    }
  }

  if("acf" %in% which.diags)
    autocorr.plot(x)

  if("trace" %in% which.diags){
    plot(x)
  }

  if("raftery" %in% which.diags){
    rd<-try(raftery.diag(x,r=0.0125))
    if(inherits(rd,"try-error")){
      cat("Raftery-Lewis diagnostic failed, likely due to some of the vairables not mixing at all.\n MCMC should be rerun.\n")
      return(invisible(NULL))
    }
    print(rd)
    invisible(rd)
  }
}

# We have to redefine this generic, since we need to pass additional arguments to as.mcmc().
as.mcmc<-function(x,...) UseMethod("as.mcmc")
                                     # copying function defintions from coda
as.mcmc.default <- function(x, ...) if (is.mcmc(x)) x else mcmc(x)
as.mcmc.list.default <- function(x, ...) if (is.mcmc.list(x)) x else mcmc.list(x)
as.mcmc.mcmc.list <- function(x, ...) {
  if (nchain(x) == 1) 
    return(x[[1]])
  else stop("Can't coerce mcmc.list to mcmc object:\n more than 1 chain")
}

as.mcmc.ergmm<-as.mcmc.list.ergmm<-function(x,burnin=FALSE,
                             which.vars=NULL,
                             vertex.i=c(1),...){
  extraneous.argcheck(...)
  n<-network.size(x[["model"]][["Yg"]])
  G<-x[["model"]][["G"]]
  d<-x[["model"]][["d"]]
  p<-x[["model"]][["p"]]
  start<-x[["control"]][["burnin"]]
  thin<-x[["control"]][["interval"]]

  as.mcmc.list.ergmm.par.list(if(burnin) x[["burnin.samples"]][[burnin]] else x[["sample"]],
                              if(is.null(which.vars)) list(lpY=1,
                                                           beta=1:p,
                                                           Z=cbind(rep(vertex.i,each=d),rep(1:d,length(vertex.i))),
                                                           sender=vertex.i,
                                                           receiver=vertex.i,
                                                           sociality=vertex.i) else which.vars,
                              start,thin)
}
