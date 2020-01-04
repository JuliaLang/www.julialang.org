using TestImages, Images, OffsetArrays, CoordinateTransformations, Rotations

# This is an alternative means of accomplishing the same rotation as
# described in the blog post, here by translating the starting image
# directly so that 0,0 is the center of the rotation.
img = OffsetArray(testimage("cameraman"), (-125, -250))
tfm = LinearMap(RotMatrix(pi/6))
img_rotated = warp(img, tfm)
save("cameraman.png", img)
save("cameraman_rotated.png", clamp01nan.(img_rotated))
cv = colorview(RGB, paddedviews(0, img, img_rotated, img)...)
save("cameraman_overlay.png", clamp01nan.(cv))
pimg = parent(img)
tfmcntr = recenter(RotMatrix(pi/6), center(pimg))
img_rotated_cntr = warp(pimg, tfmcntr)
cvc = colorview(RGB, paddedviews(0, pimg, img_rotated_cntr, pimg)...)
save("cameraman_overlay_center.png", clamp01nan.(cvc))
inds = map(intersect, indices(img), indices(img_rotated))
cvi = colorview(RGB, img[inds...], img_rotated[inds...], img[inds...])
save("cameraman_overlay_interior.png", clamp01nan.(cvi))

using Plots
pyplot()
ps = []
isfirst = true
for (i, kern) in enumerate((centered([1]), OffsetArray([1], 2:2), OffsetArray([1], -5:-5)))
    a = 1:8
    af = imfilter(a, kern, Fill(0))
    p = plot(a, color="black", xlims=(-3,9), ylims=(0,8), grid=false, linewidth=2, label=isfirst?"input":"", xticks=i == 3 ? (-3:3:9) : nothing)
    plot!(p, -indices(kern, 1), 0:1, color="blue", linewidth=2, label=isfirst?"kernel":"")
    plot!(p, af, color="red", label=isfirst?"output":"")
    push!(ps, p)
    isfirst = false
end
savefig(plot(ps..., layout=(3,1)), "filtering.eps")
