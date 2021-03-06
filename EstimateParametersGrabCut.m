%% ��������� ��������� beta, mu, kappa �� ������� �� ����� ������
%---input---------------------------------------------------------
% X: 4-� ������ ������� �������� ������
% Y: ������� ����������� MxN
% k: ���������� ������� �����������
% p: ����������� ������
% mu: ������� ������� ���������� ��� vMF
% kappa: ������� ������ ���������� ��� vMF
%---output--------------------------------------------------------
% mu: ����� �������� ����������, ������� LxP
% kappa: ����� �������� ����������, ������ 1xL
function [mu, kappa] = EstimateParametersGrabCut(X, Y, k, p, mu, kappa)

for l=1:k
    R = sum(X(Y(:)==l, :));
    N = sum(Y(:)==l);
    Rlen = sqrt(sum(R .^ 2));
    if R ~= 0
        mu(l, :) = R / Rlen;
    end
    
    eqn = @(x) besseli(p/2, x)/besseli(p/2-1,x) - Rlen / N;
    initval = kappa(l);
    if isnan(eqn(initval))
        fprintf('WARNING: function is NaN in initial point\n')
        initval = 10;
    end
    kappa(l) = fzero(eqn, initval);
    if kappa(l) < 0 || isnan(kappa(l))
        kappa(l) = abs(kappa(l));
        fprintf('WARNING: Lower than zero solution was found\n')
    end
end
