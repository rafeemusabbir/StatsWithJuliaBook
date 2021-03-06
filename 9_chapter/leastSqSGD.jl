using Random, Distributions, Plots; pyplot()

n = 10^3
beta0 = 2.0
beta1 = 1.5
sigma = 2.5

Random.seed!(1958)
xVals = rand(0:0.01:5,n)
yVals = beta0 .+ beta1*xVals + rand(Normal(0,sigma),n)

pts = []
eta = 10^-3.
b = [0,0]
push!(pts,b)
for k in 1:10^4
    i = rand(1:n)
    g = [   2(b[1] + b[2]*xVals[i]-yVals[i]),
            2*xVals[i]*(b[1] + b[2]*xVals[i]-yVals[i])  ]
    global b -= eta*g
    push!(pts,b)
end

p1 = plot(first.(pts),last.(pts), c=:black,lw=0.5,label="SGD path")
p1 = scatter!([b[1]],[b[2]],c=:blue,ms=5,label="SGD")
p1 = scatter!([beta0],[beta1],
	c=:red,ms=5,label="Actual",
	xlabel="Beta0", ylabel="Beta1",
	ratio=:equal, xlims=(0,2.5), ylims=(0,2.5))

p2 = scatter(xVals,yVals, c=:black, ms=1, label="Data points")
p2 = plot!([0,5],[b[1],b[1]+5b[2]], c=:blue,label="SGD")
p2 = plot!([0,5],[beta0,beta0+5*beta1],	c=:red, label="Actual",
	xlims=(0,5), ylims=(-5,15))

plot(p1, p2, legend=:topleft, size=(800, 400))
