# compare against scipy
import numpy as np
import scipy.linalg as la
from f77ex import mat_det

from itertools import permutations

np.random.seed(123456);

n = 5

a = np.random.normal(size=(n, n))

for p in permutations(np.arange(n)):
    pa = a[np.array(p)]
    ref = la.det(pa)
    tst = mat_det(pa)
    assert np.isclose(tst, ref), f'{ref=} {tst=}'
