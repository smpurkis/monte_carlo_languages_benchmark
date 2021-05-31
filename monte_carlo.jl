using LoopVectorization
using Distributed
# addprocs(4)

@everywhere function XYinCirle_ev(radius, diameter)
    x = (rand() - 0.5) * diameter
    y = (rand() - 0.5) * diameter
    r = sqrt(x^2 + y^2)
    if r <= radius
        return 1
    end
    return 0
end

function XYinCirle(radius, diameter)
    x = (rand() - 0.5) * diameter
    y = (rand() - 0.5) * diameter
    r = sqrt(x^2 + y^2)
    if r <= radius
        return 1
    end
    return 0
end

function estimate_pi(nMC)
    radius = 1.
    diameter = 2. * radius
    n_circle = 0
    for i in 1:nMC
        n_circle += XYinCirle(radius, diameter)
    end
    return (n_circle / nMC) * 4.
end

function estimate_pi_dist(nMC)
    @everywhere radius = 1.
    @everywhere diameter = 2. * radius
    n_circle = @sync @distributed (+) for i in 1:nMC
        XYinCirle_ev(radius, diameter)
    end
    return (n_circle / nMC) * 4.
end

function estimate_pi_thread(nMC)
    radius = 1.
    diameter = 2. * radius
    n_circles = BitArray(undef, nMC)
    Threads.@threads for i in 1:nMC
        n_circles[i] = XYinCirle(radius, diameter)
    end
    n_circle = sum(n_circles)
    return (n_circle / nMC) * 4.
end

function estimate_pi_dot(nMC)
    radius = 1.
    diameter = 2. * radius
    n_circle = 0
    rand_x = rand(nMC)
    rand_y = rand(nMC)
    x = (rand_x .- 0.5) .* diameter
    y = (rand_y .- 0.5) .* diameter
    r = (x.^2 .+ y.^2).^0.5
    n_circle = sum(r .< radius)
    # @simd for i in 1:nMC
    #     n_circle += XYinCirle(radius, diameter)
    # end
    return (n_circle / nMC) * 4.
end

nMC = 10000000
n = 10
# estimate_pi_thread(1000)
# @time for j in 1:n
#     pi_est = estimate_pi_thread(nMC)
#     # println(pi_est)
# end

estimate_pi(1000)
@time for j in 1:n
    pi_est = estimate_pi(nMC)
    # println(pi_est)
end

# estimate_pi_dot(100)
# @time for j in 1:10
#     pi_est = estimate_pi_dot(nMC)
#     println(pi_est)
# end

