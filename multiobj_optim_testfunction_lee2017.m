function [f,c,ceq] = multiobj_optim_testfunction_lee2017(x)
% A Multiobjective Optimization Test Function used in the conference paper:
% Lee Y.H., Corman, R.E., Ewoldt, R.H., and Allison, J.T.,
%   "A Multiobjective Adaptive Surrogate Modeling Optimization (MO-ASMO)
%   Framework Using Efficient Sampling Strategies," ASME IDETC/CIE, 2017.
% Author: Yong Hoon Lee (http://yonghoonlee.com, <a
% href="mailto:ylee196@illinois.edu">ylee196@illinois.edu</a>)
%
% This is a multiobjective optimization test function, which has a small
% feasible design domain across the wavy and large design space.
% Also, the solution is discontinuous in design space as well as objective
% function space. Thus, this test problem is difficult to be solved with
% some of multiobjective optimization algorithms.
%
%   [F,C,CEQ] = MULTIOBJ_OPTIM_TESTFUNCTION_LEE2017(X)
%       where:  F = Objective function value
%               C = Inequality constraints (C <= 0)
%               CEQ = Equality constraints (CEQ = 0)
%
%   See also GAMULTIOBJ

    f1 = (3*sin(2.5*x(:,1))-2*x(:,1)).*cos(x(:,2)).*exp(-(1e-3)*x(:,2).^2);
    f2 = (3/8)*(0.3*abs(x(:,1))).^(19/25).*(sin(5*x(:,2)).*x(:,2));
    f = [f1, f2];
    c = (100*(x(:,2)-x(:,1).^2).^2+(x(:,1)-1).^2)-1;
    ceq = [];
end