from time import time

import numba
import numpy as np
from monte_carlo import estimate_pi_cy
from monte_carlo_nim import estimate_pi_nim


@numba.njit
def estimate_pi_numba(nMC):
    radius = 1.
    diameter = 2. * radius
    n_circle = 0
    for i in range(nMC):
        x = (np.random.random() - 0.5) * diameter
        y = (np.random.random() - 0.5) * diameter
        r = np.sqrt(x ** 2 + y ** 2)
        if r <= radius:
            n_circle += 1
    return 4. * n_circle / nMC


@numba.njit(parallel=True)
def estimate_pi_numba_prange(nMC):
    radius = 1.
    diameter = 2. * radius
    n_circle = 0
    for i in numba.prange(nMC):
        x = (np.random.random() - 0.5) * diameter
        y = (np.random.random() - 0.5) * diameter
        r = np.sqrt(x ** 2 + y ** 2)
        if r <= radius:
            n_circle += 1
    return 4. * n_circle / nMC


nMC = 10000000
n = 10
estimate_pi_numba(1000)
s = time()
for i in range(n):
    pi_est = estimate_pi_numba(nMC)
    print(pi_est)
print(time() - s)

estimate_pi_numba_prange(1000)
s = time()
for i in range(n):
    pi_est = estimate_pi_numba_prange(nMC)
    print(pi_est)
print(time() - s)

s = time()
for i in range(n):
    pi_est = estimate_pi_cy(nMC)
    print(pi_est)
print(time() - s)

s = time()
for i in range(n):
    pi_est = estimate_pi_nim(nMC)
    print(pi_est)
print(time() - s)
