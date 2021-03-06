function randthreshold_mean_speed(nag, nleads, kmax , runs, mint, maxt)
    addpath('../src/graph_generation/')
    addpath('../src/threshold_consensus/')
    ks = 01:01:kmax ;
    fprintf('# Voter consensus\n# Num agents        %i\n# Num leaders       %i\n# Threshold min     %f\n# Threshold max     %f\n# Runs              %i\n',nag, nleads, mint, maxt, runs) ;
    for k=ks
        s = zeros(runs,1) ;
        for r=1:runs
            g = fixed_outdegre_graph(nag, k) ;
            g = regularize_graph(g) ;
            sp = speed_threshold( nag, nleads, g, mint, maxt) ;
            s(r) = sp ;
            end
        %x = arrayfun( @(r) polarization_voters( nag, nleads, k) , 1:runs) ;
        fprintf('%i\t%f\t%f\n',k,mean(s),std(s) ) ;
        end
    end

function [speed xm] = speed_threshold( nag, nleads, graph, mint, maxt)
    % Choose random leaders
    leaders = zeros(1,nag) ;
    th = mint + (maxt-mint)*rand(1,nag) ;
    leaders(randperm(nag)(1:nleads)) = ones(1,nleads) ;
    % Initial state
    x =zeros(1,nag) ;
    x(leaders==1) = ones(1,nleads) ;

    niter=5 ;
    xm = zeros(niter,1) ;
    for iter=1:niter
        xold = x ;
        x = update_leader(graph, x, th, leaders) ;
        xm(iter) = mean(x(leaders==0)) ;
        end
    speed = ols(xm, (1:niter)') ;
    end
