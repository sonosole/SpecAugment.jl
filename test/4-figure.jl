pslim = slimorfat(p, ratio=0.7);
pfatt = slimorfat(p, ratio=2);
plot(f, p, label="clean", fg_legend = :transparent, linewidth=2); 
plot!(f, pslim, label="slim", framestyle=:zerolines); 
plot!(f, pfatt, label="fat", xlabel="frequency Hz")
gui();sleep(dt);

Xslim = slimorfat(X, dims=(1,2), ratio=0.8);
Xfatt = slimorfat(X, dims=(1,2), ratio=4);
heatmap(hcat(X, ones(1024,1), Xslim, ones(1024,1), Xfatt), ticks=nothing)
annotate!(125,     900, "clean", :white)
annotate!(125+250, 900, "slim",  :white)
annotate!(125+500, 900, "fat",   :white)
gui();sleep(dt);

