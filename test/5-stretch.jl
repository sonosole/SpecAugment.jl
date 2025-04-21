pstretch1 = stretch(p, 0.2, 0.7, dim=1);
pstretch2 = stretch(p, 0.7, 0.2, dim=1);
plt1=plot(f, p, label="clean", fg_legend = :transparent); 
plot!(f, pstretch1, label="stretched", framestyle=:zerolines)
plt2=plot(f, p, label="clean", fg_legend = :transparent); 
plot!(f, pstretch2, label="stretched", framestyle=:zerolines)
plot(plt1, plt2, layout=(2,1))
gui();sleep(dt);

Xstretch1 = stretch(X, 0.1, 0.6, dim=1);
Xstretch2 = stretch(X, 0.6, 0.1, dim=1);
heatmap(hcat(X, ones(1024,1), Xstretch1, ones(1024,1), Xstretch2), ticks=nothing)
annotate!(125,     900, "clean",     :white)
annotate!(125+250, 900, "stretched", :white)
annotate!(125+500, 200, "stretched", :white)
gui();sleep(dt);

Xstretch1 = stretch(X, 0.5, 0.9, dim=2);
Xstretch2 = stretch(X, 0.9, 0.5, dim=2);
heatmap(hcat(X, ones(1024,1), Xstretch1, ones(1024,1), Xstretch2), ticks=nothing)
annotate!(125,     900, "clean",     :white)
annotate!(125+250, 900, "stretched", :white)
annotate!(125+500, 900, "stretched", :white)
gui();sleep(dt);
