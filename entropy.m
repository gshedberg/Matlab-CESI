function [S, S_s] = entropy(varargin) % entropy (S) and sensible Entropy (S_s)
Ru = 8.314;
T = varargin{1};
X =[];
if length(varargin)>1
    X = varargin{2};
    N = varargin{3};
end
n = length(T);
S = zeros(n,7);
CH4 = [2.9428148; 2.5153728e-3; 7.9085839e-6; -4.7495483e-9; 1.4244910e-13; 4.5714579;];
CO = [3.262451; 1.5119409e-3; -3.881755e-6; 5.581944e-9; -2.474951e-12; 4.848897;];
CO2 = [2.275724; 9.922072e-3; -1.0409113e-5; 6.866686e-9; -2.117280e-12; 10.188488];
H2 = [3.298124; 8.249441e-4; -8.143015e-7; -9.475434e-11; 4.134872e-13; -3.294094;];
H2O = [3.386842; 3.474982e-3; -6.354696e-6; 6.968581e-9; -2.506588e-12; 2.590232];
N2 = [3.298677; 1.4082404e-3; -3.963222e-6; 5.64151e-9; -2.444854e-12; 3.950372;];
O2 = [3.212936; 1.1274864e-3; -5.756150e-7; 1.3138773e-9; -8.768554e-13; 6.034727;];

T1 = log(T);
T2 = T;
T3 = (T.^2)/2; 
T4 = (T.^3)/3; 
T5 = (T.^4)/4; 
T6 = linspace(1,1,n);
for i=1:1:n
    S(i,1) = sum([T1(i)*CH4(1); T2(i)*CH4(2); T3(i)*CH4(3); T4(i)*CH4(4); T5(i)*CH4(5); T6(i)*CH4(6);]);
    S(i,2) = sum([T1(i)*CO(1); T2(i)*CO(2); T3(i)*CO(3); T4(i)*CO(4); T5(i)*CO(5); T6(i)*CO(6);]);
    S(i,3) = sum([T1(i)*CO2(1); T2(i)*CO2(2); T3(i)*CO2(3); T4(i)*CO2(4); T5(i)*CO2(5); T6(i)*CO2(6);]);
    S(i,4) = sum([T1(i)*H2(1); T2(i)*H2(2); T3(i)*H2(3); T4(i)*H2(4); T5(i)*H2(5); T6(i)*H2(6);]);
    S(i,5) = sum([T1(i)*H2O(1); T2(i)*H2O(2); T3(i)*H2O(3); T4(i)*H2O(4); T5(i)*H2O(5); T6(i)*H2O(6);]);
    S(i,6) = sum([T1(i)*N2(1); T2(i)*N2(2); T3(i)*N2(3); T4(i)*N2(4); T5(i)*N2(5); T6(i)*N2(6);]);
    S(i,7) = sum([T1(i)*O2(1); T2(i)*O2(2); T3(i)*O2(3); T4(i)*O2(4); T5(i)*O2(5); T6(i)*O2(6);]);
end
S = S*Ru;
S_s = [S(:,1)-186.188, S(:,2)-197.548, S(:,3)-213.736, S(:,4)-130.595, S(:,5)-188.715, S(:,6)-191.511, S(:,7)-205.043];

if ~isempty(X);
    S = sum(S.*X,2).*N;
    S_s = sum(S_s.*X,2).*N;
end