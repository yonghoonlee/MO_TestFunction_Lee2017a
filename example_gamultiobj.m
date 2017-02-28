function example_gamultiobj
% Script (in function form) for testing the function with MOGA algorithm.
% This script performs in following order:
% (1) Demonstration of true solution of the test function,
% (2) Demonstration of finding solution of the test function using MOGA,
% (3) Demonstration of contours of the objective and constraint functions.
%
% As we see in the demonstration (2), around 200,000 times of function
% evaluations are required to get the Pareto set similar to true solution.
% If the objective function is computationally expensive, it will not be
% practical for optimization. Thus, we need an efficient algorithm to
% reduce the number of function evaluations.
%
%   [] = EXAMPLE_GAMULTIOBJ()

    xLast = []; % Last place computeall was called
    myf = []; % Use for objective at xLast
    myc = []; % Use for nonlinear inequality constraint
    myceq = []; % Use for nonlinear equality constraint
    
    fun = @objfun; % the objective function, nested below
    cfun = @constr; % the constraint function, nested below
    
    fg1 = figure('Color',[1 1 1]);
    
    % Common options for MOGA (GAMULTIOBJ) solver
    opt = optimoptions('gamultiobj','Display','iter',...
        'PopulationSize',2000,'MaxGenerations',1,...
        'ParetoFraction',0.1,'CrossoverFraction',0.5,...
        'PlotFcn',@gaplotpareto,...
        'ConstraintTolerance',5e-5,'FunctionTolerance',1e-5,...
        'UseVectorized',false,'UseParallel',false);
    
    %======================================================================
    % (1) DEMONSTRATION OF TRUE SOLUTION OF THE TEST FUNCTION
    %======================================================================
    % Load known solution
    load('example_truesolution.mat','truesolution');
    opt = optimoptions(opt, 'InitialPopulation', truesolution);
    % Run MOGA
    [~,fTrue,~,~] ...
        = gamultiobj(fun,2,[],[],[],[],[-5;-5],[5;5],cfun,opt);
    figure(fg1); subplot(2,2,1);
    plot(fTrue(:,1),fTrue(:,2),'k.','MarkerSize',12); hold on;
    
    
    %======================================================================
    % (2) DEMONSTRATION OF FINDING SOLUTION OF THE TEST FUNCTION USING MOGA
    %======================================================================
    % Remove known solution
    opt = optimoptions(opt, 'InitialPopulation', []);
    rng(1);
    
    % Run MOGA for first 20 generations
    opt = optimoptions(opt, 'MaxGenerations', 20);
    [xMOGA,fMOGA,~,~] ...
        = gamultiobj(fun,2,[],[],[],[],[-5;-5],[5;5],cfun,opt);
    figure(fg1); subplot(2,2,1);
    plot(fMOGA(:,1),fMOGA(:,2),'c^','MarkerSize',8);
    
    % Run MOGA for another 20 generations
    opt = optimoptions(opt, 'MaxGenerations', 20);
    opt = optimoptions(opt, 'InitialPopulation', xMOGA);
    [xMOGA,fMOGA,~,~] ...
        = gamultiobj(fun,2,[],[],[],[],[-5;-5],[5;5],cfun,opt);
    figure(fg1); subplot(2,2,1);
    plot(fMOGA(:,1),fMOGA(:,2),'mo','MarkerSize',8);
    
    % Run MOGA for additional 60 generations
    opt = optimoptions(opt, 'MaxGenerations', 60);
    opt = optimoptions(opt, 'InitialPopulation', xMOGA);
    [~,fMOGA,~,~] ...
        = gamultiobj(fun,2,[],[],[],[],[-5;-5],[5;5],cfun,opt);
    figure(fg1); subplot(2,2,1);
    plot(fMOGA(:,1),fMOGA(:,2),'rx','MarkerSize',8);
    
    
    %======================================================================
    % (3) DEMONSTRATION OF FINDING SOLUTION OF THE TEST FUNCTION USING MOGA
    %======================================================================
    n = 80;
    x1 = linspace(-5,5,n);
    y1 = linspace(-5,5,n);
    [x2,y2] = meshgrid(x1,y1);
    x3 = reshape(x2,numel(x2),1);
    y3 = reshape(y2,numel(y2),1);
    xi = [x3, y3];

    [f,c,~] = multiobj_optim_testfunction_lee2017(xi);
    fr1 = reshape(f(:,1),n,n);
    fr2 = reshape(f(:,2),n,n);
    cr = reshape(c(:,1),n,n);
    
    figure(fg1); subplot(2,2,2);
    surf(x2,y2,cr);
    
    figure(fg1); subplot(2,2,3);
    contourf(x1,y1,fr1);

    figure(fg1); subplot(2,2,4);
    contourf(x1,y1,fr2);
    
    
    %======================================================================
    % Plot labels and legends
    %======================================================================
    figure(fg1); subplot(2,2,1);
    legend('true','g=20','g=40','g=100',...
        'Location','southwest','box','off');
    title('Pareto set');
    
    figure(fg1); subplot(2,2,2);
    title('Constraint');
    
    figure(fg1); subplot(2,2,3);
    title('Objective 1');
    
    figure(fg1); subplot(2,2,4);
    title('Objective 2');
    
    % Save plot requires EXPORT_FIG
    eval(['export_fig ','example_plot',' -png -r200']);
    
    %======================================================================
    % Nested functions
    %======================================================================
    function y = objfun(x)
        if ~isequal(x,xLast)
            [myf,myc,myceq] = multiobj_optim_testfunction_lee2017(x);
            xLast = x;
        end
        y = myf;
    end

    function [c,ceq] = constr(x)
        if ~isequal(x,xLast)
            [myf,myc,myceq] = multiobj_optim_testfunction_lee2017(x);
            xLast = x;
        end
        c = myc;
        ceq = myceq;
    end
end