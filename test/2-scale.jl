prand = randscale(p, 0.8, 1.2, dims=1);
psin = sinscale(p, 0.7, 1.3, dims=1);
plot(f, p, label="clean", fg_legend = :transparent, ylims=(-0.1, 5)); 
plot!(f, prand, label="randscale", framestyle=:zerolines); 
plot!(f, psin, label="sinscale", xlabel="frequency Hz")
gui();sleep(dt);

Xrand = randscale(X, 0.2, 1.5, dims=(1,2));
Xsin = sinscale(X, 0.3, 1.6, dims=(1,2));
heatmap(hcat(X, ones(1024,1), Xrand, ones(1024,1), Xsin), ticks=nothing)
annotate!(125,     900, "clean",      :white)
annotate!(125+250, 900, "randscale",  :white)
annotate!(125+500, 900, "sinscale",   :white)
gui();sleep(dt);
