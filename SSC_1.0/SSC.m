function [Missrate, Grps] = SSC(X, s, r, Cst, ProjM, OptM, lambda, n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input:
% X: data matrix, col->sample, row->observation
% s: truth
% Cst: 1 for affine subspace
% ProjM: projection method
% OptM: optimization method, {'L1Perfect','L1Noise','Lasso','L1ED'}
% lambda: regularization parameter for 'Lasso' and 'L1Noise'
% n: number of estimated clusters
% K: number of coefficients to build the similarity graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clc, clear all, close all
sdm = [length(find(s==1)) length(find(s==2)) length(find(s==3))];
% K = max(sdm); %Number of top coefficients to build the similarity graph, enter K=0 for using the whole coefficients
K = 0;
% if Cst == 1
%     K = max(sdm) + 1; %For affine subspaces, the number of coefficients to pick is dimension + 1 
% end

Xp = DataProjection(X,r,ProjM);
CMat = SparseCoefRecovery(Xp,Cst,OptM,lambda);
[CMatC,sc,OutlierIndx,Fail] = OutlierDetection(CMat,s);
if (Fail == 0)
    CKSym = BuildAdjacency(CMatC,K);
    Grps = SpectralClustering(CKSym,n);
    Grps = bestMap(sc,Grps);
    Missrate = sum(sc(:) ~= Grps(:)) / length(sc);
    save Lasso_001.mat CMat CKSym Missrate Fail
else
    save Lasso_001.mat CMat Fail
end