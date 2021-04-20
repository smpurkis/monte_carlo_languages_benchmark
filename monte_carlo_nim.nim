import nimpy
import random
import math
randomize()

proc estimate_pi_nim(nMC:int32): float64 {.exportpy.} =
    const radius = 1.0
    const diameter = 2 * radius
    var n_circle = 0
    for i in 1..nMC:
        var x = (rand(1.0) - 0.5) * diameter
        var y = (rand(1.0) - 0.5) * diameter
        var r = pow(pow(x, 2) + pow(y, 2), 0.5)
        if r <= radius:
            n_circle = n_circle + 1
    return 4.0 * float(n_circle) / float(nMC)