clear all
load('dataset/Hopkins155/1R2RC/1R2RC_truth.mat');
y0 = y(1:2, :, :);
X = zeros(58, 459);
for pt = 1:459
    layer = y0(:, pt, :);
    X(:, pt) = layer(:);
end
SSC(X, s, 12, 1, 'PCA', 'Lasso', 0.001, 3)