function(pval, cov, lambda=seq(0.85,0.9,0.05), cuts=round(log2(length(pval))+1),
                  plot=TRUE){
  
  if(length(cuts)==1){
    br=quantile(cov,seq(0, 1, length.out=cuts+1))
    brs=cbind(br[1:cuts],br[2:(cuts+1)])
    mids=apply(brs, 1, mean)
    grp=list(quantcut(cov,cuts,labels = round(mids,2)))
  }else{
    br=cuts
    ncuts=length(cuts)
    brs=cbind(br[1:ncuts],br[2:(ncuts+1)])
    mids=apply(brs, 1, mean)
    grp=list(quantcut(cov,ncuts,labels = round(mids,2)))
  }
  
  res=data.frame(lam=NULL, Group.1=NULL, x=NULL)
  for(i in 1:length(lambda)){
    y=as.numeric(pval>lambda[i])
    res=rbind(res,cbind(lam=lambda[i],
                        aggregate(x=y, by=grp, FUN=function(x){mean(x)/(1-lambda[i])})))
  }
  colnames(res)=c("lambda",'group','prop')
  res$group=as.numeric(as.character(res$group))
  
  if(plot){
  ggplot(res, aes(x=group, y=prop, group=lambda)) +
    geom_line(aes(color=lambda)) + 
    geom_hline(yintercept = 1, linetype='dotdash') +
    labs(x='covariate', y='null proportion')
  }else{
    return(res)
  }
}
