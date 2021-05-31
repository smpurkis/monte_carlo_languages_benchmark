# Simple Monte Carlo simulation benchmark
Simple benchmark of languages with a simple monte carlo simulation. In Python, Cython, Numba, Julia, Nim.

Nim is called from Python using Nimpy. 
Cython extension can be compile with command:
```
cythonize -i3 monte_carlo.pyx
```

The Nim extension can be compiled command:

```
nim c --threads:on --app:lib -d:danger --d:O3 --gc:arc  --out:"monte_carlo_nim.so" monte_carlo_nim.nim 
```

The results of this simple benchmark:

```
numba time taken: 1.3051927089691162
numba (parallel) time taken: 0.44132113456726074
cython time taken: 2.9388206005096436
nim time taken: 4.1791863441467285
julia time taken: 1.650665
```

Numba and Julia are neck and neck others are lagging on this benchmark.