# running model in rjags
#  assumes rjags library has been installed, first one needs to install
# the jags software form http://mcmc-jags.sourceforge.net/
# using R version R 3.1.2 GUI 1.65 Snow Leopard build (6833)
# more efficient to run code section by section between comments
# instead of sourcing all the data file.
#  set your working directory to where files calibration.txt, forwardMgCa.txt,
# and predictive T.
# setwd("/pathofmydirectory/")

library(rjags)
# reading data 
d=read.table("calibration.txt")
data=list(N=186,MgCa=d[,1],T=d[,2], S=d[,3], deltaCO3=d[,4],clean=d[,5])
# compiling model
jags.m <- jags.model(file = "forwardMgCa.txt", data = data, n.chains =1 )
# update model iterations (burn-in)
update(jags.m, 50000)
# save samples in out object
out=jags.samples(jags.m,c("alpha0","alpha1", "alpha2","alpha3", "alpha4","tau"),n.iter=50000,thin=50)
# matrix with samples for my own graphics
m=cbind(as.vector(out$alpha0),as.vector(out$alpha1),as.vector(out$alpha2),as.vector(out$alpha3),as.vector(out$alpha4),as.vector(out$tau))
names=c("alpha0","alpha1", "alpha2","alpha3", "alpha4","tau")
# histogram and density plots
par(mfrow=c(2,3))
for(i in 1:6){ hist(m[,i],probability=T,xlab=names[i],main=" ");
  de=density(m[,i]); lines(de$x,de$y, col="red",lwd=2)}
# trace plots
par(mfrow=c(2,3))
for(i in 1:6){ plot(m[,i],type="l",xlab="iteration",ylab=names[i], main=" ",col="grey") }
# acf plots
par(mfrow=c(2,3))
for(i in 1:6){ acf(m[,i],lag=100,main=names[i]) }
# lets now the run predictive model for T (not fast)
samp=500
Tres=matrix(NA,nrow=186,ncol=samp)
for(i in 1:samp)
{
data=list(N=186,MgCap=d[,1], Sp=d[,3], Dp=d[,4],cleanp=d[,5],
alpha0=m[i,1], alpha1=m[i,2], alpha2=m[i,3],
alpha3=m[i,4], alpha4=m[i,5], tau=m[i,6] )
jags.m <- jags.model(file = "predictiveT.txt", data = data, n.chains =1 )
T=jags.samples(jags.m,c("Tpred"),100)
t=as.vector(T$Tpred)
t=matrix(t,nrow=186,ncol=100)
Tres[,i]=t[,100]
}
# considered the first 20 cases only
Tr=Tres[1:20,]
# transformed into a MCMC object
T=mcmc(t(Tr),start=1,end=500)
# produce trace plots and densities of samples
#
plot(T)
# now will use all data points
T=mcmc(t(Tres),start=1,end=500)
s=summary(T)
par(mfrow=c(1,1))
plot(d[,2],s$statistics[,1],pch="*",xlab="observed", ylab="predicted",col="blue",ylim=c(5,35))
for(i in 1:186)
{
  points(d[i,2],s$quantile[i,1],pch="-",col="red")
  points(d[i,2],s$quantile[i,5],pch="-",col="red")
  lines(c(d[i,2],d[i,2]), c(s$quantile[i,1],s$quantile[i,5]),col="red")
}  
