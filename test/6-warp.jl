begin
    oldids, newids = quadwarpmap(0.9, 2560);
    plt1 = plot(oldids, oldids, label="origin mapping");
    plot!(oldids, newids, label="quadwarp mapping")
    xlabel!("input indices");
    ylabel!("output indices")

    oldids, newids = sqrtwarpmap(0.3, 2560);
    plt2 = plot(oldids, oldids, label="origin mapping");
    plot!(oldids, newids, label="sqrtwarp mapping")
    xlabel!("input indices");
    ylabel!("output indices")

    oldids, newids = sinwarpmap(4, 0.7, 1024);
    plt3 = plot(oldids, oldids, label="origin mapping");
    plot!(oldids, newids, label="sinwarp mapping")
    xlabel!("input indices");
    ylabel!("output indices")

    oldids, newids = abssinwarpmap(3, 0.8, 2560);
    plt4 = plot(oldids, oldids, label="origin mapping");
    plot!(oldids, newids, label="abssinwarp mapping")
    xlabel!("input indices");
    ylabel!("output indices")

    plot(plt1, plt2, plt3, plt4, layout=(2,2),
         fg_legend = :transparent,
         bg_legend = :transparent)

    gui();sleep(dt);
end

psqrt = sqrtwarp(p, 0.7);
pquad = quadwarp(p, 0.7);
plt1 = plot(f, p, label="clean", fg_legend = :transparent, linewidth=2); 
plot!(f, psqrt, label="sqrtwarp", framestyle=:zerolines);
plot!(f, pquad, label="quadwarp", framestyle=:zerolines);
psin =    sinwarp(p, 30, 0.9);
pabs = abssinwarp(p, 8, 0.9);
plt2 = plot(f, p, label="clean", fg_legend = :transparent, linewidth=2); 
plot!(f, psin, label="sinwarp", framestyle=:zerolines);
plot!(f, pabs, label="abssinwarp", framestyle=:zerolines);
plot(plt1, plt2, layout=(2,1))
gui();sleep(dt);

Xsqrt = sqrtwarp(X, 0.6, dim=1);
Xquad = quadwarp(X, 0.6, dim=1);
plt1  = heatmap(hcat(X, ones(1024,1), Xsqrt, ones(1024,1), Xquad), ticks=nothing)
annotate!(125,     900, "clean", :white)
annotate!(125+250, 900, "sqrtwarp",  :white)
annotate!(125+500, 900, "quadwarp",   :white)
Xsin =    sinwarp(X, 2, 0.9, dim=1);
Xabs = abssinwarp(X, 2,-0.9, dim=1);
plt2 = heatmap(hcat(X, ones(1024,1), Xsin, ones(1024,1), Xabs), ticks=nothing)
annotate!(125,     900, "clean", :white)
annotate!(125+250, 900, "sinwarp",  :white)
annotate!(125+500, 900, "abssinwarp",   :white)
plot(plt1, plt2, layout=(2,1))
gui();sleep(dt);

Xsqrt = sqrtwarp(X, 0.6, dim=2);
Xquad = quadwarp(X, 0.6, dim=2);
plt1  = heatmap(hcat(X, ones(1024,1), Xsqrt, ones(1024,1), Xquad), ticks=nothing)
annotate!(125,     900, "clean", :white)
annotate!(125+250, 900, "sqrtwarp",  :white)
annotate!(125+500, 900, "quadwarp",   :white)
Xsin =    sinwarp(X, 2, 0.9, dim=2);
Xabs = abssinwarp(X, 2,-0.9, dim=2);
plt2 = heatmap(hcat(X, ones(1024,1), Xsin, ones(1024,1), Xabs), ticks=nothing)
annotate!(125,     900, "clean", :white)
annotate!(125+250, 900, "sinwarp",  :white)
annotate!(125+500, 900, "abssinwarp",   :white)
plot(plt1, plt2, layout=(2,1))
gui();sleep(dt);

