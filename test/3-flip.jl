pflip = flip(p, dims=1);
plot(f, p, label="clean", fg_legend = :transparent, ylims=(-0.1, 5)); 
plot!(f, pflip, label="flipped", framestyle=:zerolines)
gui();sleep(dt);

Xflip = flip(X, dims=(1,2));
heatmap(hcat(X, ones(1024,1), Xflip))
annotate!(125,     900, "clean",   :white)
annotate!(125+250, 900, "flipped", :black)
gui();sleep(dt);
